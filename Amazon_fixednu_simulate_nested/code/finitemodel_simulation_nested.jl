# This script computes changes in employment and residence and real prices for a given simulation.
import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatsBase

# Function
include("../input/finitemodel_programs.jl")
include("../input/shock_tract.jl")         # A_treatment() to adjust productivity
include("../input/describe_data.jl")

# Arguments
σ = 4.0
α = 0.24
zeta = ARGS[1]
simulation = parse(Int64, ARGS[2])
ζ    = parse(Float64, zeta)

@assert ζ in [0.25, 0.75]
@assert 1 <= simulation <= 100

# Prepare data
## Data before the shock
primitives = load("../input/primitives_nyc2010_time_ntaorigin_"*zeta*".jld2")  

treated_tract = "36081000700" # Long Island City

# Prepare data
(T, A_before, δ̄) = (primitives["landendowment"], primitives["productivity"], primitives["delta_bar"])

A_df = CSV.read("../input/amazon_ctfl_tract_cbm_ntaorigin_"*zeta*"_shock.csv", DataFrame)
A_after   = A_before .* A_df.A_hat

labor_df = sort(CSV.read("../temp/finite_labor_allocation_"*zeta*"_"*ARGS[2]*"_nested.csv", DataFrame), [:j, :i])
num_i    = length(unique(labor_df.i));
num_j    = length(unique(labor_df.j));
ell_b    = convert(Array{Float64,2}, reshape(labor_df.X_ij_before, num_i, num_j));
ell_a    = convert(Array{Float64,2}, reshape(labor_df.X_ij_after, num_i, num_j));


# Define function that takes one set of finite-model simulation and computes prices and quantities 
function solveprices_givenlabor(
	ell::Array{Float64, 2},
	A::Array{Float64,1}, 
	T::Array{Float64,1}, 
	δ̄::Array{Float64,2}, 
	α::Float64, 
	σ::Float64)


	wage, realized_labor = freetrade_equilibrium_solver(A, ell, σ, true, δ̄)
	
	rent = land_rent_solver(realized_labor, wage, T, α)

	p_n = (wage ./ A)
	replace!(p_n, Inf => 0.0)
	P = sum(p_n.^ (1 - σ)) ^ (1/(1-σ))
	
	res = dropdims(sum(ell, dims=2), dims=2)
	emp = dropdims(sum(ell, dims=1), dims=1)
	real_rent = rent ./ P
	real_wage = wage ./ P 

	return real_rent, real_wage, res, emp
end

real_rent_b, real_wage_b, res_b, emp_b = solveprices_givenlabor(ell_b, A_before, T, δ̄, α, σ);
real_rent_a, real_wage_a, res_a, emp_a = solveprices_givenlabor(ell_a, A_after, T, δ̄,  α, σ);


# Output
save("../output/simulation_fixednu_"*zeta*"_"*ARGS[2]*"_nested.jld2",
	"real_wb", real_wage_b, "real_wa", real_wage_a,
	"real_rb", real_rent_b, "real_ra", real_rent_a,
	"res_b", res_b, "res_a", res_a,
	"emp_b", emp_b, "emp_a", emp_a);

describe_data_output("../output/simulation_fixednu_"*zeta*"_"*ARGS[2]*"_nested.jld2")