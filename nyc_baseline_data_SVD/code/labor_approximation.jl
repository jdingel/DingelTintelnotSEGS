# This script does two things:
# 1. computes the transformed rank-restricted SVD approximation of the 2010 labor allocation matrix for different ranks
# 2. reports the share of zeros in the approximated matrix.

import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, StatFiles, LinearAlgebra, Statistics, CSV

include("../input/SVD_funcs.jl")

# Argument
q = parse(Int64, ARGS[1])
@assert 1 <= q <= 2143

# Load LODES2010 data
xij_df = sort(DataFrame(load("../input/nyc2010_lodes_wzero_wdelta.dta")), [:j, :i]);

# Number of origin and destination tracts
orig_tract_count = length(unique(xij_df[!,:i]));
dest_tract_count = length(unique(xij_df[!,:j]));

# Get rank-q SVD approximation 
labor_b = convert(Array{Float64,2}, reshape(xij_df[!,:X_ij], 
        orig_tract_count, dest_tract_count));
total_pop = sum(xij_df[!,:X_ij]);
labor_b_approx = SVD_approximation(labor_b, q);
labor_b_approx[labor_b_approx .< 0] .= 0;  # Truncate negative entries
scale_param = total_pop / sum(labor_b_approx);
labor_b_approx = labor_b_approx .* scale_param;  # Rescale approximated matrix
@assert isapprox(sum(labor_b_approx), total_pop)

# Report the share of zero counts
zeros_ratio = zeros_percentage(labor_b_approx, 1e-12);
# Save to text files
io = open("../output/zeros_share_"*string(q)*".txt", "w");
write(io, string(zeros_ratio)*"% of tract pairs have zero commuters.");
close(io);

# Output to CSV
df_output = DataFrame(
    i=xij_df[!, :i],
    j=xij_df[!, :j],
    delta=xij_df[!, :delta],
    X_ij_preperiod=dropdims(reshape(labor_b_approx, orig_tract_count*dest_tract_count, 1), dims=2)
    )
CSV.write("../temp/labor_b_approx_svd_"*string(q)*".csv", df_output);