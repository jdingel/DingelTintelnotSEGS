import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, FileIO, JLD2, Parameters, StatFiles, UnPack

# rank
rank = abs(parse(Int64, ARGS[1]))
@assert rank ∈ [1, 2, 3]

# elasticities
epsilon = abs(parse(Float64,read("../input/nyc2010_time_elasticity_ife_"*string(rank)*".csv", String)))
alpha = 0.24
sigma = 4.0
eta = 0.0
zeta = 1.0

# commuting time
δ̄_mat = load("../input/nyc_delta_bar.jld2")["δ_bar"]

# shares
eqlm_outcomes = load("../input/baseline_equilibrium_outcomes_ife_"*string(rank)*".jld2")
fitted_l_mat = eqlm_outcomes["CommutingFlows"]
fitted_w = eqlm_outcomes["wages"]
fitted_l_share = fitted_l_mat ./ sum(fitted_l_mat)
fitted_y_share = (fitted_l_mat ./ δ̄_mat) .* fitted_w' ./ sum((fitted_l_mat ./ δ̄_mat) .* fitted_w')

tuple = (model_class = "ife_" * string(rank),
    α = alpha, 
    ε = epsilon, 
    σ = sigma, 
    η = eta, 
    ζ = zeta, 
    nests = nothing,
    l_share = fitted_l_share, 
    y_share = fitted_y_share)

save("../output/model_ife_"*string(rank)*".jld2", "model_parameters", tuple)
