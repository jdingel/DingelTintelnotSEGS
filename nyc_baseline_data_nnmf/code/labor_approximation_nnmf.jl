import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, LinearAlgebra, CSV, NMF, Statistics, StatFiles, Random

include("../input/SVD_funcs.jl")

# Argument
q = parse(Int64, ARGS[1])
@assert 1 <= q <= 2143

# Load LODES2010 data
xij_df = sort(DataFrame(load("../input/nyc2010_lodes_wzero_wdelta.dta")), [:j, :i]);

# Number of origin and destination tracts
orig_tract_count = length(unique(xij_df[!,:i]));
dest_tract_count = length(unique(xij_df[!,:j]));

# Get rank-q non-negative matrix factorization approximation
labor_b = convert(Array{Float64,2}, reshape(xij_df[!,:X_ij], 
        orig_tract_count, dest_tract_count));
labor_b_approx_nnmf = NNMF_approximation(labor_b, q)

@assert isapprox(sum(labor_b_approx_nnmf), sum(labor_b))

# Report the share of zeros
zeros_ratio = zeros_percentage(labor_b_approx_nnmf, 1e-12);
io = open("../output/zeros_share_nnmf_"*string(q)*".txt", "w")
write(io, string(zeros_ratio)*"% of tract pairs have zero commuters.")
close(io);

# Output
df_output_nnmf = DataFrame(
    i=xij_df[!, :i],
    j=xij_df[!, :j],
    delta=xij_df[!, :delta],
    X_ij_preperiod=dropdims(reshape(labor_b_approx_nnmf, orig_tract_count*dest_tract_count, 1), dims=2)
    )
CSV.write("../temp/labor_b_approx_nnmf_"*string(q)*".csv", df_output_nnmf);

