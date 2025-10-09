import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, LinearAlgebra, StatsBase, CategoricalArrays, UnPack

# Functions
include("calibrate_function.jl")

# Command line arguments
nest_type = ARGS[1]
@assert nest_type ∈ ["residence", "workplace", "ntaorigin", "ntapair", "pumapair", "countypair"]

if nest_type ∈ ["residence", "workplace", "ntaorigin"]
    stub = ""
    ζ = parse(Float64, ARGS[2])
    @assert ζ ∈ [0.125, 0.25, 0.5, 0.75]
    ε = abs(parse(Float64, read("../input/nyc2010_time_elasticity.csv",String)))
    orig_df = DataFrame(load("../input/nyc2010_orig_time.dta"))
    dest_df = DataFrame(load("../input/nyc2010_dest_time.dta"))
else
    stub = "_" * nest_type
    ζ = parse(Float64, read("../input/nyc2010_zeta" * stub * ".csv",String))
    ε = abs(parse(Float64, read("../input/nyc2010_time_elasticity_" * nest_type * ".csv",String)))
    orig_df = DataFrame(load("../input/nyc2010_orig_time" * stub *".dta"))
    dest_df = DataFrame(load("../input/nyc2010_dest_time" * stub *".dta"))
end

#-------------------------------------------------------------------------------
# 1. Load PPMLE estimates for NYC 2010
#-------------------------------------------------------------------------------

α = 0.24 #Davis and Ortalo-Magne (2011)
ε_ring = ζ * ε
σ = 4.0

# Load origin tract FEs
orig_df = orig_df[completecases(orig_df),:]
orig_df = sort(orig_df,[:i])
FE_i = convert(Array{Float64,1},orig_df[!,:fe_i_ppml])
K = length(FE_i)

# Load destination tract FEs
dest_df = dest_df[completecases(dest_df),:]
dest_df = sort(dest_df,[:j])
FE_j = convert(Array{Float64,1},dest_df[!,:fe_j_ppml])
N = length(FE_j)

# Load data with commuting counts and costs
delta_df = DataFrame(load("../input/nyc2010_lodes_wzero_wdelta.dta"))
delta_df.delta = collect(Missings.replace(delta_df.delta, Inf))
df = innerjoin(delta_df,orig_df,on=:i)
df = innerjoin(df, dest_df, on=:j)
df = sort(df,[:j, :i])

# Merge IDs of NTAs, PUMAs, and counties
census_crosswalk = DataFrame(load("../input/nyc2010_census_tabulation.dta"))
census_crosswalk = rename!(census_crosswalk, ["i", "nta_origin", "puma_origin", "county_origin"])
df = innerjoin(df, census_crosswalk, on=:i)
census_crosswalk = rename!(census_crosswalk, ["j", "nta_destination", "puma_destination", "county_destination"])
df = innerjoin(df, census_crosswalk, on=:j)

#-------------------------------------------------------------------------------
# 2. Estimate nested logit
#-------------------------------------------------------------------------------

# Represent mean utility by
# U_ij = ε_ring * ln(W_z + Y_ij)

if nest_type == "residence"
    # Compute shares of commuters in each nest
    nest_df = combine(groupby(df, :i), :X_ij => sum)
    shares = nest_df.X_ij_sum / sum(nest_df.X_ij_sum)
    @assert length(shares) == K

    # Solve (W^ε  * IV^ζ) / Σ (W^ε  * IV^ζ)  = L_z / L for (W^ε * IV^ζ)
    # L_z is the number of individuals who choose nest z
    A = Diagonal(ones(length(shares) - 1)) .- shares[2:end]
    FEi_IV = vcat(1, A \ shares[2:end])
    @assert maximum(abs.((FEi_IV ./ sum(FEi_IV)) .- shares)) < 1e-5

    # Compute inclusive values (IV) and FE_i
    df.Y_ij = exp.(df.fe_j_ppml) .* (df.delta .^ (-ε_ring  / ζ))
    df.Y_ij = coalesce(df.Y_ij, 0.0)
    IV_df = combine(groupby(df, :i), :Y_ij => sum)
    IV = IV_df.Y_ij_sum
    FE_i = FEi_IV ./ (IV .^ ζ)

    # Compute wage, rent beliefs, and set nest IDs
    rentbelief = coalesce.(FE_i .^ (-1 / (ε_ring  * α)), Inf)
    wagebelief = coalesce.(exp.(FE_j ./ (ε_ring / ζ)),0.0)
    df.nest_id = levelcode.(CategoricalArray(df.i))

elseif nest_type == "workplace"
    # Compute shares of commuters in each nest
    nest_df = combine(groupby(df, :j), :X_ij => sum)
    shares = nest_df.X_ij_sum / sum(nest_df.X_ij_sum)
    @assert length(shares) == N

    # Solve (W^ε  * IV^ζ) / Σ (W^ε  * IV^ζ)  = L_z / L for (W^ε * IV^ζ)
    A = Diagonal(ones(length(shares) - 1)) .- shares[2:end]
    FEj_IV = vcat(1, A \ shares[2:end])
    @assert maximum(abs.((FEj_IV ./ sum(FEj_IV)) .- shares)) < 1e-5

    # Compute inclusive values and FE_i
    df.Y_ij = exp.(df.fe_i_ppml) .* (df.delta .^ (-ε_ring / ζ))
    df.Y_ij = coalesce(df.Y_ij, 0.0)
    IV_df = combine(groupby(df, :j), :Y_ij => sum)
    IV = IV_df.Y_ij_sum
    FE_j = FEj_IV ./ (IV .^ ζ)

    # Compute wage, rent beliefs, and set nest IDs
    rentbelief = coalesce.(exp.(-FE_i ./ (ε_ring  * α / ζ)), Inf)
    wagebelief = coalesce.(FE_j .^ (1 / ε_ring), 0.0)
    df.nest_id = levelcode.(CategoricalArray(df.j))
