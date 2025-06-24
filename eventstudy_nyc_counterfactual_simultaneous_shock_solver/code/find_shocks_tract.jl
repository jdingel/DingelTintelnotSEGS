import Pkg
Pkg.activate("../input/Project.toml")
using FileIO, DataFrames, CSVFiles, StatFiles, StatsBase, Statistics, JLD2, UnPack

include("../input/eha_solver.jl") # EHA solver (the inner loop)
include("simultaneous_shock_solver.jl") # shock solver (the outer loop)
include("data_prep_functions.jl")

# EHA solver's input
model_class = ARGS[1]
model_params = load("../input/model_" * model_class * ".jld2")["model_parameters"]
eha_comp_params = (tol = 1e-6, damp_low = 0.2, damp_high = 0.2, max_iter = 500)

# shock solver's other inputs
pop,
treatment_idx, treatmentIDS,
observed_diff_level, 
L̂_temp = data_prep(
    "../input/nyc2010_lodes_wzero_wdelta.dta",
    "../input/nyc_2012_2010_observed_changes_dest_tract.dta",
    "../temp/treatmentIDS.csv"
)

# initial guess for Â
if split(model_class, "_")[1] ∈ ["cbm", "csp"]
    model_name = split(model_class, "_")[1]
elseif split(model_class, "_")[1] ∈ ["svd", "nnmf"]
    ## SVD, NNMF, SVD(diag) variations
    model_name = "csp"
else
    model_name = "cbm"
end

baseline_ell_matrix = model_params.l_share .* pop # fitted ℓ_{kn} for CBM; observed ℓ_{kn} for CSP
baseline_emp_treated = (sum(baseline_ell_matrix, dims = 1)[treatment_idx])[:]

# price guess for the inner loop (EHA solver)
(K, N) = size(model_params.l_share)
L̂ = ones(N)
L̂[treatment_idx] = L̂_temp[treatment_idx]
@unpack ζ = model_params
ε_compute = (ζ == 1.0) ? (model_params.ε) : (model_params.ε_ring)
ŵ_guess = L̂ .^ (ζ/ε_compute)
r̂_guess = ones(K)

## outer loop computational parameters
Â_guess = load("../temp/simultaneous_shock_" * model_name * ".jld2")["tract_shock_pairings"][!,2]

# common parameters
max_iter = 2000
outerloop_tol = 0.01

# model-specific parameters
mediation = 1e4
proportional_gain = 0.6
outerloop_tol = 0.01

@unpack ζ = model_params

if ζ == 1.0
    @unpack σ, η = model_params

    if σ == Inf
        proportional_gain = 0.9
        eha_comp_params = (tol = 1e-6, damp_low = 0.1, damp_high = 0.1, max_iter = 500)
    end

    if σ == 1.1 
        proportional_gain = 0.0
        mediation = 100
        eha_comp_params = (tol = 1e-6, damp_low = 0.02, damp_high = 0.02, max_iter = 1000)
    end

    if η > 0
        mediation = 1e5
        proportional_gain = 0.1
    end

elseif ζ == 0.25
    mediation = 25000
    proportional_gain = 0.4
    eha_comp_params = (tol = 1e-6, damp_low = 0.1, damp_high = 0.1, max_iter = 500)

else 
    mediation = 22500
    proportional_gain = 0.1
    eha_comp_params = (tol = 1e-6, damp_low = 0.1, damp_high = 0.1, max_iter = 500)
end

if split(model_class, "_")[1] ∈ ["svd", "nnmf", "ife"]
    mediation = 20000
    max_iter = 1000
    proportional_gain = 0.4
    outerloop_tol = 0.01
end

# main
@time treatment_shocks_new = shock_solver_loop(model_params, eha_comp_params, 
	ŵ_guess, r̂_guess, Â_guess,
	baseline_emp_treated, treatment_idx, baseline_ell_matrix, 
	observed_diff_level, proportional_gain, outerloop_tol, mediation, max_iter
)

# save solution
tract_shock_pairing_new = DataFrame(hcat(treatmentIDS, treatment_shocks_new), :auto)
save("../output/simultaneous_shock_" * model_class * ".jld2", "tract_shock_pairings", tract_shock_pairing_new)