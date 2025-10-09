import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, FileIO, JLD2, Parameters, StatFiles, UnPack

model_class = ARGS[1]
@assert model_class ∈ ["ntaorigin", "workplace", "residence"]

# elasticities
zeta = parse(Float64, ARGS[2])
@assert zeta ∈ [0.25, 0.50, 0.75]
epsilon_ring = zeta * abs(parse(Float64,read("../input/nyc2010_time_elasticity.csv", String)))
alpha = 0.24
sigma = 4.0
eta = 0.0

# commuting time
δ̄_mat = load("../input/nyc_delta_bar.jld2")["δ_bar"]
(K, N) = size(δ̄_mat)

# shares
eqlm_outcomes = load("../input/baseline_equilibrium_outcomes_"* model_class *"_"*string(zeta)*".jld2")
fitted_l_mat = eqlm_outcomes["CommutingFlows"]
fitted_w = eqlm_outcomes["wages"]
fitted_l_share = fitted_l_mat ./ sum(fitted_l_mat)
fitted_y_share = (fitted_l_mat ./ δ̄_mat) .* fitted_w' ./ sum((fitted_l_mat ./ δ̄_mat) .* fitted_w')

tuple = (model_class = "cbm_" * model_class,
    α = alpha, 
    ε_ring = epsilon_ring, 
    σ = sigma, 
    η = eta, 
    ζ = zeta, 
    nests = load("../input/primitives_nyc2010_time_" * model_class * "_" * string(zeta) * ".jld2")["nests"],
    l_share = fitted_l_share, 
    y_share = fitted_y_share)

save("../output/model_cbm_" * model_class * "_"*string(zeta)*".jld2", "model_parameters", tuple)
