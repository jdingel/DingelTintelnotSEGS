import Pkg
Pkg.activate("../input/Project.toml")
using FileIO, DataFrames, CSVFiles, StatFiles, StatsBase, Statistics, JLD2, UnPack

include("../input/eha_solver.jl") # EHA solver (the inner loop)
include("simultaneous_shock_solver.jl") # shock solver (the outer loop)
include("data_prep_functions.jl")

model_class = ARGS[1]
@assert model_class ∈ ["cbm_nta", "csp_nta"]

# EHA solver's input
model_params = load("../input/model_" * model_class * ".jld2")["model_parameters"]
eha_comp_params = (tol = 1e-6, damp_low = 0.2, damp_high = 0.2, max_iter = 500)
ε = model_params.ε
σ = model_params.σ

# shock solver's other inputs
pop,
treatment_idx, treatmentIDS,
observed_diff_level, 
observed_diff_ratio = data_prep(
    "../input/nyc_NTA_2010_lodes_wzero_wdelta.dta", 
	"../input/nyc_NTA_2012_2010_observed_changes_dest.dta",
    "../temp/treatmentIDS_NTA.csv"
)

Â_guess =  observed_diff_ratio[treatment_idx] .^((σ/(σ-1))*(1/ε+1/σ))

baseline_ell_matrix = model_params.l_share .* pop
baseline_emp_treated = (sum(baseline_ell_matrix, dims = 1)[treatment_idx])[:]

# price guess
(K, N) =  size(model_params.l_share)
L̂ = ones(N)
L̂[treatment_idx] = observed_diff_ratio[treatment_idx]

ŵ_guess = L̂.^(1/ε)
r̂_guess = ones(K)

# solve for Â
mediation = 1e4
max_iter = 1000
proportional_gain = 0.9
outerloop_tol = 0.01

treatment_shocks_new = shock_solver_loop(model_params, eha_comp_params, 
    ŵ_guess, r̂_guess, Â_guess,
    baseline_emp_treated, treatment_idx, baseline_ell_matrix, 
    observed_diff_level, proportional_gain, outerloop_tol, mediation, max_iter
)

# save solution
tract_shock_pairing_new = DataFrame(hcat(treatmentIDS, treatment_shocks_new), :auto)
save("../output/simultaneous_shock_" * model_class * ".jld2", "tract_shock_pairings", tract_shock_pairing_new)