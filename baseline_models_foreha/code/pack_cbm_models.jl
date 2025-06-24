import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, FileIO, JLD2, Parameters, StatFiles, UnPack

# helper function
function level_to_shares(eqlm_file, δ̄_mat)
    eqlm_outcomes = load(eqlm_file)
    fitted_l_mat = eqlm_outcomes["CommutingFlows"]
    fitted_w = eqlm_outcomes["wages"]
    fitted_l_share = fitted_l_mat ./ sum(fitted_l_mat)
    fitted_y_share = (fitted_l_mat ./ δ̄_mat).* fitted_w' ./ sum((fitted_l_mat ./ δ̄_mat) .* fitted_w')
    return fitted_l_share, fitted_y_share
end

function save_model_parameters(model_class, δ̄_file, elasticity_file, eqlm_file, output_file, sigma, eta)
    δ̄_mat = load(δ̄_file)["delta_bar"]
    epsilon = abs(parse(Float64, read(elasticity_file, String)))
    
    # shares
    fitted_l_share, fitted_y_share = level_to_shares(eqlm_file, δ̄_mat)

    tuple = (model_class = "cbm_" * model_class,
        α = alpha,
        ε = epsilon,
        σ = sigma,
        η = eta,
        ζ = zeta,
        nests = nothing,
        l_share = fitted_l_share,
        y_share = fitted_y_share)

    save(output_file, "model_parameters", tuple)
end

# housing expenditure share  (Davis and Ortalo-Magne, 2011)
const alpha = 0.24

# nested-logit correlation parameter (corr = 1 - ζ^2)    
const zeta = 1.0

# model name 
model_class = ARGS[1]
@assert model_class ∈ ["sigma", "eta", "pool_2008_2010", "nta", "dist"]


# CBM_sigma begin
if model_class == "sigma"
    sigma = parse(Float64, ARGS[2])
    @assert sigma ∈ [1.1, 4.0, Inf]

    save_model_parameters(
        model_class,
        "../input/primitives_nyc2010_time.jld2",
        "../input/nyc2010_time_elasticity.csv",
        "../input/baseline_equilibrium_outcomes_sigma_" * string(sigma) * ".jld2",
        "../output/model_cbm_sigma_" * string(sigma) * ".jld2",
        sigma,
        0.0 # eta
    )
end
# CBM_sigma end

# CBM_eta begin
if model_class == "eta"
    eta = parse(Float64, ARGS[2])
    @assert eta ∈ [0.0028, 0.001, 0.1]

    save_model_parameters(
        model_class,
        "../input/primitives_nyc2010_time.jld2",
        "../input/nyc2010_time_elasticity.csv",
        "../input/baseline_equilibrium_outcomes_eta_" * string(eta) * ".jld2",
        "../output/model_cbm_eta_" * string(eta) * ".jld2",
        4.0, # sigma
        eta
    )
end
# CBM_eta end

# CBM_pool_2008_2010 begin
if model_class == "pool_2008_2010"
    save_model_parameters(
        model_class,
        "../input/primitives_nyc_pool_2008_2010_time.jld2",
        "../input/nyc_pool_2008_2010_time_elasticity.csv",
        "../input/baseline_equilibrium_outcomes_pool_2008_2010.jld2",
        "../output/model_cbm_pool_2008_2010.jld2",
        4.0, # sigma
        0.0  # eta
    )
end
# CBM_pool_2008_2010 end

# CBM_nta begin
if model_class == "nta"
    save_model_parameters(
        model_class,
        "../input/primitives_nyc_NTA_2010_time.jld2",
        "../input/nyc_NTA_2010_time_elasticity.csv",
        "../input/baseline_equilibrium_outcomes_nta.jld2",
        "../output/model_cbm_nta.jld2",
        4.0, # sigma
        0.0  # eta
    )
end
# CBM_nta end

# CBM_dist begin
if model_class == "dist"
    save_model_parameters(
        model_class,
        "../input/primitives_nyc2010_dist.jld2",
        "../input/nyc2010_time_elasticity_dist.csv",
        "../input/baseline_equilibrium_outcomes_dist.jld2",
        "../output/model_cbm_dist.jld2",
        4.0, # sigma
        0.0  # eta
    )
end
# CBM_dist end