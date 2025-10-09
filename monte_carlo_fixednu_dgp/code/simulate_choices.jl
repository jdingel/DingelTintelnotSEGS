# For a given set of parameters,
# it takes about 2 hours to simulate the choices.
import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames, Random, Distributions

# Argument
# Each simulation loops over 2.5 million people. simulation = 1, 2, ..., 100
shock = parse(Float64, ARGS[1])
@assert shock == 1.09
simulation = parse(Int64,ARGS[2])
@assert simulation ∈ (1:100)

# Within each simulation, set every 50,000 people as a block. block = 1, 2, ..., 50
block_length = 50_000  # number of individuals within one block 
blocks_total = 50
block = parse(Int64,ARGS[3])
@assert block ∈ (1:blocks_total)

mean_util_inputfile = "../temp/mean_util_"*ARGS[1]*"_fixednu.csv"
simulated_choices_outputfile = "../temp/choices_"*ARGS[1]*"_"*ARGS[2]*"_b"*ARGS[3]*"_fixednu.csv"

# Prepare data 
df = CSV.read(mean_util_inputfile, DataFrame)
mean_util_before = convert(Array{Float64,1}, df[!, :mean_util_before]) ;
mean_util_after = convert(Array{Float64,1}, df[!, :mean_util_after]) ;
@assert length(mean_util_before) == length(mean_util_after)

# Simulation
function choices_before_after_simulation(meanutil_pre, meanutil_post, seed)
    Random.seed!(seed)
    idiosyncratic = rand(Gumbel(),length(meanutil_pre))
    choice_i_before = argmax(meanutil_pre .+ idiosyncratic)
    choice_i_after = argmax(meanutil_post .+ idiosyncratic)

    return choice_i_before, choice_i_after
end


choice = zeros(Int64, block_length, 3) ;
choice[:,1] = ((simulation - 1) * blocks_total * block_length + (block - 1) * block_length) .+ Array{Int64,1}(1:size(choice,1))
@time for i in 1:size(choice, 1)
    choice[i, 2], choice[i, 3] = choices_before_after_simulation(mean_util_before, mean_util_after, choice[i,1]) ;
end

# Output simulation seed, individual-level seed, choices before and after
CSV.write(simulated_choices_outputfile, DataFrame(choice, :auto), writeheader=false)