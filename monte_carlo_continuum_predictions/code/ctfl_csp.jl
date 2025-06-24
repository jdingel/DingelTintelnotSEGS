# This script computes the productivity shock that causes the CSP to produce 
# a total employment increase that matches the continuum model’s employment increase.
# It then produces the CSP counterfactual predictions for the consequences of this productivity shock.

import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames, JLD2, FileIO, StatFiles, UnPack, Roots

# Functions
include("../input/employment_gap_fn.jl")
include("../input/eha_solver.jl")
include("../input/hat_P.jl")

# Extract passed-in arguments
Λ = parse(Float64, ARGS[1])
@assert Λ ∈ [0.0, 0.1, 0.25, 0.5, 1.0]
headcount = parse(Float64, ARGS[2]) * 1e6
@assert headcount ∈ [2.488905, 5, 12.5, 25, 50, 125, 250, 2560] .* 1e6
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
# Load monte carlo iid dgp
df = CSV.read("../input/DGP_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".csv", DataFrame)
df = sort(df, [:id_j, :id_i])
dest_tractIDS = sort(unique(df[!,:id_j])) #list of destination IDs in order
orig_tractIDS = sort(unique(df[!,:id_i])) #list of origin IDs in order

# Import commuting costs from LODES
lodes_df = CSV.read("../input/nyc2010_lodes_wzero_wdelta.csv", DataFrame)
agg_labor = convert(Float64, sum(lodes_df[!,:X_ij]))

delta_df = select(lodes_df, :id_j, :id_i, :delta)
rename!(delta_df, :delta=>:bardelta)

# Assign commuting costs
df = innerjoin(df, delta_df, on=[:id_i,:id_j])
df = sort(df, [:id_j, :id_i])

# Replace missing δ̄ with Inf and create a commuting cost matrix
df[!,:bardelta] = convert(Array{Float64,1}, coalesce.(df[!,:bardelta],Inf))

# Because we drop zero-resident and zero-employment tracts, 
# K_dgp <= K and N_dgp <= N
K_dgp = length(unique(df[!,:id_i]))
N_dgp = length(unique(df[!,:id_j]))
δ̄ = reshape(df[!,:bardelta], K_dgp, N_dgp)

# Load commuting matrix before the shock
ell_pre = reshape(df[!,:X_ij_before], K_dgp, N_dgp)

# Compute employment increase, using the continuum flows
emp_dgp_b = sum(df[df[!,:id_j] .== treatmentID, :X_ij_before])
emp_dgp_a = sum(df[df[!,:id_j] .== treatmentID, :X_ij_after])

# Load employment changes in the treated tract from the continuum model
df_dgp_id = select(df, :id_j, :id_i)
df_changes = CSV.read("../input/DGP_continuum_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_ell.csv", DataFrame)

# Merge with `monte carlo iid dgp` to remove zero-employment and zero-resident tracts
df_changes = innerjoin(df_dgp_id, df_changes, on = [:id_j, :id_i])

emp_cont_b = sum(df_changes[df_changes[!,:id_j] .== treatmentID, :X_ij_before])
emp_cont_a = sum(df_changes[df_changes[!,:id_j] .== treatmentID, :X_ij_after])
emp_increase = emp_cont_a - emp_cont_b
@assert emp_increase > 0 "Error: Incorrect input"

# See comment on lines 108-112
emp_a = (emp_cont_a - emp_cont_b) + emp_dgp_b

# Load A shock solved by CBM as initial guess for CSP
Â_guess = load("../output/cbm_shock_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".jld2")["A_shock"]

# Load continuum wages
wage_df = CSV.read("../input/DGP_continuum_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_w.csv", DataFrame)
wage_df = innerjoin(wage_df, DataFrame(id_j = dest_tractIDS), on=:id_j)
wage = convert(Array{Float64, 1}, wage_df[!, :nom_w_pre])

# Compute initial share in the EHA
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
Â_csp_guess[dest_tractIDS .== treatmentID] .= Â_guess
exo_changes = (Ā̂ = Â_csp_guess, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
ŵ_guess, r̂_guess, _ = eha_solver(ones(N_dgp), ones(K_dgp), model_params, exo_changes, eha_comp_params; show_every=5)

# Find and save the required productivity
function compute_employment_gap_wrapper(prod_shock)
    Ā̂_star = ones(N_dgp)
    Ā̂_star[dest_tractIDS .== treatmentID] .= prod_shock
	exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
	gap = compute_employment_gap(ŵ_guess, r̂_guess, treatmentID, dest_tractIDS, emp_increase, model_params, exo_changes, eha_comp_params, agg_labor)
    print("Prod shock: ", prod_shock, " Gap: ", gap, "\n")
    return gap
end

@time Â_treated = find_zero(compute_employment_gap_wrapper,(1, 8), Roots.A42(), atol = 1e-6) 
@assert Â_treated > 1.0 "Error: Incorrect solution"

save("../output/csp_shock_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".jld2","A_shock", Â_treated)

# Compute post shock equilibrium using EHA
Ā̂_star = ones(N_dgp)
Ā̂_star[dest_tractIDS .== treatmentID] .= Â_treated
exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
ŵ_star, r̂_star, l̂_star = eha_solver(ones(N_dgp), ones(K_dgp), model_params, exo_changes, eha_comp_params; show_every=5)

# changes in commuting flows in the treated tract pair
ell_treated_pre = ell_pre[:, dest_tractIDS .== treatmentID][:]
ell_treated_post = (ell_pre .* l̂_star)[:, dest_tractIDS .== treatmentID][:]

# treated only commuting flows
ell_df = DataFrame(id_i = orig_tractIDS, x_ij_before = ell_treated_pre, x_ij_after = ell_treated_post)

# changes in prices
P̂_star = hat_P(Ā̂_star, ŵ_star, model_params.y_share, σ)
wages_df = DataFrame(id_j = dest_tractIDS, hat_w = ŵ_star, hat_realw = ŵ_star/P̂_star)
rents_df = DataFrame(id_i = orig_tractIDS, hat_r = r̂_star, hat_realr = r̂_star/P̂_star)

# Output
CSV.write("../output/prediction_csp_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_ell.csv", ell_df)
CSV.write("../output/prediction_csp_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_w.csv", wages_df)
CSV.write("../output/prediction_csp_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_r.csv", rents_df)
save("../output/prediction_csp_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_P_hat.jld2", "hat_P", hat_P)