# 1. Solve for the continuum shock that will be used as the initial guess for the calibrated-shares procedure
# 2. Solve for the covariates-based model

import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames, JLD2, FileIO, StatFiles, UnPack, Roots

# Functions
include("../input/baseline_equilibrium_solver.jl")
include("../input/eha_solver.jl")
include("../input/employment_gap_fn.jl")
include("../input/hat_P.jl")

# Extract passed-in arguments
Λ = parse(Float64, ARGS[1])
@assert Λ ∈ [0, 0.1, 0.25, 0.5, 1.0]
headcount = parse(Float64, ARGS[2])
@assert headcount ∈ [2.488905, 5, 12.5, 25, 50, 125, 250, 2560]
A_shock = parse(Float64, ARGS[3])
@assert A_shock == 1.09
seed = parse(Int, ARGS[4])
@assert seed ∈ (1:200)

# Set arguments
treatmentID = 1145
σ = 4.0
α = 0.24
epsilon = abs(parse(Float64,read("../output/elasticity_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".csv",String)))

# Prepare data
primitives = load("../output/primitives_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".jld2")

# Load monte carlo iid dgp
df = CSV.read("../input/DGP_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".csv", DataFrame)

# Extract tract ID
orig_tractIDS = sort(dropmissing(DataFrame(load("../output/fe_i_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".dta"))).i)
dest_tractIDS = sort(dropmissing(DataFrame(load("../output/fe_j_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".dta"))).j)

# Import commuting costs from LODES
lodes_df = CSV.read("../input/nyc2010_lodes_wzero_wdelta.csv", DataFrame)
agg_labor = convert(Float64,sum(lodes_df[!,:X_ij]))
emp_b = sum(df[df[!,:id_j] .== treatmentID,:][!, :X_ij_before])
emp_a = sum(df[df[!,:id_j] .== treatmentID,:][!, :X_ij_after])
dgp_emp_change = emp_a - emp_b
emp_ratio = emp_a/emp_b
@assert emp_ratio > 1.0 "Error: Incorrect input"

(K, N) = size(primitives["delta_bar"])
A_pre = primitives["productivity"]
T_pre = primitives["landendowment"]
δ̄ = primitives["delta_bar"]

# Compute pre shock equilibrium
primitives_pre = (A_bar = A_pre, T = T_pre, δ_bar = δ̄, 
    λ = ones(K, N), 
    α = α, ε = epsilon, σ = σ, η = 0, ζ = 1.0, nests = nothing, L = agg_labor
)

cont_w_pre, cont_r_pre, ell_pre = cont_baseline_eqlm_solver(primitives_pre, 0.1, 1e-5, 1000, true)

# Compute initial share in the EHA
model_params = (
    α = α,
    ε = epsilon,
    σ = σ,
    η = 0.0,
    ζ = 1.0,
    nests = nothing,
    l_share = ell_pre ./ sum(ell_pre),
    y_share = (ell_pre .* cont_w_pre' ./ δ̄) ./ sum(ell_pre .* cont_w_pre' ./δ̄)
)

eha_comp_params = (tol = 1e-6, damp_low = 0.2, damp_high = 0.2, max_iter = 500)

# Find and save the required productivity
function compute_employment_gap_wrapper(prod_shock)
    Ā̂_star = ones(N)
    Ā̂_star[dest_tractIDS .== treatmentID] .= prod_shock
	exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K), δ̄̂ = ones(K, N), λ̂ = ones(K, N))
    ŵ_guess = exo_changes.Ā̂ .^ ((model_params.σ - 1) / (model_params.ε + model_params.σ))
    r̂_guess = ones(K) .* 1.0001
	gap = compute_employment_gap(ŵ_guess, r̂_guess, treatmentID, dest_tractIDS, dgp_emp_change, model_params, exo_changes, eha_comp_params, agg_labor)
    print("Prod shock: ", prod_shock, " Gap: ", gap, "\n")
    return gap
end

A_shock = find_zero(compute_employment_gap_wrapper,(1, 8), Roots.A42(), atol = 1e-6, maxiters = 200) 

save("../output/cbm_shock_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".jld2", "A_shock", A_shock)

# Compute post shock equilibrium using EHA solver
Ā̂_star = ones(N)
Ā̂_star[dest_tractIDS .== treatmentID] .= A_shock
exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K), δ̄̂ = ones(K, N), λ̂ = ones(K, N))
ŵ_guess = exo_changes.Ā̂ .^ ((model_params.σ - 1) / (model_params.ε + model_params.σ))
r̂_guess = ones(K) .* 1.0001
ŵ_star, r̂_star, l̂_star = eha_solver(ŵ_guess, r̂_guess, model_params, exo_changes, eha_comp_params; show_every=5)

# changes in commuting flows in the treated tract pair
ell_treated_pre = ell_pre[:, dest_tractIDS .== treatmentID][:]
ell_treated_post = (ell_pre .* l̂_star)[:, dest_tractIDS .== treatmentID][:]

@assert round(sum(ell_treated_post) - sum(ell_treated_pre),digits=0) == round(dgp_emp_change,digits=0)

# treated only commuting flows
ell_df = DataFrame(id_i = orig_tractIDS, x_ij_before = ell_treated_pre, x_ij_after = ell_treated_post)

# changes in prices
P̂_star = hat_P(Ā̂_star, ŵ_star, model_params.y_share, σ)
wages_df = DataFrame(id_j = dest_tractIDS, hat_w = ŵ_star, hat_realw = ŵ_star/P̂_star)
rents_df = DataFrame(id_i = orig_tractIDS, hat_r = r̂_star, hat_realr = r̂_star/P̂_star)

# Output
CSV.write("../output/prediction_cbm_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_ell.csv", ell_df)
CSV.write("../output/prediction_cbm_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_w.csv", wages_df)
CSV.write("../output/prediction_cbm_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_r.csv", rents_df)
save("../output/prediction_cbm_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_P_hat.jld2", "P_hat", P̂_star)