import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatsBase

function jensen_load(sigma)
    w_matrix = Any[]
    r_matrix = Any[]
    for i in 1:100
        string_i = string(i)
        w = load("../input/jensen_simulation_sigma_"*sigma*"_simulation_"*string_i*".jld2")["real_wb"]
        r = load("../input/jensen_simulation_sigma_"*sigma*"_simulation_"*string_i*".jld2")["real_rb"]
        w_matrix = push!(w_matrix, w) #array of arrays (AoA) of w and r
        r_matrix = push!(r_matrix, r)
    end
    #combine AoA into (tract count) x (simulation count) matrix
    w_matrix = hcat(w_matrix...)
    r_matrix = hcat(r_matrix...)
return w_matrix, r_matrix
end

w_matrix, r_matrix = jensen_load(ARGS[1])
primitives = load("../input/primitives_nyc2010_time_sigma_"*ARGS[1]*".jld2")
w_n = load("../input/baseline_equilibrium_outcomes_sigma_"*ARGS[1]*".jld2")["wages"]
r_k = load("../input/baseline_equilibrium_outcomes_sigma_"*ARGS[1]*".jld2")["rents"]
σ= parse(Float64, ARGS[1])
A_n = primitives["productivity"]
P = sum((w_n ./ A_n).^(1 - σ))^(1 / (1 - σ))
real_w_cont = w_n ./ P
real_r_cont = r_k ./ P
#replace infinite values with 0
w_matrix = replace(w_matrix, Inf=>0)
r_matrix = replace(r_matrix, Inf=>0)

#create dataframe of w_mean where the column is titled "real_w_mean" and contains the mean across each simulation (column) for each tract (row)
w_mean_df = DataFrame(real_w_mean = mean(w_matrix, dims=2)[:,1], real_w_cont = real_w_cont)
r_mean_df = DataFrame(real_r_mean = mean(r_matrix, dims=2)[:,1], real_r_cont = real_r_cont)
CSV.write("../temp/jensen_simulation_compiled_w_sigma_"*ARGS[1]*".csv", w_mean_df)
CSV.write("../temp/jensen_simulation_compiled_r_sigma_"*ARGS[1]*".csv", r_mean_df)