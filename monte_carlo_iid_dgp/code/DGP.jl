import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames, Distributions, JLD2, FileIO, StatFiles, Statistics, Random, UnPack

# Functions
include("../input/finitemodel_programs.jl") # labor_allocation()
include("../input/baseline_equilibrium_solver.jl") # cont_baseline_eqlm_solver()

# Extract passed-in arguments
Λ = parse(Float64, ARGS[1])
@assert Λ ∈ [0.0, 0.1, 0.25, 0.5, 1.0]
headcount = parse(Float64, ARGS[2]) * 1e6
@assert headcount ∈ [2.488905, 5, 12.5, 25, 50, 125, 250, 2560] .* 1e6
A_shock = parse(Float64, ARGS[3])
@assert A_shock ∈ [1.00, 1.09]
seed = parse(Int, ARGS[4])
@assert seed ∈ (1:200)

# Set arguments
treated_id = 1145
σ = 4.0
α = 0.24
ε = abs(parse(Float64,read("../input/nyc2010_time_elasticity.csv",String)))
primitives = load("../input/primitives_nyc2010_time.jld2")
A_pre = primitives["productivity"]
T_pre = primitives["landendowment"]
LODES2010 = CSV.read("../temp/nyc2010_lodes_wzero_wdelta.csv", DataFrame)
LODES2010 = sort(LODES2010, [:id_j, :id_i])
agg_labor = convert(Float64,sum(LODES2010[!,:X_ij]))

δ̄ = primitives["delta_bar"]
(K, N) = size(δ̄)
log_δ̄ = log.(δ̄)

# Draw log(λₖₙ)
std_log_δ̄ = std(vec(log_δ̄)[vec(log_δ̄) .!=Inf]) # There are two tract pairs where commute infeasible
std_log_λ_pop = Λ * std_log_δ̄
Random.seed!(seed);
log_λ = rand(Normal(0, std_log_λ_pop), size(log_δ̄)) # The 2nd argument of Normal() is std.
λ = exp.(log_λ)

# Compute δ = δ̄ * λ
δ = exp.(log_δ̄ .+ log_λ)

# Double-check Monte Carlo DGP
println("Population variance of log(λ): ", std_log_λ_pop^2)
println("Sample variance of log(λ): ", var(log_λ))
@assert abs((std_log_λ_pop^2)/var(log_λ) - 1) < 0.05 || Λ .== 0.0

# Draw one realization from the baseline parameters
wb_guess = (A_pre/A_pre[1]).^((σ-1)/(σ+ε)) 
r_guess = 1 ./ T_pre

primitives_pre = (A_bar = A_pre, T = T_pre, δ_bar = δ̄, 
    λ = exp.(log_λ), 
    α = α, ε = ε, σ = σ, η = 0, ζ = 1.0, nests = nothing, L = agg_labor
)

w_pre, r_pre, ell_pre = cont_baseline_eqlm_solver(primitives_pre, 0.1, 1e-5, 1000, true)
prob_pre = ell_pre ./ sum(ell_pre)

ell_pre_mat = reshape(labor_realization(length(r_pre), length(w_pre), prob_pre[:], headcount, agg_labor, seed), K, N)

# Check aggregate labor sum
println("Simulated agg labor: ", sum(ell_pre_mat))
@assert abs(sum(ell_pre_mat) / agg_labor - 1) < 1e-3

# Draw one realization from the counterfactual parameters
A_post = copy(A_pre)
A_post[treated_id] = A_post[treated_id] .* A_shock 

primitives_post = (A_bar = A_post, T = T_pre, δ_bar = δ̄, 
    λ = exp.(log_λ), 
    α = α, ε = ε, σ = σ, η = 0, ζ = 1.0, nests = nothing, L = agg_labor
)

w_post, r_post, ell_post = cont_baseline_eqlm_solver(primitives_post, 0.1, 1e-5, 1000, true)
prob_post = ell_post ./ sum(ell_post)
ell_post_mat = reshape(labor_realization(length(r_post), length(w_post), prob_post[:], headcount, agg_labor, seed+1), K, N)

# Check aggregate labor sum
println("Simulated agg labor: ", sum(ell_post_mat))
@assert abs(sum(ell_post_mat) / agg_labor - 1) < 1e-3

# Prepare dataframe
df_out = DataFrame(hcat(LODES2010[!,:id_j], LODES2010[!,:id_i], ell_pre_mat[:], ell_post_mat[:]), :auto)
df_out = rename!(df_out, ["id_j", "id_i", "X_ij_before", "X_ij_after"])
df_out[!,:id_i] = convert(Array{Int64,1}, df_out[!,:id_i])
df_out[!,:id_j] = convert(Array{Int64,1}, df_out[!,:id_j])

## Remove zero employment and zero resident tracts
res_b = sum(ell_pre_mat, dims = 2)[:]
emp_b = sum(ell_pre_mat, dims = 1)[:]
zero_res_tract = findall(iszero, res_b)
zero_emp_tract = findall(iszero, emp_b)

if length(zero_emp_tract) > 0
    df_out = filter(row -> !(row.id_j in zero_emp_tract), df_out)
end

if length(zero_res_tract) > 0
    df_out = filter(row -> !(row.id_i in zero_res_tract), df_out)
end


# Construct the report file path
log_file = "../report/DGP_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".csv.log"

# Get the first five and last five rows
first_five = first(df_out, 5)
last_five = last(df_out, 5)

open(log_file, "w") do f

    if length(zero_emp_tract) > 0
        println(f, "Removed zero-employment workplace tracts: ", zero_emp_tract)
    else
        println(f, "No zero-employment workplace tracts.")
    end

    if length(zero_res_tract) > 0
        println(f, "Removed zero-resident residential tracts: ", zero_res_tract)
    else
        println(f, "No zero-resident residential tracts.")
    end

    # Write these rows to the reports
    println(f, "\nThe first five rows are:")
    show(f, MIME"text/plain"(), first_five)
    
    println(f, "\nThe last five rows are:")
    show(f, MIME"text/plain"(), last_five)
end

# Output
CSV.write("../output/DGP_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".csv", df_out)