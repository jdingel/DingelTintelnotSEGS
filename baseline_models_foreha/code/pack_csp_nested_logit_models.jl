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
df = DataFrame(load("../input/nyc2010_lodes_wzero_wdelta.dta"))
df = sort(df, [:j, :i])
obs_w = DataFrame(load("../input/nyc2010_wage.dta"))[!, :Wj] |> x -> convert(Array{Float64}, x)
obs_l_mat = df[!, :X_ij] |> x -> reshape(x, K, N)
obs_l_share =  obs_l_mat ./ sum(obs_l_mat) |> x -> convert(Array{Float64,2}, x)
obs_y_share = (obs_l_share ./ δ̄_mat) .* obs_w' ./ sum((obs_l_share ./ δ̄_mat) .* obs_w') |> x -> convert(Array{Float64,2}, x)

tuple = (model_class = "csp_" * model_class,
    α = alpha, 
    ε_ring = epsilon_ring, 
    σ = sigma, 
    η = eta, 
    ζ = zeta, 
    nests = load("../input/primitives_nyc2010_time_"*ARGS[1]*"_"*string(zeta)*".jld2")["nests"],
    l_share = obs_l_share, 
    y_share = obs_y_share)

save("../output/model_csp_" * model_class * "_" * string(zeta)*".jld2", "model_parameters", tuple)
