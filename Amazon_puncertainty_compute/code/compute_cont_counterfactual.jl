import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, StatsBase, CSV, UnPack
using Roots

include("../input/eha_solver.jl")
include("../input/baseline_equilibrium_solver.jl")
include("../input/employment_gap_fn.jl")

# Argument
emp_increase = 25000.0
treated_tract = "36081000700" ## Long Island City

# Prepare data
## Data before the shock
primitives = load("../input/primitives_nyc2010_time_puncertainty_"*ARGS[1]*".jld2")
baseline_flows = DataFrame(load("../input/nyc2010_lodes_wzero_wdelta_puncertainty_"*ARGS[1]*".dta"))

#create a dataframe with each i and the sum of X_ij for all j's with that i
destination_tractid_vector = primitives["destination_FIPS"]
destination_tractid_vector = string.(round.(Int, destination_tractid_vector))
L = primitives["pop"]
origin_tractid_vector = unique(baseline_flows[!,:i])
@assert L == sum(baseline_flows[!,:X_ij])

A_vec = primitives["productivity"]
T_vec = primitives["landendowment"]
δ̄_mat = primitives["delta_bar"]
lambda = ones(size(δ̄_mat))
epsilon = abs(parse(Float64,read("../input/nyc2010_time_elasticity_puncertainty_"*ARGS[1]*".csv", String)))
σ = 4.0
α = 0.24

# solve baseline equilibrium outcomes
primitives_tuple = (A_bar = A_vec, T = T_vec, δ_bar = δ̄_mat, λ = lambda, α = 0.24, ε = epsilon, σ = 4.0, η = 0.0, ζ = 1.0, nests = nothing, L = primitives["pop"])

## Before Shock Data in Levels
w_baseline, r_baseline, ell_kn_b = cont_baseline_eqlm_solver(primitives_tuple, 0.2, 1e-9, 1000, false)
K = size(ell_kn_b,1)
N = size(ell_kn_b,2)

P_cont_before = sum((w_baseline ./primitives["productivity"]) .^(1-σ))^(1/(1-σ))
real_r_baseline = r_baseline/P_cont_before
real_w_baseline = w_baseline/P_cont_before
P_k = (r_baseline .^α) * (P_cont_before^(1-α)) 

model_params = (model_class = "cbm",
	α = 0.24,
	ε = abs(parse(Float64,read("../input/nyc2010_time_elasticity_puncertainty_"*ARGS[1]*".csv",String))),
	σ = 4.0,
	η = 0.0,
	ζ = 1.0,
	nests = nothing,
	L = primitives["pop"],
	l_share = ell_kn_b ./ sum(ell_kn_b),
	y_share = (ell_kn_b ./ δ̄_mat).* w_baseline' ./ sum((ell_kn_b ./ δ̄_mat) .* w_baseline')
)

eha_comp_params = (tol = 1e-6, damp_low = 0.1, damp_high = 0.3, max_iter = 2000) #be careful with these, this is particularly sensitive in the case of sigma = 1.1 due to a high potential for local minima

## after the shock
function compute_employment_gap_wrapper(prod_shock::Float64)
    A_hat = ones(N)
    A_hat[destination_tractid_vector .== treated_tract] .= prod_shock
    exo_changes = (Ā̂ = A_hat, T̂ = ones(K), δ̄̂ = ones(K,N), λ̂ = ones(K,N))
	
	if model_params.σ == 1.1
		ŵ_guess = exo_changes.Ā̂ .^ ((model_params.σ - 1) / (model_params.ε + model_params.σ))
		r̂_guess = ones(K) .* 1.01
	elseif model_params.σ == 4.0 && model_params.ζ == 1.0
		ŵ_guess = exo_changes.Ā̂ .^ ((model_params.σ - 1) / (model_params.ε + model_params.σ))
		r̂_guess = ones(K) .* 1.0001
	else
		ŵ_guess = exo_changes.Ā̂
		r̂_guess = ones(K)
	end

	gap = compute_employment_gap(ŵ_guess, r̂_guess, treated_tract,destination_tractid_vector,emp_increase, model_params, exo_changes, eha_comp_params, L)
    print("Prod shock: ", prod_shock, " Gap: ", gap, "\n")
    return gap
end

A_shock = find_zero(compute_employment_gap_wrapper, (3,5), Roots.A42(), atol = 1e-6, maxiters = 40) #Applying the fact that the shock is ~3.5 to the bounds of the search to speed up compute time. These bounds are not what one would use in general.
A_hat = ones(N)
A_hat[destination_tractid_vector .== treated_tract] .= A_shock
exo_changes = (Ā̂ = A_hat, T̂ = ones(K), δ̄̂ = ones(K,N), λ̂ = ones(K,N))
hat_w, hat_r, hat_l = eha_solver(A_hat, ones(K), model_params, exo_changes, eha_comp_params)
w_ctfl = hat_w .* w_baseline
r_ctfl = hat_r .* r_baseline
ell_kn_a = hat_l .* ell_kn_b

P_cont_after = sum((w_ctfl ./(A_hat .* primitives["productivity"])) .^(1-σ))^(1/(1-σ))
real_r_ctfl = r_ctfl/P_cont_after
real_w_ctfl = w_ctfl/P_cont_after
P_k_after = (r_ctfl .^α) * (P_cont_after^(1-α)) 

# Output Results
df_rent_output = DataFrame(hcat(origin_tractid_vector,r_baseline,r_ctfl,real_r_baseline,real_r_ctfl), :auto)
rename!(df_rent_output, :x1 => :i, :x2 => :rb, :x3 => :ra, :x4 => :real_rb, :x5 => :real_ra)
df_rent_output.i = string.(df_rent_output.i)
CSV.write("../output/cont_rent_puncertainty_"*ARGS[1]*".csv", df_rent_output)

df_wage_output = DataFrame(hcat(destination_tractid_vector,w_baseline,w_ctfl,real_w_baseline,real_w_ctfl), :auto)
rename!(df_wage_output, :x1 => :j, :x2 => :wb, :x3 => :wa, :x4 => :real_wb, :x5 => :real_wa)
CSV.write("../output/cont_wage_puncertainty_"*ARGS[1]*".csv", df_wage_output)

df_employment_output = DataFrame(hcat(destination_tractid_vector,sum(ell_kn_b,dims = 1)',sum(ell_kn_a,dims=1)'), :auto)
rename!(df_employment_output, :x1 => :j, :x2 => :emp_b, :x3 => :emp_a)
CSV.write("../output/cont_emp_puncertainty_"*ARGS[1]*".csv", df_employment_output)

df_residents_output = DataFrame(hcat(origin_tractid_vector,sum(ell_kn_b,dims=2),sum(ell_kn_a,dims=2)), :auto)
rename!(df_residents_output, :x1 => :i, :x2 => :res_b, :x3 => :res_a)
df_residents_output.i = string.(df_residents_output.i)
CSV.write("../output/cont_res_puncertainty_"*ARGS[1]*".csv", df_residents_output)