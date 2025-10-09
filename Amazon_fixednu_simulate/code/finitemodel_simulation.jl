# This script computes changes in employment and residence and real prices for a given simulation.
import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatsBase, UnPack

# Function
include("../input/finitemodel_programs.jl")

# Arguments
sigma = ARGS[1]; simulation_string = ARGS[2];
simulation = parse(Int64, ARGS[2])
@assert 1 <= simulation <= 100
treated_tract = "36081000700" ## Long Island City

# Prepare data
A_shock = CSV.read("../input/amazon_ctfl_tract_cbm_sigma_" * sigma * "_shock.csv", DataFrame; select = [:A_hat])[:, 1]
primitives = load("../input/primitives_nyc2010_time_sigma_" * sigma * ".jld2")

(T_k, A_n, δ̄) = (primitives["landendowment"], primitives["productivity"], primitives["delta_bar"])
A_n′ = A_n .* A_shock
labor_df = sort(CSV.read("../temp/finite_labor_allocation_"*sigma*"_"*simulation_string*".csv", DataFrame), [:j, :i])
num_i = length(unique(labor_df.i));
num_j = length(unique(labor_df.j));
ell_b = convert(Array{Float64,2}, reshape(labor_df.X_ij_before, num_i, num_j));
ell_a = convert(Array{Float64,2}, reshape(labor_df.X_ij_after, num_i, num_j));


# Define function that takes one set of finite-model simulation and computes prices and quantities 
function solveprices_givenlabor(ell_kn, A_n, T_k, δ̄, model_params)
	@unpack σ, ε, α = model_params
	
	wage, realized_labor = freetrade_equilibrium_solver(A_n, ell_kn, σ, true, δ̄)
	rent = land_rent_solver(realized_labor, wage, T_k, α)
	p_n = (wage ./ A_n)
	P = sum(p_n.^ (1 - σ)) ^ (1/(1-σ))
	@assert isfinite(P) && P > 0.0 "Price index must be positive and finite but P=$P"
	
	res = dropdims(sum(ell_kn, dims=2), dims=2)
	emp = dropdims(sum(ell_kn, dims=1), dims=1)
	real_rent = rent ./ P
	real_wage = wage ./ P 

	return real_rent, real_wage, res, emp
end

real_rent_b, real_wage_b, res_b, emp_b = solveprices_givenlabor(ell_b, A_n, T_k, δ̄, model_params);
real_rent_a, real_wage_a, res_a, emp_a = solveprices_givenlabor(ell_a, A_n′, T_k, δ̄, model_params);


# Output
save("../output/simulation_fixednu_"*sigma*"_"*simulation_string*".jld2",
	"real_wb", real_wage_b, "real_wa", real_wage_a,
	"real_rb", real_rent_b, "real_ra", real_rent_a,
	"res_b", res_b, "res_a", res_a,
	"emp_b", emp_b, "emp_a", emp_a);