elseif nest_type == "ntaorigin"
    # Take one location from each nest (used for normalization)
    df.nest_id = df.nta_origin
    df_nest_ref = combine(first, groupby(df, :nest_id))
    df_nest_ref = df_nest_ref[:, [:nest_id, :i, :fe_i_ppml]]
    rename!(df_nest_ref, ["nest_id","i_ref","fe_i_ppml_ref"])

    # Normalize fixed effects
    df = innerjoin(df, df_nest_ref, on = :nest_id)
    df.fe_i_ppml = df.fe_i_ppml .- df.fe_i_ppml_ref

    # Solve (W^ε  * IV^ζ) / Σ (W^ε  * IV^ζ)  = L_z / L for (W^ε * IV^ζ)
    nest_df = combine(groupby(df, :nest_id), :X_ij => sum)
    shares = nest_df.X_ij_sum / sum(nest_df.X_ij_sum)
    A = Diagonal(ones(length(shares) - 1)) .- shares[2:end]
    nest_df.FEi_IV = vcat(1, A \ shares[2:end])
    @assert maximum(abs.((nest_df.FEi_IV ./ sum(nest_df.FEi_IV)) .- shares)) < 1e-5

    nest_df = nest_df[:, [:nest_id, :FEi_IV]]

    # Compute inclusive values and FE_i where i is the residence in each NTA used for normalization
    df.Y_ij = exp.(df.fe_i_ppml) .* exp.(df.fe_j_ppml) .* (df.delta .^ (-ε_ring  / ζ))
    df.Y_ij = coalesce(df.Y_ij, 0.0)
    IV_df = combine(groupby(df, :nest_id), :Y_ij => sum)
    IV_df = innerjoin(IV_df, nest_df, on = :nest_id)
    IV_df.fe_i_ref = IV_df.FEi_IV ./ (IV_df.Y_ij_sum .^ ζ)
    IV_df.fe_i_ref = log.(IV_df.fe_i_ref) ./ ζ
    IV_df = IV_df[:, [:nest_id, :fe_i_ref]]

    # Merge the values back to df and identify FE_i up to proportionality coef.
    df = innerjoin(df, IV_df, on = :nest_id)
    df.fe_i_ppml = df.fe_i_ppml .+ df.fe_i_ref
    df_fe_i = unique(df[:, [:i, :fe_i_ppml]])
    df_fe_i = sort(df_fe_i, :i)
    FE_i = convert(Array{Float64,1},df_fe_i[!,:fe_i_ppml])

    # Compute wage, rent beliefs, and set nest IDs
    rentbelief = coalesce.(exp.(-FE_i./(ε_ring * α / ζ)), Inf)
    wagebelief = coalesce.(exp.(FE_j./(ε_ring / ζ)),0.0)
    df.nest_id = levelcode.(CategoricalArray(df.nest_id))
elseif nest_type == "ntapair" || nest_type == "pumapair" || nest_type == "countypair" 
    # Compute wage, rent beliefs, and set nest IDs
    rentbelief = coalesce.(exp.(-FE_i./(ε_ring * α / ζ)), Inf)
    wagebelief = coalesce.(exp.(FE_j./(ε_ring / ζ)),0.0)
    df.nest_id = string.(Int.(df.z_o)) .* "_" .* string.(Int.(df.z_d))
    df.nest_id = levelcode.(CategoricalArray(df.nest_id))
end 

# Normalize wage and rent beliefs 
rentbelief = rentbelief ./ rentbelief[1]
wagebelief = wagebelief ./ wagebelief[1]

# Matrix of nest IDs
nests_array = reshape(df[!,:nest_id], K, N)
nests_array = convert(Array{Int64,2},nests_array)
nests_ids = [findall(x->x==z, nests_array) for z in unique(nests_array)] # The most time-consuming part of the script

# Transform commuting costs into 2D array and compute the number of workers
δ_bar = reshape(df[!,:delta], K, N)
δ_bar = convert(Array{Float64,2}, collect(Missings.replace(δ_bar, Inf)))
@assert minimum(δ_bar) > 0

pop = convert(Float64,sum(df[!,:X_ij]))

#-------------------------------------------------------------------------------
# 3. Compute productivities and land endowments
#-------------------------------------------------------------------------------

price_beliefs = (w_belief = wagebelief, r_belief = rentbelief)
@time nested_structure = [findall(x->x==z, nests_array) for z in unique(nests_array)]
parameters = (δ̄ = δ_bar, λ = ones(K, N), ε_ring = ε_ring, α = α, σ = σ, η = 0.0, ζ = ζ, nests = nested_structure)


wage, rent, A, T = calibrate(price_beliefs, parameters, pop)

if nest_type == "residence" || nest_type == "workplace" || nest_type == "ntaorigin"
    filename_output = "../output/primitives_nyc2010_time_"*ARGS[1]*"_"*ARGS[2]*".jld2"  
else 
    filename_output = "../output/primitives_nyc2010_time_"*ARGS[1]*".jld2"
end

save(filename_output,
    "epsilon_ring", ε_ring,
    "alpha", α,
    "eta", parameters.η,
    "zeta", parameters.ζ,
    "sigma", σ,
	"landendowment", T, 
    "productivity", A, 
	"rentbelief", rent, 
    "wagebelief", wage, 
	"delta_bar", parameters.δ̄,
    "lambda", parameters.λ,
    "nests", nested_structure,
    "pop", pop
)