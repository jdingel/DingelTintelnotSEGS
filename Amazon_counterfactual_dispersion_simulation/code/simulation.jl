import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatsBase

# Function
include("../input/finitemodel_programs.jl")

function granular_simulation(wage::Array{Float64,1},rent::Array{Float64,1},productivity::Array{Float64,1},landendowment::Array{Float64,1},delta::Array{Float64,2},ε::Float64,α::Float64,σ::Float64,pop::Float64,start_seed::Int64,simulation_count::Int64=10000)
	prob = prob_i_choose_kn(wage,rent,delta,ε,α)
	rent_matrix = zeros(length(rent),simulation_count)
	wage_matrix = zeros(length(wage),simulation_count)
	res_matrix = zeros(length(rent),simulation_count)
	emp_matrix = zeros(length(wage),simulation_count)
	K = length(rent)
	N = length(wage)

	for i in 1:simulation_count
		seed = start_seed + i - 1
		labor = labor_realization(K,N,prob,pop,pop,seed)
		wage,rl = freetrade_equilibrium_solver(productivity,labor,σ,true,delta)
		wage_matrix[:,i] = wage
		rent_matrix[:,i] = land_rent_solver(rl,wage,landendowment,α)
		res_matrix[:,i] = dropdims(sum(labor,dims=2),dims=2)
		emp_matrix[:,i] = dropdims(sum(labor,dims=1),dims=1)
	end

	P = zeros(simulation_count)
	for i in 1:simulation_count
		p_n = (wage_matrix[:,i] ./ productivity).^(1-σ)
		replace!(p_n,Inf => 0.0)
		P[i] = (sum(p_n))^(1/(1-σ))    
	end

	real_rent_matrix = rent_matrix ./ repeat(P', length(landendowment),1)
	real_wage_matrix = wage_matrix ./ repeat(P', length(productivity),1)

	return real_rent_matrix,real_wage_matrix, res_matrix, emp_matrix
end


# Arguments
σ=4.0
α = 0.24
ε = abs(parse(Float64,read("../input/nyc2010_time_elasticity.csv",String)))
treated_tract = "36081000700" ## Long Island City

@assert parse(Int64,ARGS[1])>=1 && parse(Int64,ARGS[1])<=10 ## We run ten sets of simulations.
simulation_count=10000
start_seed = simulation_count*(parse(Int64,ARGS[1])-1)+1
end_seed = parse(Int64,ARGS[1])*simulation_count

# Prepare data
cont_rent = CSV.read("../input/amazon_ctfl_tract_cbm_sigma_4.0_rent.csv", DataFrame)
cont_wage = CSV.read("../input/amazon_ctfl_tract_cbm_sigma_4.0_wage.csv", DataFrame)
primitives = load("../input/primitives_nyc2010_time.jld2")
A_shock = CSV.read("../input/amazon_ctfl_tract_cbm_sigma_4.0_shock.csv", DataFrame)
baseline_eqlm = load("../input/baseline_equilibrium_outcomes_sigma_4.0.jld2")

cont_wb = baseline_eqlm["wages"]
cont_rb = baseline_eqlm["rents"]
cont_wa = cont_wb .* cont_wage[!,"hat_w"]
cont_ra = cont_rb .* cont_rent[!,"hat_r"]
Pb = sum((cont_wb ./ primitives["productivity"]).^(1 - σ))^(1 / (1 - σ))
prod_after = primitives["productivity"] .* A_shock[!,"A_hat"]
Pa = sum((cont_wa ./ prod_after).^(1 - σ))^(1 / (1 - σ))
cont_real_wb = cont_wb ./ Pb
cont_real_rb = cont_rb ./ Pb
cont_real_wa = cont_wa ./ Pa
cont_real_ra = cont_ra ./ Pa

# Simulation
print("Initializing Simulation")
real_rb_mat,real_wb_mat,res_b_mat,emp_b_mat = granular_simulation(cont_wb,cont_rb,primitives["productivity"],primitives["landendowment"],primitives["delta_bar"],ε,α,σ,primitives["pop"],start_seed)
real_ra_mat,real_wa_mat,res_a_mat,emp_a_mat = granular_simulation(cont_wa,cont_ra,prod_after,primitives["landendowment"],primitives["delta_bar"],ε,α,σ,primitives["pop"],start_seed)

# Output
save("../output/simulation"*ARGS[1]*".jld2",
	"real_wb",real_wb_mat, "real_wa",real_wa_mat,
	"real_rb",real_rb_mat, "real_ra",real_ra_mat,
	"res_b",res_b_mat, "res_a",res_a_mat,
	"emp_b",emp_b_mat, "emp_a", emp_a_mat,
	"cont_real_wb",cont_real_wb, "cont_real_rb",cont_real_rb,
	"cont_real_wa",cont_real_wa, "cont_real_ra",cont_real_ra)