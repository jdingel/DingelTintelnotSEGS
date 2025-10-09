import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames, JLD2, FileIO, StatFiles, UnPack, Roots

# Function
include("../input/eha_solver.jl")
include("../input/employment_gap_fn.jl")

# Extract passed-in arguments
Λ = parse(Float64, ARGS[1])
@assert Λ ∈ [0, 0.1, 0.25, 0.5, 1.0]
headcount = parse(Float64, ARGS[2])
@assert headcount ∈ [2.488905, 5, 12.5, 25, 50, 125, 250, 2560]
A_shock = parse(Float64, ARGS[3])
@assert A_shock == 1.09
seed = parse(Int, ARGS[4])
@assert seed ∈ (1:100)

# Set arguments
treatmentID = 1145
σ = 4.0
α = 0.24
epsilon = abs(parse(Float64,read("../input/elasticity_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".csv",String)))

# Prepare data
# Load simulated data (after approximation via SVD procedure)
df = CSV.read("../temp/DGP_approx_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_"*ARGS[5]*".csv", DataFrame)
dest_tractIDS = Array{Any,1}(unique(df[!,:id_j])) #list of destination IDs in order

# Extract tract IDs after dropping zero-resident tracts
orig_df = DataFrame(load("../input/fe_i_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".dta"))
orig_df = sort(orig_df[completecases(orig_df),:],[:i])
rename!(orig_df,["id_i","fe_i_ppml"])
orig_df[!,:id_i] = convert(Array{Int64,1}, orig_df[!,:id_i])

# Extract tract IDs after dropping zero-employment tracts
dest_df = DataFrame(load("../input/fe_j_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".dta"))
dest_df = sort(dest_df[completecases(dest_df),:], [:j])
dest_df = dest_df[completecases(dest_df),:]
rename!(dest_df,["id_j", "fe_j_ppml"])
dest_df[!,:id_j] = convert(Array{Int64,1}, dest_df[!,:id_j])

# Import commuting costs from LODES
lodes_df = CSV.read("../input/nyc2010_lodes_wzero_wdelta.csv", DataFrame)
agg_labor = convert(Float64,sum(lodes_df[!,:X_ij]))

delta_df = select(lodes_df, :id_j, :id_i, :delta)
rename!(delta_df, :delta=>:bardelta)

# Assign commuting costs
df = innerjoin(df, delta_df, on=[:id_i,:id_j])
df = sort(df, [:id_j, :id_i])

# Replace missing δ̄ with Inf and create a commuting cost matrix
df[!,:bardelta] = convert(Array{Float64,1},coalesce.(df[!,:bardelta],Inf))

# Because we drop zero-resident and zero-employment tracts, 
# K_dgp <= K and N_dgp <= N
K_dgp = length(unique(df[!,:id_i]))
N_dgp = length(unique(df[!,:id_j]))

if ARGS[5] != "full"
    svd_rank = parse(Int, ARGS[5])
else
    svd_rank = minimum([K_dgp, N_dgp])
end
@assert svd_rank in (1:2143)

# Replace missing δ̄ with Inf and create a commuting cost matrix
df[!,:bardelta] = convert(Array{Float64,1},coalesce.(df[!,:bardelta],Inf))
δ̄ = reshape(df[!,:bardelta], K_dgp, N_dgp)

# Load commuting matrix before the shock
ell_pre = reshape(df[!,:X_ij_before], K_dgp, N_dgp)

# Compute employment increase, using the continuum flows
cont_flows = CSV.read("../input/DGP_continuum_"*ARGS[1]*"_"*ARGS[3]*"_"*ARGS[4]*"_ell.csv", DataFrame)
emp_b = sum(cont_flows[cont_flows[!,:id_j] .== treatmentID,:][!,:X_ij_before])
emp_a = sum(cont_flows[cont_flows[!,:id_j] .== treatmentID,:][!,:X_ij_after])
dgp_emp_change = emp_a - emp_b
emp_ratio = emp_a/emp_b
@assert emp_ratio > 1.0

targeted_emp_a = sum(df[df[!,:id_j] .== treatmentID,:][!,:X_ij_before]) + dgp_emp_change

# Load continuum wages
wage_df = CSV.read("../input/DGP_continuum_"*ARGS[1]*"_"*ARGS[3]*"_"*ARGS[4]*"_w.csv", DataFrame)
wage_df = innerjoin(wage_df, dest_df, on =[:id_j])
wage_df = sort(wage_df,[:id_j])
wage = convert(Array{Float64, 1}, wage_df[!, :nom_w_pre])

# Find and save the required productivity shock
model_params = (
    α = α,
    ε = epsilon,
    σ = σ,
    η = 0.0,
    ζ = 1.0,
    nests = nothing,
    l_share = ell_pre ./ sum(ell_pre),
    y_share = (ell_pre .* wage' ./ δ̄) ./ sum(ell_pre .* wage' ./δ̄)
)

eha_comp_params = (tol = 1e-6, damp_low = 0.2, damp_high = 0.2, max_iter = 1000)

# Use numerical price guess to speed up the inner loop of the shock solver
Â_csp_guess = ones(N_dgp)
Â_csp_guess[dest_tractIDS .== treatmentID] .= A_shock
exo_changes = (Ā̂ = Â_csp_guess, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
ŵ_guess, r̂_guess, _ = eha_solver(ones(N_dgp), ones(K_dgp), model_params, exo_changes, eha_comp_params; show_every=5)

function compute_employment_gap_wrapper(prod_shock)
    Ā̂_star = ones(N_dgp)
    Ā̂_star[dest_tractIDS .== treatmentID] .= prod_shock
	exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
	gap = compute_employment_gap(ŵ_guess, r̂_guess, treatmentID, dest_tractIDS, dgp_emp_change, model_params, exo_changes, eha_comp_params, agg_labor)
    print("Prod shock: ", prod_shock, " Gap: ", gap, "\n")
    return gap
end

@time A_shock = find_zero(compute_employment_gap_wrapper,(1, 8), Roots.A42(), atol = 1e-6) 

@assert A_shock > 1.0 "Error: Incorrect solution"

save("../output/svd_shock_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_"*ARGS[5]*".jld2","A_shock", A_shock)

# post shock equilibrium
Ā̂_star = ones(N_dgp)
Ā̂_star[dest_tractIDS .== treatmentID] .= A_shock
exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
ŵ_star, r̂_star, l̂_star = eha_solver(ŵ_guess, r̂_guess, model_params, exo_changes, eha_comp_params; show_every=5)

# changes in commuting flows in the treated tract pair
ell_treated_pre = ell_pre[:, dest_tractIDS .== treatmentID][:]
ell_treated_post = (ell_pre .* l̂_star)[:, dest_tractIDS .== treatmentID][:]

@assert round(sum(ell_treated_post) - sum(ell_treated_pre),digits=0) == round(dgp_emp_change,digits=0)

# treated only commuting flows
ell_df = DataFrame(id_i = orig_df.id_i, x_ij_before = ell_treated_pre, x_ij_after = ell_treated_post)

# Output
CSV.write("../output/prediction_svd_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_"*ARGS[5]*"_ell.csv", ell_df)
