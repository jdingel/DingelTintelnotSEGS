import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatsBase

## Load Data
primitives = load(ARGS[1])
model_params = load(ARGS[2])["model_parameters"]
A_n = primitives["productivity"]
δ_kn = primitives["delta_bar"] .* primitives["lambda"] 

ctfl_rent = CSV.read(ARGS[3], DataFrame)
ctfl_wage = CSV.read(ARGS[4], DataFrame)
ctfl_shock = CSV.read(ARGS[5], DataFrame)
baseline_eqlm = load(ARGS[6])

w_n = baseline_eqlm["wages"]
r_k = baseline_eqlm["rents"]
origin_tractid_vector = ctfl_rent[!,"i"]
destination_tractid_vector = ctfl_wage[!,"j"]

function compute_mean_utility(w_n, r_k, A_n, δ_kn, σ, α, ε_ring, nests)
    P= sum((w_n ./ A_n) .^(1-σ))^(1/(1-σ))  
    P_k  = (r_k .^α) * (P^(1-α))        
    mean_utility_temp= ε_ring * log.(w_n' ./ (P_k .* δ_kn))

    mean_utility  = Array{Array{Float64, 1},1}()
    nests_num =  length(nests)
    for z in 1:nests_num
        util_nest_temp = mean_utility_temp[nests[z]]
        push!(mean_utility, util_nest_temp)       # reshape as  Array{Array{Float64, 1},1}
    end
    return mean_utility
end

A_n′ = A_n .* ctfl_shock[!,"A_hat"]
w_n′ = w_n .* ctfl_wage[!,"hat_w"]
r_k′ = r_k .* ctfl_rent[!,"hat_r"]
mean_utility_before = compute_mean_utility(w_n, r_k, A_n, δ_kn, model_params.σ, model_params.α, model_params.ε_ring, model_params.nests)
mean_utility_after = compute_mean_utility(w_n′, r_k′, A_n′, δ_kn, model_params.σ, model_params.α, model_params.ε_ring, model_params.nests)

#save results to jld2
save(ARGS[7], "mean_utility_before", mean_utility_before, "mean_utility_after", mean_utility_after)