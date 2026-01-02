import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, StatFiles, JLD2, FileIO, CSV, StatsBase

# Function
include("../input/finitemodel_programs.jl")

# Parameter
primitives = load("../input/primitives_nyc2010_time.jld2")
σ = 4.0
α = 0.24
ε = primitives["epsilon"]
simulation_count = 10

# Prepare data
CBM_baseline = load("../input/baseline_equilibrium_outcomes_sigma_4.0.jld2")
wage = CBM_baseline["wages"]
rent = CBM_baseline["rents"]
P = sum((wage ./ primitives["productivity"]).^(1 - σ))^(1 / (1 - σ))

w_matrix = zeros(length(primitives["productivity"]),simulation_count);
realw_matrix = zeros(length(primitives["productivity"]),simulation_count);
r_matrix = zeros(length(primitives["landendowment"]),simulation_count);
realr_matrix = zeros(length(primitives["landendowment"]),simulation_count);

# price dispersion
for s in 1:simulation_count
	s_str = string(s)
	labor = reshape(convert(Array{Float64,1},DataFrame(load("../temp/realized_commuting_flows_s"*s_str*".dta"))[!,:X_ij]),length(primitives["landendowment"]),length(primitives["productivity"]))
	wage_realize, rl = freetrade_equilibrium_solver(primitives["productivity"],labor,σ,true,primitives["delta_bar"])
	rent_realize = land_rent_solver(rl,wage_realize,primitives["landendowment"],α)
	P_realize = sum(((wage_realize ./primitives["productivity"])[(wage_realize ./primitives["productivity"]) .>0.0]) .^(1-σ))^(1/(1-σ))

	w_matrix[:,s] = wage_realize
	realw_matrix[:,s] = wage_realize/P_realize
	r_matrix[:,s] = rent_realize
	realr_matrix[:,s] = rent_realize/P_realize
end

# Calculate coefficient of variation
function calculate_dispersion(matrix::Array{Float64,2},benchmark::Array{Float64,1})
	std_matrix = zeros(length(benchmark))
	for i in 1:length(std_matrix)
		std_matrix[i] = std(matrix[i,:])
	end

	dispersion = std_matrix ./benchmark
	return dispersion
end

dispersion_wage = calculate_dispersion(w_matrix,wage)
dispersion_realwage = calculate_dispersion(realw_matrix,wage ./ P)
dispersion_rent = calculate_dispersion(r_matrix,rent)
dispersion_realrent = calculate_dispersion(realr_matrix,rent ./ P)

# Output
wage_output = DataFrame(hcat(dispersion_wage,dispersion_realwage), :auto)
rename!(wage_output, :x1=>:wage, :x2=>:realwage)
CSV.write("../output/dispersion_expost_wage.csv",wage_output)

rent_output = DataFrame(hcat(dispersion_rent,dispersion_realrent), :auto)
rename!(rent_output, :x1=>:rent, :x2=>:realrent)
CSV.write("../output/dispersion_expost_rent.csv",rent_output)
