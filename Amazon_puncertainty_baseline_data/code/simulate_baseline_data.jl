import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatsBase, Random

function select_rows(row_weights, random_seed,n)
    Random.seed!(random_seed)
    selected_rows = sample(1:length(row_weights), Weights(row_weights),n)
    return selected_rows
end

function parameter_uncertainty_simulation(vector_before, seed)
    prob_vector = vector_before ./ sum(vector_before)
    sim_vector = zeros(length(prob_vector))
    selected_rows = select_rows(prob_vector, seed, sum(vector_before)) 
    #create dataframe with each unique selected row and its count
    df_sim = DataFrame(selected_rows = selected_rows)
    df_sim = combine(groupby(df_sim, :selected_rows), nrow)
    df_sim = rename(df_sim, :nrow => :count)
    #create vector of simulated values
    for i in 1:length(df_sim[!, :selected_rows])
        sim_vector[df_sim[i,:selected_rows]] = df_sim[i,:count]
    end
    @assert sum(sim_vector) == sum(vector_before)
    return sim_vector
end

# Arguments
seed = parse(Int64, ARGS[1])
df_before = CSV.read("../temp/df_before.csv", DataFrame)
vector_before = df_before[!, :X_ij]
baseline_data = parameter_uncertainty_simulation(vector_before, seed)
df_sim = DataFrame(j = df_before[!, :j], i = df_before[!, :i], X_ij = baseline_data)
#set X_ij to Int64
df_sim[!, :X_ij] = convert(Array{Int64,1}, df_sim[!, :X_ij])
j_id_list = unique(df_sim[!, :j])
i_id_list = unique(df_sim[!, :i])
#filter out empty destinations and origins
sum_i_df = combine(groupby(df_sim, :i), :X_ij => sum)
sum_i_df = sum_i_df[sum_i_df[!,:X_ij_sum] .> 0,:]
sum_j_df = combine(groupby(df_sim, :j), :X_ij => sum)
sum_j_df = sum_j_df[sum_j_df[!,:X_ij_sum] .> 0,:]

#keep only i's and j's in the sum df's in baseline_flows
df_sim = innerjoin(df_sim, sum_i_df, on = :i, makeunique = true)
df_sim = innerjoin(df_sim, sum_j_df, on = :j, makeunique = true)
#remove sum columns
select!(df_sim, Not([:X_ij_sum, :X_ij_sum_1]))
#assert that all ids in df_sim are in j_id_list and i_id_list
@assert all([i in i_id_list for i in df_sim[!,:i]])
@assert all([j in j_id_list for j in df_sim[!,:j]])

# Output
CSV.write("../output/baseline_data_puncertainty_s"*ARGS[1]*".csv", df_sim)