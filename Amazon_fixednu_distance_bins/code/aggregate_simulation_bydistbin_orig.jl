import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatFiles, Statistics, Random, Distributions, StatsBase
include("../input/describe_data.jl")

# Load distance data and select relevant tracts
df_distances_orig = DataFrame(load("../input/NYC_dist_to_treated.dta"))
df_distances_orig.i = parse.(Int64, string.(df_distances_orig.i))
df_rent = CSV.read("../input/amazon_ctfl_tract_cbm_sigma_"*ARGS[1]*"_rent.csv", DataFrame)
tract_ids_i = sort(df_rent[!,:i])
df_distances_orig = df_distances_orig[in.(df_distances_orig.i, [tract_ids_i]), :]

# Divide tracts on 20 groups by distance from the treated tract
df_distances_orig.percentile = ordinalrank(df_distances_orig.dist_ij) ./ nrow(df_distances_orig)
df_distances_orig.ventile_id = Int64.(ceil.(df_distances_orig.percentile ./ 0.05))
df_distances_orig.ventile_id[argmin(df_distances_orig.ventile_id)] = 1

# Crosswalk: tract ID - ventile ID
df_crosswalk_orig = select(df_distances_orig, Not([:percentile, :dist_ij]))
df_crosswalk_orig.tract_id = tract_ids_i

# Load and aggregate simulation data 
df_i_list = []
for n in 1:100
  treated_tract = "36081000700" ## Long Island City
  df_n = load("../input/simulation_fixednu_"*ARGS[1]*"_"*string(n)*".jld2")
  df_i = DataFrame(
    tract_id = repeat(tract_ids_i , 1),
    simulation_id =  Int64.(ones(2160).*n),
    real_rb = reshape(df_n["real_rb"], length(df_n["real_rb"])),
    real_ra = reshape(df_n["real_ra"], length(df_n["real_ra"])),
    res_b = reshape(df_n["res_b"], length(df_n["res_b"])),
    res_a = reshape(df_n["res_a"], length(df_n["res_a"]))
  )
  #drop observations for treated tract
  df_i = df_i[df_i.tract_id .!= treated_tract, :]
  # Merge ventile IDs and compute average outcome by ventile-simulation cell
  df_i = leftjoin(df_i, df_crosswalk_orig, on = :tract_id)
  select!(df_i, [:ventile_id, :simulation_id, :real_rb, :real_ra, :res_b, :res_a])
  df_i = combine(groupby(df_i, [:ventile_id, :simulation_id]), [:real_rb, :real_ra, :res_b, :res_a] .=> mean)
  append!(df_i_list, [df_i])
end

# Bind dfs into one df
df_i_sim_results = vcat(df_i_list...)

# Compute minimum and maximum distance for each ventile
df_ventiles_orig = select(df_distances_orig, [:ventile_id, :dist_ij])
df_ventiles_orig = combine(groupby(df_ventiles_orig, :ventile_id), :dist_ij => maximum)
sort!(df_ventiles_orig, :dist_ij_maximum)

df_ventiles_orig.dist_ij_minimum = zeros(nrow(df_ventiles_orig))
df_ventiles_orig.dist_ij_minimum[2:nrow(df_ventiles_orig)] = df_ventiles_orig.dist_ij_maximum[1:(nrow(df_ventiles_orig) - 1)]

# Merge minimum and maximum distance to the simulation results
df_i_sim_results = leftjoin(df_i_sim_results, df_ventiles_orig, on = :ventile_id)
df_i_sim_results = sort(df_i_sim_results, [:simulation_id, :ventile_id])
CSV.write("../output/simulation_bydistbin_fixednu_orig_"*ARGS[1]*".csv", df_i_sim_results)
describe_data(df_i_sim_results, "simulation_bydistbin_fixednu_orig_"*ARGS[1]*".csv",6)