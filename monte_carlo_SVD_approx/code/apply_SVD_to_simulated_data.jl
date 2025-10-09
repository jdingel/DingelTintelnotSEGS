# This script takes pre-shock realized draws from Monte Carlo simulations 
# and produces transformed low-rank approximation across different ranks

import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, LinearAlgebra, Statistics, CSV, ZipFile

include("../input/SVD_funcs.jl")

# Arguments
Λ = parse(Float64, ARGS[1])
@assert Λ ∈ [0.0, 0.1, 0.25, 0.5, 1.0]
headcount = parse(Float64, ARGS[2]) * 1e6
@assert headcount ∈ [2.488905, 5, 12.5, 25, 50, 125, 250, 2560] * 1e6
A_shock = parse(Float64, ARGS[3])
@assert A_shock == 1.09
seed = parse(Int, ARGS[4])
@assert seed ∈ (1:100)

if ARGS[5] != "full" 
    q = parse(Int, ARGS[5])
    @assert q in vcat(collect(1:1:6), collect(8:2:20), 15, 50, 100, 200, 500, 1000, 1500)
end

# Load LODES2010 data
df = sort(CSV.read("../input/DGP_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*".csv", DataFrame), [:id_j, :id_i]);

# Number of origin and destination tracts
K_dgp = length(unique(df[!,:id_i]));
N_dgp = length(unique(df[!,:id_j]));

if ARGS[5] == "full" 
    q = convert(Int, minimum([K_dgp, N_dgp]))
end

# Get rank-q SVD approximation 
labor_b = convert(Array{Float64,2}, reshape(df[!,:X_ij_before], K_dgp, N_dgp));
total_pop = sum(df[!,:X_ij_before]);
labor_b_approx = SVD_approximation(labor_b, q);
labor_b_approx[labor_b_approx .< 0] .= 0;  # Truncate negative entries
scale_param = total_pop / sum(labor_b_approx);
labor_b_approx = labor_b_approx .* scale_param;  # Rescale approximated matrix
@assert isapprox(sum(labor_b_approx), total_pop)

# Output to zipped CSV
df_output = DataFrame(
    id_i=df[!, :id_i], 
    id_j=df[!, :id_j], 
    X_ij_before=labor_b_approx[:]
    )

outfile = ZipFile.Writer("../output/DGP_approx_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_"*ARGS[5]*".csv.zip")
file = ZipFile.addfile(outfile, 
	"DGP_approx_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_"*ARGS[4]*"_"*ARGS[5]*".csv", 
	method=ZipFile.Deflate)
df_output |> CSV.write(file)
close(outfile)