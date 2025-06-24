import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames
using Random, Distributions

# Arguments
## Each simulation loops over 2.5 million people. simulation = 1, 2, ...
## Within each simulation, set every 50,000 people as a block. block = 1, 2, ..., 50
σ = parse(Float64, ARGS[1])
simulation = parse(Int64, ARGS[2])
@assert 1 <= simulation <= 100
blocks_total = 50
block = parse(Int64, ARGS[3])
@assert 1 <= block <= blocks_total
block_length = 50000;

# Prepare data
df = CSV.read("../temp/amazon_ctfl_tract_cbm_sigma_"*ARGS[1]*"_meanutil.csv", DataFrame)

meanutil_before = convert(Array{Float64,1},df[!,:mean_utility_before]);
meanutil_after = convert(Array{Float64,1},df[!,:mean_utility_after]);
@assert length(meanutil_before) == length(meanutil_after);

# Simulation
function choices_before_after_simulation(meanutil1::Array{Float64,1},meanutil2::Array{Float64,1},seed::Int64)
	Random.seed!(seed);
	idiosyncratic = rand(Gumbel(),length(meanutil1))
	choice_i_before = argmax(meanutil1 .+ idiosyncratic)
	choice_i_after = argmax(meanutil2 .+ idiosyncratic)

	return choice_i_before, choice_i_after
end

choice = zeros(Int64, block_length, 3) ;
choice[:, 1] = ((simulation - 1) * blocks_total * block_length + (block - 1) * block_length) .+ Array{Int64,1}(1:size(choice,1))
@time for i in 1:size(choice, 1)
	choice_before, choice_after = choices_before_after_simulation(meanutil_before,meanutil_after,choice[i, 1]);
	choice[i, 2] = choice_before;
	choice[i, 3] = choice_after;
end

# Output
CSV.write("../output/granular_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*".csv", DataFrame(choice, :auto), writeheader=false)
