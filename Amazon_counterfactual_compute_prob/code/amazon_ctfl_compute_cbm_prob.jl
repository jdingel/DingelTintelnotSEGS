import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatsBase

include("../input/finitemodel_programs.jl")
## Load Data
primitives = load(ARGS[1])
model_params = load(ARGS[2])["model_parameters"]
if occursin("ntaorigin", ARGS[2])
    ε = model_params.ε_ring / model_params.ζ
else
    ε = model_params.ε
end
A_n = primitives["productivity"]
δ̄_kn = primitives["delta_bar"]
(K, N) = size(δ̄_kn)

ctfl_rent = CSV.read(ARGS[3], DataFrame)
ctfl_wage = CSV.read(ARGS[4], DataFrame)
ctfl_shock = CSV.read(ARGS[5], DataFrame)
baseline_eqlm = load(ARGS[6])

w_n = baseline_eqlm["wages"]
r_k = baseline_eqlm["rents"]
origin_tractid_vector = ctfl_rent[!,"i"]
destination_tractid_vector = ctfl_wage[!,"j"]

A_n′ = A_n .* ctfl_shock[!,"A_hat"]
w_n′ = w_n .* ctfl_wage[!,"hat_w"]
r_k′ = r_k .* ctfl_rent[!,"hat_r"]

prob_before = prob_i_choose_kn(w_n,r_k,δ̄_kn,ε,model_params.α)
prob_after = prob_i_choose_kn(w_n′,r_k′,δ̄_kn,ε,model_params.α)

## save results
df_util_output = DataFrame(
    "j" => repeat(destination_tractid_vector, outer = K),
    "i" => repeat(origin_tractid_vector, inner = N),
    "prob_before" => prob_before,
    "prob_after" => prob_after)

CSV.write(ARGS[7], df_util_output)
