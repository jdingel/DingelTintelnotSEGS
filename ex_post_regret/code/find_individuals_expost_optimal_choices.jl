import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, StatFiles, JLD2, FileIO, CSV, Distributions, Random

# Arguments
simulation = parse(Int64,ARGS[1]) # each simulation contains 2.5m individuals
@assert simulation ∈ (1:10)
block = parse(Int64,ARGS[2]) # each simulation contains 100 blocks, so 25000 individuals/block
@assert block ∈ (1:100)

# Functions
include("../input/finitemodel_programs.jl")
include("calculate_util.jl")

# Parameters
σ = 4.0
α = 0.24
ε = abs(parse(Float64,read("../input/nyc2010_time_elasticity.csv",String)))

# Prepare data
choice_df = CSV.read("../temp/individuals_choices_s"*ARGS[1]*"_b"*ARGS[2]*".csv", DataFrame)
primitives = load("../input/primitives_nyc2010_time.jld2")
(K, N) = size(primitives["delta_bar"])
labor = reshape(convert(Array{Float64,1},DataFrame(load("../temp/realized_commuting_flows_s"*ARGS[1]*".dta"))[!,:X_ij]), K, N)

# Calculate realized prices
A = primitives["productivity"]
T = primitives["landendowment"]
wage_realize, rl = freetrade_equilibrium_solver(A, labor, σ, true, primitives["delta_bar"])
rent_realize = land_rent_solver(rl,wage_realize,T, α)
mean_util_realizedprices = mean_util_kn(wage_realize, rent_realize, A, primitives["delta_bar"], σ, α, ε)

# Reshape utility vector into K-by-N matrix so it can be adjusted based on resident and employment conditions
mean_util_realizedprices = reshape(mean_util_realizedprices, K, N)

res = sum(labor, dims = 2)[:]
emp = sum(labor, dims = 1)[:]

# Adjust the realized utility so that no one ever regrets not choosing places with zero residents or employment
lowest_utility = minimum(mean_util_realizedprices[mean_util_realizedprices .!= Inf])
mean_util_realizedprices[res .== 0, :] .= lowest_utility
mean_util_realizedprices[:, emp .== 0] .= lowest_utility

mean_util_realizedprices = mean_util_realizedprices[:] #reshape matrix to vector

# Preallocate output vectors
I = length(choice_df.chosen_choice) # individuals per simulation block
chosen_expost_util_vec = ones(I)
chosen_choice_vec = convert(Array{Int64,1}, choice_df.chosen_choice) # choice given price beliefs
max_expost_util_vec = ones(I)
expost_optimal_choice_vec = ones(Int64, I)

# Loop over individuals
for i in 1:I
	seed = convert(Int64,(simulation-1)*2.5e6 + (block-1)*2.5e4 + i) # same seed as draws based on belief
	Random.seed!(seed)
	idiosyncracies = rand(Gumbel(0,1), length(A)*length(T)) 
	idio_util_realizedprices = mean_util_realizedprices .+ idiosyncracies # idiosyncratic utility of all (k,n) based on the realized prices
	chosen_expost_util_vec[i] = idio_util_realizedprices[chosen_choice_vec[i]] # idiosyncratic utility of chosen (k,n) based on 
	(max_expost_util_vec[i], expost_optimal_choice_vec[i]) = findmax(idio_util_realizedprices) # findmax returns (function_value, root)
end

# Output DataFrame
df_output = DataFrame(
	chosen_expost_utility = chosen_expost_util_vec,
	chosen_choice = chosen_choice_vec,
	max_expost_utility = max_expost_util_vec,
	expost_optimal_choice = expost_optimal_choice_vec
)

CSV.write("../temp/expost_individuals_choices_s"*ARGS[1]*"_b"*ARGS[2]*".csv", df_output)
