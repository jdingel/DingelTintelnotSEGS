import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatFiles, Statistics, Random, Distributions, UnPack

# Functions
include("../input/baseline_equilibrium_solver.jl")

# Helper function 
# Compute the mean utility before and after 
function calculate_mean_util(wagebelief, rentbelief, productivity, δ̄, α, ε, σ)
    @assert length(rentbelief) == size(δ̄, 1)
    @assert length(wagebelief) == size(δ̄, 2)
    (K, N) = size(δ̄)
    λ = ones(K, N)
    δ = δ̄ .* λ

    P = (sum((wagebelief ./ productivity) .^ (1 - σ))) ^ (1 / (1 - σ))
    mean_util = ε * log.(transpose(wagebelief) .* (rentbelief).^(-α) .* P.^(-(1-α)) .* δ.^(-1))

    # reshape 
    return mean_util[:]
end

# Argument
A_shock = parse(Float64, ARGS[1]) # Productivity increase
@assert A_shock == 1.09
treatmentID = 1145 # Tiffany tract

# Elasticities and other model primitives
σ = 4.0 
α = 0.24
ε = abs(parse(Float64,read("../input/nyc2010_time_elasticity.csv", String)))

primitives = load("../input/primitives_nyc2010_time.jld2")
agg_labor = primitives["pop"]
A_pre = primitives["productivity"]
T_pre = primitives["landendowment"]
δ̄ = primitives["delta_bar"]
(K, N) = size(δ̄)

# LODES2010 has columns on row, residence tract (i) and workplace tract (j) 
lodes_df = sort(CSV.read("../input/nyc2010_lodes_wzero_wdelta.csv", DataFrame), [:id_j, :id_i])
dest_tractIDS = sort(unique(lodes_df[!, :id_j]))

A_post = copy(A_pre)
A_post[dest_tractIDS .==treatmentID] = A_shock * A_pre[dest_tractIDS .== treatmentID]

# Compute pre shock equilibrium
primitives_pre = (A_bar = A_pre, T = T_pre, δ_bar = δ̄, 
    λ = ones(K, N), 
    α = α, ε = ε, σ = σ, η = 0, ζ = 1.0, nests = nothing, L = agg_labor
)

w_pre, r_pre, ell_pre = cont_baseline_eqlm_solver(primitives_pre, 0.1, 1e-5, 1000, true)

# Compute post shock equilibrium
primitives_post = (A_bar = A_post, T = T_pre, δ_bar = δ̄, 
    λ = ones(K, N), 
    α = α, ε = ε, σ = σ, η = 0, ζ = 1.0, nests = nothing, L = agg_labor
)

w_post, r_post, ell_post = cont_baseline_eqlm_solver(primitives_post, 0.1, 1e-5, 1000, true)

# Compute U_{kn} for "before" and "after" equilibria
mean_util_before = calculate_mean_util(w_pre, r_pre, A_pre, δ̄, α, ε, σ)
mean_util_after = calculate_mean_util(w_post, r_post, A_post, δ̄, α, ε, σ)

df_mean_util = DataFrame(mean_util_before=mean_util_before, mean_util_after=mean_util_after)
df_mean_util[!,:row_id] = collect(1:length(df_mean_util[!,:mean_util_before]))

tract_pair_ID = sort(lodes_df[:, [:id_i,:id_j]], [:id_j, :id_i])
tract_pair_ID[!,:row_id] = 1:length(δ̄)

# Output mean utilities in the eqlba before and after
CSV.write("../temp/mean_util_"*ARGS[1]*"_fixednu.csv", innerjoin(tract_pair_ID, df_mean_util, on=:row_id))

