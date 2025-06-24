import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, Roots, StatFiles, StatsBase, Statistics, Parameters, UnPack

include("../input/eha_solver.jl")

# baseline model
model_label = ARGS[1]
model_params = load("../input/model_" * model_label * ".jld2")["model_parameters"]
(K, N) = size(model_params.l_share)

# total population
baseline_ell_data = DataFrame(load(ARGS[2]))
pop = sum(baseline_ell_data.X_ij)

# counterfactual commuting flows given Â_star
treatmentIDS = load("../input/simultaneous_shock_" * model_label * ".jld2")["tract_shock_pairings"].x1
shocks = load("../input/simultaneous_shock_" * model_label * ".jld2")["tract_shock_pairings"].x2
worktractIDS = convert(Array{Any}, unique(baseline_ell_data[!, :j]))
treatment_idx = findall(in(treatmentIDS), worktractIDS)
Â_star = ones(N)
Â_star[treatment_idx] .= shocks

# pack into a NamedTuple
changes = (Ā̂ = Â_star, T̂ = ones(K), δ̄̂ = ones(K, N), λ̂ = ones(K, N))

# computational parameters
@unpack σ, ζ = model_params
if σ == 1.1
    comp_params = (tol = 1e-6, damp_low = 0.01, damp_high = 0.02, max_iter = 2000)
else
    comp_params = (tol = 1e-6, damp_low = 0.1, damp_high = 0.2, max_iter = 500)
end

# initial guess for counterfactual prices
r̂_guess = ones(K)
if ζ == 1.0
    ε_compute = model_params.ε
else
    ε_compute = model_params.ε_ring
end

if σ == Inf
    ŵ_guess = Â_star
else
    ŵ_guess = Â_star .^ ((σ - 1) / (ε_compute + σ))
end

# compute counterfactual with EHA
println(" Model parameters :", keys(model_params))
ŵ_star, r̂_star, l̂_star = eha_solver(ŵ_guess, r̂_guess, model_params, changes, comp_params)

# compute levels
baseline_ell_matrix = model_params.l_share .* pop # fitted ℓ_{kn} for CBM; observed ℓ_{kn} for CSP
predicted_ell = baseline_ell_matrix .* l̂_star
println("counterfactual total commuters : ", sum(predicted_ell))
println("basline total commuters : ", sum(baseline_ell_matrix))
@assert abs(sum(predicted_ell) - sum(baseline_ell_matrix)) < 1.0

# save as csv files for the analysis with Stata
commuters_df = select!(baseline_ell_data, ([:i, :j]))
commuters_df = sort(commuters_df,[:j, :i])
commuters_df.x_baseline = baseline_ell_matrix[:]
commuters_df.x_ctfl = predicted_ell[:]

# write the combined DataFrame to a CSV file
CSV.write("../output/nyc_obs_" * model_label * "_all.csv", commuters_df)