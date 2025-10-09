import Pkg
Pkg.activate("../input/Project.toml")
using CSV, JLD2, FileIO, DataFrames, DelimitedFiles, Random, Distributions

# Function
include("calculate_util.jl")

# Arguments
simulation = parse(Int64,ARGS[1]) # each simulation contains 2.5m individuals
@assert simulation ∈ (1:10)
block = parse(Int64, ARGS[2]) # each simulation contains 100 blocks, so 25000 individuals/block
@assert block ∈ (1:100)

# Parameter
primitives = load("../input/primitives_nyc2010_time.jld2")
ε = primitives["epsilon"]
α = 0.24
σ = 4.0

# Data
baseline_eqlm = load("../input/baseline_equilibrium_outcomes_sigma_4.0.jld2")
wage = baseline_eqlm["wages"]
rent = baseline_eqlm["rents"]


# utility from price beliefs
mean_util = mean_util_kn(wage,rent,primitives["productivity"],primitives["delta_bar"],σ,α,ε)

choice = zeros(Int64, 25000, 1)
for i in 1:25000
	seed = convert(Int64,(simulation-1)*2.5e6 + (block-1)*2.5e4 + i)
	
	Random.seed!(seed)
	idiosyncratic = rand(Gumbel(), length(mean_util))
	choice[i] = argmax(mean_util .+ idiosyncratic)
end

# Output
df_output = DataFrame(choice, :auto)
rename!(df_output, :x1=>:chosen_choice)
CSV.write("../temp/individuals_choices_s"*ARGS[1]*"_b"*ARGS[2]*".csv", df_output)