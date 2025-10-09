import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatFiles, Statistics, Random, Distributions, StatsBase
include("../input/describe_data.jl")

# Load distance data and select relevant tracts
df_distances_dest = DataFrame(load("../input/NYC_dist_to_treated.dta")) 
rename!(df_distances_dest, :i => :j)
df_distances_dest.j = parse.(Int64, string.(df_distances_dest.j))
df_wage = CSV.read("../input/amazon_ctfl_tract_cbm_sigma_"*ARGS[1]*"_wage.csv", DataFrame)
tract_ids_j = sort(df_wage[!,:j])
df_distances_dest = df_distances_dest[in.(df_distances_dest.j, [tract_ids_j]), :]

# Divide tracts on 20 groups by distance from the treated tract
df_distances_dest.percentile = ordinalrank(df_distances_dest.dist_ij) ./ nrow(df_distances_dest)
df_distances_dest.ventile_id = Int64.(ceil.(df_distances_dest.percentile ./ 0.05))
df_distances_dest.ventile_id[argmin(df_distances_dest.ventile_id)] = 1

# Crosswalk: tract ID - ventile ID
df_crosswalk_dest = select(df_distances_dest, Not([:percentile, :dist_ij]))
df_crosswalk_dest.tract_id = tract_ids_j

# Load and aggregate simulation data 
df_j_list = []
for n in 1:100
  treated_tract = 36081000700 ## Long Island City
  df_n = load("../input/simulation_fixednu_"*ARGS[1]*"_"*string(n)*".jld2")
  df_j = DataFrame(
    tract_id = repeat(tract_ids_j, 1),
    simulation_id =  Int64.(ones(2143).*n),
    emp_b = reshape(df_n["emp_b"], length(df_n["emp_b"])),
    emp_a = reshape(df_n["emp_a"], length(df_n["emp_a"])),
    real_wb = reshape(df_n["real_wb"], length(df_n["real_wb"])),
    real_wa = reshape(df_n["real_wa"], length(df_n["real_wa"]))
  )
  replace!(df_j.real_wb, Inf => 0.0, -Inf => 0.0)
  replace!(df_j.real_wa, Inf => 0.0, -Inf => 0.0)
  #drop observations for treated tract
  df_j = df_j[df_j.tract_id .!= treated_tract, :]
  # Merge ventile IDs and compute average outcome by ventile-simulation cell
  df_j = leftjoin(df_j, df_crosswalk_dest, on = :tract_id)
  select!(df_j, [:ventile_id, :simulation_id, :emp_b, :emp_a, :real_wb, :real_wa])
  df_j = combine(groupby(df_j, [:ventile_id, :simulation_id]), [:emp_b, :emp_a, :real_wb, :real_wa] .=> mean)
  append!(df_j_list, [df_j])
end

# Bind dfs into one df
df_j_sim_results = vcat(df_j_list...)

# Compute minimum and maximum distance for each ventile
df_ventiles_dest = select(df_distances_dest, [:ventile_id, :dist_ij])
df_ventiles_dest = combine(groupby(df_ventiles_dest, :ventile_id), :dist_ij => maximum)
sort!(df_ventiles_dest, :dist_ij_maximum)

df_ventiles_dest.dist_ij_minimum = zeros(nrow(df_ventiles_dest))
df_ventiles_dest.dist_ij_minimum[2:nrow(df_ventiles_dest)] = df_ventiles_dest.dist_ij_maximum[1:(nrow(df_ventiles_dest) - 1)]

# Merge minimum and maximum distance to the simulation results
df_j_sim_results = leftjoin(df_j_sim_results, df_ventiles_dest, on = :ventile_id)
df_j_sim_results = sort(df_j_sim_results, [:simulation_id, :ventile_id])
CSV.write("../output/simulation_bydistbin_fixednu_dest_"*ARGS[1]*".csv", df_j_sim_results)
describe_data(df_j_sim_results, "simulation_bydistbin_fixednu_dest_"*ARGS[1]*".csv",6)