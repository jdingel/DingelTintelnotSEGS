import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, StatsBase, UnPack

include("calibrate_function.jl")

# elasticities
const σ = parse(Float64, ARGS[2])
const α = 0.24 # Davis and Ortalo-Magne (2011)
ε = abs(parse(Float64,read(ARGS[3], String)))

@assert 0 < α < 1
@assert σ > 1
@assert ε > 0

# fixed-effects
orig_df = DataFrame(load(ARGS[4]))
orig_df = orig_df[completecases(orig_df),:]
dest_df = DataFrame(load(ARGS[5]))
dest_df = dest_df[completecases(dest_df),:]

# Extract fixed effects
if occursin("ife", ARGS[1])
	FE_i = convert(Array{Float64,1}, orig_df[!,:fe_i])
    FE_j = convert(Array{Float64,1}, dest_df[!,:fe_j])
else
	FE_i = convert(Array{Float64,1}, orig_df[!,:fe_i_ppml])
    FE_j = convert(Array{Float64,1}, dest_df[!,:fe_j_ppml])
end

# Commuting costs
lodes_df = DataFrame(load(ARGS[6]))

lodes_df_selected = innerjoin(lodes_df, orig_df,on=:i)
lodes_df_selected = innerjoin(lodes_df_selected, dest_df, on=:j)
lodes_df_selected = sort(lodes_df_selected,[:j, :i])

K = length(FE_i)
N = length(FE_j)

δ_bar = reshape(lodes_df_selected[!,:delta], K, N)
δ_bar = convert(Array{Float64,2}, collect(Missings.replace(δ_bar, Inf)))
@assert minimum(δ_bar) > 0

# unobserved disutility
if occursin("ife", ARGS[1])
    lambda_df = DataFrame(load(ARGS[7]))
    λ = reshape(lambda_df[!,:lambda], K, N)
    λ = convert(Array{Float64,2}, collect(Missings.replace(λ, Inf)))
    @assert minimum(λ) > 0
else
    λ = ones(K, N)
end

# agglomeration elasticity
if occursin("eta", ARGS[1])
    η = parse(Float64, ARGS[7])
else
    η = 0.0
end

pop = convert(Float64, sum(lodes_df_selected[!,:X_ij]))

wagebelief = coalesce.(exp.(FE_j./(ε)),0.0)
rentbelief = coalesce.(exp.(-FE_i./(ε*α)),Inf)
price_beliefs = (w_belief = wagebelief, r_belief = rentbelief)

parameters = (δ̄ = δ_bar, λ = λ, ε = ε, α = α, σ = σ, η = η, ζ = 1.0, nests = nothing)
wage, rent, A, T = calibrate(price_beliefs, parameters, pop)

if occursin("NTA", ARGS[1])
    save(ARGS[1],
    "epsilon", ε,
    "alpha", α,
    "eta", parameters.η,
    "zeta", parameters.ζ,
    "sigma", σ,
	"landendowment", T, 
    "productivity", A, 
	"rentbelief", rent, 
    "wagebelief", wage, 
	"delta_bar", parameters.δ̄,
    "lambda", λ,
    "pop", pop
    )
else
    save(ARGS[1],
    "epsilon", ε,
    "alpha", α,
    "eta", parameters.η,
    "zeta", parameters.ζ,
    "sigma", σ,
	"landendowment", T, 
    "productivity", A, 
	"rentbelief", rent, 
    "wagebelief", wage, 
	"delta_bar", parameters.δ̄,
    "lambda", λ,
    "pop", pop,
    "origin_FIPS", sort(parse.(Int, unique(string.(lodes_df_selected.i)))),
	"destination_FIPS", sort(parse.(Int, unique(string.(lodes_df_selected.j))))
)
end