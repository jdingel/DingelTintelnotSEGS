import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames
using Random, Distributions

# Arguments
## Each simulation loops over 2.5 million individuals. simulation = 1, 2, ...

simulation = parse(Int64, ARGS[1])
@assert 1 <= simulation <= 100

I = 2_488_905                 # total number of individuals

# Prepare data
df = CSV.read("../temp/amazon_ctfl_cbm_nta_meanutil.csv", DataFrame);
meanutil_before = convert(Array{Float64,1},df[!,:mean_utility_before]);
meanutil_after = convert(Array{Float64,1},df[!,:mean_utility_after]);
@assert length(meanutil_before) == length(meanutil_after);

# Main function
function choices_before_after(meanutil1::Array{Float64,1}, meanutil2::Array{Float64,1}, seed::Int64)
	Random.seed!(seed);
	idiosyncratic = rand(Gumbel(0,1),length(meanutil1)) 
	choice_i_before = argmax(meanutil1 .+ idiosyncratic)
	choice_i_after  = argmax(meanutil2 .+ idiosyncratic)
	return choice_i_before, choice_i_after
end

# Simulation

choice = ones(Int64, I, 3);   # container for simulation results
choice[:, 1] = (simulation - 1) * I .+ Array{Int64,1}(1:I);

@time for i in 1: I
	choice_before, choice_after = choices_before_after(meanutil_before, meanutil_after, choice[i,1]);
	choice[i, 2] = choice_before;
	choice[i, 3] = choice_after;
end

# Output
choice_df = DataFrame(individual = choice[:, 1], row_id_before = choice[:, 2], row_id_after = choice[:, 3])
CSV.write("../temp/granular_NTA_s"*ARGS[1]*".csv", choice_df)