import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, FileIO, JLD2, Parameters, StatFiles, UnPack

# rank
rank = parse(Int64, ARGS[1])
@assert rank ∈ (1:2143)

# elasticities
epsilon = abs(parse(Float64,read("../input/nyc2010_time_elasticity.csv", String)))
alpha = 0.24
sigma = 4.0
eta = 0.0
zeta = 1.0

# commuting time
δ̄_mat = load("../input/nyc_delta_bar.jld2")["δ_bar"]
(K, N) = size(δ̄_mat)

# shares
df = DataFrame(load("../temp/nyc_2010_levels_tracttotract_approx_svd_"*string(rank)*".dta"))
df = sort(df, [:j, :i])
obs_w = DataFrame(load("../input/nyc2010_wage.dta"))[!, :Wj] |> x -> convert(Array{Float64}, x)
l_mat = df[!, :X_ij_preperiod] |> x -> reshape(x, K, N)
l_share =  l_mat ./ sum(l_mat) |> x -> convert(Array{Float64,2}, x)
y_share = (l_share ./ δ̄_mat) .* obs_w' ./ sum((l_share ./ δ̄_mat) .* obs_w') |> x -> convert(Array{Float64,2}, x)

tuple = (model_class = "svd_" * string(rank),
    α = alpha, 
    ε = epsilon, 
    σ = sigma, 
    η = eta, 
    ζ = zeta, 
    nests = nothing,
    l_share = l_share, 
    y_share = y_share)

save("../output/model_svd_"*string(rank)*".jld2", "model_parameters", tuple)
