# This script computes changes in employment, residence and real prices
# for a given labor allocation simulated in `finitemodel_simulate_choices_NTA.jl` 
# and collected in `finitemodel_collect_choices_NTA.do`.

import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatsBase

# Function
include("../input/finitemodel_programs.jl")
include("../input/shock_tract.jl")

# Arguments
simulation = parse(Int64, ARGS[1])                    # round of outer simulation
@assert 1 <= simulation <= 100
treated_NTA = "QN31"  # Hunters Point-Sunnyside-West Maspeth

# Model Parameters
σ = 4.0
α = 0.24
ε = abs(parse(Float64,read("../input/nyc_NTA_2010_time_elasticity.csv",String)))

# Prepare data
A_hat = CSV.read("../input/amazon_ctfl_cbm_nta_shock.csv", DataFrame).A_hat
primitives = load("../input/primitives_nyc_NTA_2010_time.jld2")
(T, A_before, δ̄) = (primitives["landendowment"], primitives["productivity"], primitives["delta_bar"])
A_after = A_before .* A_hat

labor_df = sort(CSV.read("../temp/finite_labor_allocation_NTA_s"*ARGS[1]*".csv", DataFrame), [:j,:i])
num_i = length(unique(labor_df.i))
num_j = length(unique(labor_df.j))
ell_b = convert(Array{Float64,2}, reshape(labor_df.X_ij_before, num_i, num_j));
ell_a = convert(Array{Float64,2}, reshape(labor_df.X_ij_after, num_i, num_j));


# Define function that takes a (finite-model) labor allocation and computes prices and quantities 
function solveprices_givenlabor(ell_kn::Array{Float64, 2},
	A_n::Array{Float64,1}, T_k::Array{Float64,1}, δ̄::Array{Float64,2}, α::Float64, σ::Float64)
	
	wage, realized_labor = freetrade_equilibrium_solver(A_n, ell_kn, σ, true, δ̄)
	rent = land_rent_solver(realized_labor, wage, T_k, α)
	p_n = (wage ./ A_n)
	replace!(p_n, Inf => 0.0)
	P = sum(p_n.^(1 - σ)) ^ (1/(1-σ))

	res = dropdims(sum(ell_kn, dims=2), dims=2)
	emp = dropdims(sum(ell_kn, dims=1), dims=1)
	real_rent = rent ./ P
	real_wage = wage ./ P 

	return real_rent, real_wage, res, emp
end

real_rent_b, real_wage_b, res_b, emp_b = solveprices_givenlabor(ell_b, A_before, T, δ̄, α, σ);
real_rent_a, real_wage_a, res_a, emp_a = solveprices_givenlabor(ell_a, A_after, T, δ̄, α, σ);


# Output
save("../output/simulation_fixednu_NTA_s"*ARGS[1]*".jld2",
	"real_wb", real_wage_b, "real_wa", real_wage_a,
	"real_rb", real_rent_b, "real_ra", real_rent_a,
	"res_b", res_b, "res_a", res_a,
	"emp_b", emp_b, "emp_a", emp_a);