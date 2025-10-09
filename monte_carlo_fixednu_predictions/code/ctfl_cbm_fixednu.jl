#Purpose: calculates the required productivity shock that matches the employment boom in DGP and predicts the counterfactual employment change

import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames, JLD2, FileIO, StatFiles, UnPack, Roots

# Function
include("../input/baseline_equilibrium_solver.jl")
include("../input/eha_solver.jl")
include("../input/employment_gap_fn.jl")

# Extract passed-in arguments
A_shock = parse(Float64, ARGS[1])
@assert A_shock == 1.09
seed = parse(Int, ARGS[2])
@assert seed ∈ (1:100)

# Set arguments
treatmentID = 1145
σ = 4.0
α = 0.24
epsilon = abs(parse(Float64,read("../temp/elasticity_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.csv",String)))

# Prepare data
primitives = load("../temp/primitives_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.jld2")
agg_labor = primitives["pop"]

df = CSV.read("../input/DGP_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.csv", DataFrame)


orig_df = DataFrame(load("../temp/fe_i_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.dta"))
orig_df = sort(orig_df[completecases(orig_df),:],[:i])
rename!(orig_df,["id_i","fe_i_ppml"])

dest_df = DataFrame(load("../temp/fe_j_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.dta"))
dest_df = sort(dest_df[completecases(dest_df),:],[:j])
rename!(dest_df,["id_j", "fe_j_ppml"])
dest_tractIDS = dest_df.id_j

emp_b = sum(df[df[!,:id_j] .== treatmentID,:][!,:X_ij_before])
emp_a = sum(df[df[!,:id_j] .== treatmentID,:][!,:X_ij_after])
emp_increase = emp_a - emp_b

(K_dgp, N_dgp) = size(primitives["delta_bar"])
A_pre = primitives["productivity"]
T_pre = primitives["landendowment"]
δ̄ = primitives["delta_bar"]

## pre shock equilibrium
primitives_pre = (A_bar = A_pre, T = T_pre, δ_bar = δ̄, 
    λ = ones(K_dgp, N_dgp), 
    α = α, ε = epsilon, σ = σ, η = 0, ζ = 1.0, nests = nothing, L = agg_labor
)

w_pre, r_pre, ell_pre = cont_baseline_eqlm_solver(primitives_pre, 0.1, 1e-5, 1000, true)
pn_pre = (w_pre ./ A_pre).^(1-σ)
replace!(pn_pre, Inf => 0.0)
P_pre = (sum(pn_pre))^(1/(1-σ))

# Find and save the required productivity
model_params = (
    α = α,
    ε = epsilon,
    σ = σ,
    η = 0.0,
    ζ = 1.0,
    nests = nothing,
    l_share = ell_pre ./ sum(ell_pre),
    y_share = (ell_pre .* w_pre' ./ δ̄) ./ sum(ell_pre .* w_pre' ./δ̄)
)

eha_comp_params = (tol = 1e-6, damp_low = 0.2, damp_high = 0.2, max_iter = 500)

function compute_employment_gap_wrapper(prod_shock)
    Ā̂_star = ones(N_dgp)
    Ā̂_star[dest_tractIDS .== treatmentID] .= prod_shock
	exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
    ŵ_guess = exo_changes.Ā̂ .^ ((model_params.σ - 1) / (model_params.ε + model_params.σ))
    r̂_guess = ones(K_dgp) .* 1.0001
	gap = compute_employment_gap(ŵ_guess, r̂_guess, treatmentID, dest_tractIDS, emp_increase, model_params, exo_changes, eha_comp_params, agg_labor)
    print("Prod shock: ", prod_shock, " Gap: ", gap, "\n")
    return gap
end

A_shock = find_zero(compute_employment_gap_wrapper,(1, 8), Roots.A42(), atol = 1e-6) 

save("../temp/cbm_shock_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.jld2", "A_shock", A_shock)

# Compute post shock equilibrium using EHA solver
Ā̂_star = ones(N_dgp)
Ā̂_star[dest_tractIDS .== treatmentID] .= A_shock
exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
ŵ_star, r̂_star, l̂_star = eha_solver(ones(N_dgp), ones(K_dgp), model_params, exo_changes, eha_comp_params; show_every=5)

# changes in commuting flows in the treated tract pair
ell_treated_pre = ell_pre[:, dest_tractIDS .== treatmentID][:]
ell_treated_post = (ell_pre .* l̂_star)[:, dest_tractIDS .== treatmentID][:]

ell_change = ell_treated_post .- ell_treated_pre
output_df = DataFrame(id_i = orig_df.id_i, id_j = treatmentID, diff_cbm = ell_change)

# Output
CSV.write("../output/prediction_cbm_"*ARGS[1]*"_"*ARGS[2]*"_treated_ell_change_fixednu.csv", output_df)
