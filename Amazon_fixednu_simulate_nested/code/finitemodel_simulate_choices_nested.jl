import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames, Random, Distributions, JLD2, FileIO, Interpolations

ζ = parse(Float64, ARGS[1]) 
simulation = parse(Int64, ARGS[2])
block = parse(Int64, ARGS[3])

@assert ζ in [0.25, 0.75]
@assert 1 <= simulation <= 100
block_length = 50_000; # Break the simulation of 2.5 million people into blocks of 50,000
blocks_total = 50
@assert 1 <= block <= blocks_total

# Helper Functions
# According to Galichon (2022), NL(ζ) can be decomposed to Gumbel(0, ζ) and ζ * log[P(ζ)]
function adj_gumbel_draw(ζ::Float64, N::Integer, log_psd_cdf, seed::Int64)
    Random.seed!(seed);
    u = rand(Uniform(0,1));
    gumbel = rand(Gumbel(0,1), N)
    return ζ .* (log_psd_cdf(u) .+  gumbel )
end

function nested_logit_draw(ζ::Float64, mean_util::Array{Array{Float64, 1},1}, log_psd_cdf, seed::Int64)
    idiosyncrasies = similar(mean_util)
    for i in 1:length(mean_util)
        nest_seed = seed + i         # individual-nest specific seeds
        idiosyncrasies[i] = adj_gumbel_draw(ζ, length(mean_util[i]), log_psd_cdf, nest_seed)
    end
    return idiosyncrasies;
end

# Main Function #

# Prepare data
meanutil_before = load("../temp/amazon_ctfl_tract_cbm_ntaorigin_"*ARGS[1]*"_meanutil.jld2")["mean_utility_before"]   # Array{Array{Float64, 1},1}
meanutil_after  = load("../temp/amazon_ctfl_tract_cbm_ntaorigin_"*ARGS[1]*"_meanutil.jld2")["mean_utility_after"]    # Array{Array{Float64, 1},1}

primitives = load("../input/primitives_nyc2010_time_ntaorigin_"*ARGS[1]*".jld2")
nests = primitives["nests"]  # Array{Array{CartesianIndex{2},1},1}

@assert length(nests) == 195

function choices_before_after_simulation(meanutil_b::Array{Array{Float64, 1},1}, meanutil_a::Array{Array{Float64, 1},1}, nests::Array{Array{CartesianIndex{2},1},1}, log_psd_cdf, seed::Int64)
	
	idiosyncrasies  = nested_logit_draw(ζ, meanutil_b, log_psd_cdf, seed)
	
    util_before = meanutil_b .+ idiosyncrasies               # An array with 195 sub-array
    util_after  = meanutil_a .+ idiosyncrasies

    z_idx_before  = argmax(maximum.(util_before))            # idx for nests
    kn_idx_before = argmax(util_before[z_idx_before])        # idx for ordered-choice given nest
    
    mat_idx_before  = nests[z_idx_before][kn_idx_before]                  # idx for commuting matrix
    choice_i_before = mat_idx_before[1] + (mat_idx_before[2] - 1) * 2160  # idx for the j-i list

    z_idx_after  = argmax(maximum.(util_after))              # idx for nests
    kn_idx_after = argmax(util_after[z_idx_after])          # idx for ordered-choice given nest
    
    mat_idx_after  = nests[z_idx_after][kn_idx_after]                  # idx for commuting matrix
    choice_i_after = mat_idx_after[1] + (mat_idx_after[2] - 1) * 2160  # idx for the j-i list

	return choice_i_before, choice_i_after
end

choice       = zeros(Int64, block_length, 3) ;
nests_length = length(nests);

seed_temp    = ((simulation - 1) * blocks_total * block_length + (block - 1) * block_length) .+ Array{Int64,1}(1:block_length);
choice[:, 1] = seed_temp .+ nests_length * (seed_temp .- 1); 


cdf      = CSV.read("../temp/log_psd_cdf_"*ARGS[1]*".csv", DataFrame);
log_psd  = collect(cdf.log_psd);
pcentile = collect(cdf.pcentile);
log_psd_CDF_interp = LinearInterpolation(pcentile, log_psd);

@time for i in 1:size(choice, 1)
	choice_before, choice_after = choices_before_after_simulation(meanutil_before, meanutil_after, nests, log_psd_CDF_interp, choice[i, 1]);
	choice[i, 2] = choice_before;
	choice[i, 3] = choice_after;
end

# Output
CSV.write("../temp/granular_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_nested.csv", DataFrame(choice, :auto), writeheader=false)
