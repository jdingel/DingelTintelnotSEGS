import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatsBase
# Function
include("finitemodel_programs.jl")
function granular_simulation(wage::Array{Float64,1},rent::Array{Float64,1},productivity::Array{Float64,1},landendowment::Array{Float64,1},delta::Array{Float64,2},ε::Float64,α::Float64,σ::Float64,pop::Float64,start_seed::Int64,simulation_count::Int64)
	prob = prob_i_choose_kn(wage,rent,delta,ε,α)
	rent_matrix = zeros(length(rent),simulation_count)
	wage_matrix = zeros(length(wage),simulation_count)
	res_matrix = zeros(length(rent),simulation_count)
	emp_matrix = zeros(length(wage),simulation_count)
	P = zeros(simulation_count)
	for i in 1:simulation_count
		seed = start_seed + i - 1
		labor = labor_realization(length(rent), length(wage), prob,pop,pop,seed)
		wage,rl = freetrade_equilibrium_solver(productivity,labor,σ,true,delta)
		wage_matrix[:,i] = wage
		rent_matrix[:,i] = land_rent_solver(rl,wage,landendowment,α)
		res_matrix[:,i] = dropdims(sum(labor,dims=2),dims=2)
		emp_matrix[:,i] = dropdims(sum(labor,dims=1),dims=1)
		p_n = (wage_matrix[:,i] ./ productivity)
		replace!(p_n,Inf => 0.0)
		P[i] = (sum(p_n.^(1-σ)))^(1/(1-σ))    
	end
	real_rent_matrix = rent_matrix ./ repeat(P', length(landendowment),1)
	real_wage_matrix = wage_matrix ./ repeat(P', length(productivity),1)
	return real_rent_matrix, real_wage_matrix, res_matrix, emp_matrix
end
# Arguments
σ = parse(Float64, ARGS[1])
sim = parse(Int64, ARGS[2])
@assert σ > 1.0
α = 0.24
ε = abs(parse(Float64,read("../input/nyc2010_time_elasticity.csv",String)))
simulation_count = 1000
# Prepare data
baseline_outcomes = load("../input/baseline_equilibrium_outcomes_sigma_"*ARGS[1]*".jld2")
cont_wb = convert(Array{Float64,1},baseline_outcomes["wages"])
cont_rb = convert(Array{Float64,1},baseline_outcomes["rents"])
primitives = load("../input/primitives_nyc2010_time_sigma_"*ARGS[1]*".jld2")

# Simulation
real_r_mat,real_w_mat,res_mat,emp_mat = granular_simulation(cont_wb,cont_rb,primitives["productivity"],primitives["landendowment"],
                                                            primitives["delta_bar"],ε,α,σ,primitives["pop"],
                                                            1+simulation_count*(sim-1),simulation_count)
# Output
save("../output/jensen_simulation_sigma_"*ARGS[1]*"_simulation_"*ARGS[2]*".jld2",
	"real_wb",real_w_mat,
	"real_rb",real_r_mat, 
	"res_b",res_mat, 
	"emp_b",emp_mat)