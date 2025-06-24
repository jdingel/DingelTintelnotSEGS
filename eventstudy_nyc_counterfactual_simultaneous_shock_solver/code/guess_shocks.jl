import Pkg
Pkg.activate("../input/Project.toml")
using FileIO, DataFrames, CSVFiles, StatFiles, StatsBase, Statistics, JLD2, UnPack

include("../input/eha_solver.jl") # EHA solver (the inner loop)
include("simultaneous_shock_solver.jl") # shock solver (the outer loop)
include("data_prep_functions.jl")

# EHA solver's input
model_class = ARGS[1]
@assert model_class ∈ ["cbm", "csp"]
model_params = load("../input/model_" * model_class * "_sigma_4.0.jld2")["model_parameters"]
eha_comp_params = (tol = 1e-6, damp_low = 0.2, damp_high = 0.2, max_iter = 500)
@unpack ε, σ, ζ = model_params

# shock solver's other inputs
pop,
treatment_idx, treatmentIDS,
observed_diff_level, 
L̂_temp = data_prep(
	"../input/nyc2010_lodes_wzero_wdelta.dta",
	"../input/nyc_2012_2010_observed_changes_dest_tract.dta",
	"../temp/treatmentIDS.csv"
)

baseline_ell_matrix = model_params.l_share .* pop
baseline_emp_treated = (sum(baseline_ell_matrix, dims = 1)[treatment_idx])[:]

# price guess for the inner loop (EHA solver)
(K, N) =  size(model_params.l_share)
L̂ = ones(N)
L̂[treatment_idx] = L̂_temp[treatment_idx]
ŵ_guess = L̂.^(1/ε)
r̂_guess = ones(K)

# solve for Â
Â_guess = L̂[treatment_idx] .^((σ/(σ-1))*(1/ε+1/σ))

mediation = 1e4
max_iter = 1000
proportional_gain = 0.6
outerloop_tol = 0.01

@time treatment_shocks_new = shock_solver_loop(model_params, eha_comp_params, 
	ŵ_guess, r̂_guess, Â_guess,
	baseline_emp_treated, treatment_idx, baseline_ell_matrix, 
	observed_diff_level, proportional_gain, outerloop_tol, mediation, max_iter
)

# save solution
tract_shock_pairing_new = DataFrame(hcat(treatmentIDS, treatment_shocks_new), :auto)
save("../temp/simultaneous_shock_" * model_class * ".jld2", "tract_shock_pairings", tract_shock_pairing_new)