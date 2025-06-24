import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, StatFiles, StatsBase
include("../input/describe_data.jl")

# read distance
lodes_df = DataFrame(load("../output/nyc2010_lodes_wzero_wdelta.dta"))
lodes_df = sort(lodes_df,[:j, :i])
K = length(unique(lodes_df[!, :i]))
N = length(unique(lodes_df[!, :j]))

@assert K == 2160
@assert N == 2143

delta_bar = reshape(lodes_df[!, :delta], K, N)
delta_bar = collect(Missings.replace(delta_bar, Inf))
delta_bar = convert(Array{Float64,2}, delta_bar)

save("../output/nyc_delta_bar.jld2", "δ_bar", delta_bar)
describe_data_output("../output/nyc_delta_bar.jld2")