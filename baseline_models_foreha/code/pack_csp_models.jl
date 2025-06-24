import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, FileIO, JLD2, Parameters, StatFiles, UnPack

# helper function
function level_to_shares(flows_file, wage_file, δ̄_mat, wage_varname)
    (K, N) = size(δ̄_mat)
    df_ell = DataFrame(load(flows_file))
    df_ell = sort(df_ell, [:j, :i])
    obs_l_mat = df_ell[!, :X_ij] |> x -> reshape(x, K, N)
    obs_w = DataFrame(load(wage_file))[!, Symbol(wage_varname)] |> x -> convert(Array{Float64}, x)
    obs_l_share =  obs_l_mat ./ sum(obs_l_mat) |> x -> convert(Array{Float64,2}, x)
    obs_y_share = (obs_l_share ./ δ̄_mat) .* obs_w' ./ sum((obs_l_share ./ δ̄_mat) .* obs_w') |> x -> convert(Array{Float64,2}, x)
    return obs_l_share, obs_y_share
end

function save_model_parameters(model_class, δ̄_file, elasticity_file, flows_file, wage_file, wage_varname, output_file, sigma, eta)
    δ̄_mat = load(δ̄_file)["delta_bar"]
    epsilon = abs(parse(Float64, read(elasticity_file, String)))
    
    # shares
    obs_l_share, obs_y_share = level_to_shares(flows_file, wage_file, δ̄_mat, wage_varname)

    tuple = (model_class = "csp_" * model_class,
        α = alpha,
        ε = epsilon,
        σ = sigma,
        η = eta,
        ζ = zeta,
        nests = nothing,
        l_share = obs_l_share,
        y_share = obs_y_share)

    save(output_file, "model_parameters", tuple)
end

# housing expenditure share  (Davis and Ortalo-Magne, 2011)
const alpha = 0.24

# nested-logit correlation parameter (corr = 1 - ζ^2)    
const zeta = 1.0

# model name 
model_class = ARGS[1]
@assert model_class ∈ ["sigma", "eta", "pool_2008_2010", "nta"]


# CSP_sigma begin
if model_class == "sigma"
    sigma = parse(Float64, ARGS[2])
    @assert sigma ∈ [1.1, 4.0, Inf]

    save_model_parameters(
        model_class,
        "../input/primitives_nyc2010_time.jld2",
        "../input/nyc2010_time_elasticity.csv",
        "../input/nyc2010_lodes_wzero_wdelta.dta",
        "../input/nyc2010_wage.dta",
        "Wj",
        "../output/model_csp_sigma_"*string(sigma)*".jld2", 
        sigma,
        0.0 # eta
    )
end
# CSP_sigma end

# CSP_eta begin
if model_class == "eta"
    eta = parse(Float64, ARGS[2])
    @assert eta ∈ [0.0028, 0.001, 0.1]

    save_model_parameters(
        model_class,
        "../input/primitives_nyc2010_time.jld2",
        "../input/nyc2010_time_elasticity.csv",
        "../input/nyc2010_lodes_wzero_wdelta.dta",
        "../input/nyc2010_wage.dta",
        "Wj",
        "../output/model_csp_eta_"*string(eta)*".jld2", 
        4.0, # sigma
        eta
    )
end
# CSP_eta end

# CSP_pool_2008_2010 begin
if model_class == "pool_2008_2010"
    save_model_parameters(
        model_class,
        "../input/primitives_nyc_pool_2008_2010_time.jld2",
        "../input/nyc_pool_2008_2010_time_elasticity.csv",
        "../input/nyc_pool_2008_2010_lodes_wzero_wdelta.dta",
        "../input/nyc_avg_wage_2008_2010.dta",
        "avg_wage",
        "../output/model_csp_pool_2008_2010.jld2", 
        4.0, # sigma
        0.0  # eta
    )
end
# CSP_pool_2008_2010 end

# CSP_nta begin
if model_class == "nta"
    save_model_parameters(
        model_class,
        "../input/primitives_nyc_NTA_2010_time.jld2",
        "../input/nyc_NTA_2010_time_elasticity.csv",
        "../input/nyc_NTA_2010_lodes_wzero_wdelta.dta",
        "../input/NTA_avg_wages_2010.dta",
        "avg_wage",
        "../output/model_csp_nta.jld2", 
        4.0, # sigma
        0.0  # eta
    )
end
# CSP_nta end

# CSP_nta_harmonic begin
if model_class == "nta_harmonic"
    save_model_parameters(
        model_class,
        "../input/primitives_nyc_NTA_2010_time_harmonic.jld2",
        "../input/nyc_NTA_2010_time_elasticity_harmonic.csv",
        "../input/nyc_NTA_2010_lodes_wzero_wdelta.dta",
        "../input/NTA_avg_wages_2010.dta",
        "avg_wage",
        "../output/model_csp_nta_harmonic.jld2", 
        4.0, # sigma
        0.0  # eta
    )
end
# CSP_nta_harmonic end

# CSP_nta_weighted begin
if model_class == "nta_weighted"
    save_model_parameters(
        model_class,
        "../input/primitives_nyc_NTA_2010_time_weighted.jld2",
        "../input/nyc_NTA_2010_time_elasticity_weighted.csv",
        "../input/nyc_NTA_2010_lodes_wzero_wdelta.dta",
        "../input/NTA_avg_wages_2010.dta",
        "avg_wage",
        "../output/model_csp_nta_weighted.jld2", 
        4.0, # sigma
        0.0  # eta
    )
end
# CSP_nta_weighted end

# CSP_dist begin
if model_class == "dist"
    save_model_parameters(
        model_class,
        "../input/primitives_nyc2010_dist.jld2",
        "../input/nyc2010_time_elasticity_dist.csv",
        "../input/nyc2010_lodes_wzero_wdelta.dta",
        "../input/nyc2010_wage.dta",
        "Wj",
        "../output/model_csp_dist.jld2", 
        4.0, # sigma
        0.0  # eta
    )
end
# CSP_dist end