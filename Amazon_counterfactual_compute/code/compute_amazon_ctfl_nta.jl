import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, UnPack, Roots

include("../input/eha_solver.jl")
include("../input/employment_gap_fn.jl")

treated_nta = "QN31" # Long Island City
emp_increase = 25_000.0
model_params= load("../input/model_"*ARGS[1]*".jld2")["model_parameters"]
@unpack ε, σ, η, α, ζ, l_share, y_share = model_params
@assert σ != Inf

baseline_flows = DataFrame(load("../input/nyc_NTA_2012_2010_observed_changes_origtodest.dta"))
baseline_flows = sort(baseline_flows, [:j, :i])
destination_ntaid_vector = unique(baseline_flows.j)
origin_ntaid_vector = unique(baseline_flows.i)
L = sum(baseline_flows.X_ij_preperiod)
@assert L == 2488905

ell_kn = l_share .* L
(K, N) = size(l_share)

if σ == 1.1 
	range_low = 1e12
    range_high = 1e13
else
	range_low = 1
    range_high = 6
end

eha_comp_params = (tol = 1e-6, damp_low = 0.01, damp_high = 0.05, max_iter = 2000) #be careful with these, this is particularly sensitive in the case of sigma = 1.1 due to a high potential for local minima

function compute_employment_gap_wrapper(prod_shock::Float64)
    Ā̂_star = ones(N)
    Ā̂_star[destination_ntaid_vector .== treated_nta] .= prod_shock
    exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K), δ̄̂ = ones(K, N), λ̂ = ones(K, N))
	
	if σ == 1.1
		ŵ_guess = exo_changes.Ā̂ .^ ((σ - 1) / (ε + σ))
		r̂_guess = ones(K) .* 1.01
	elseif σ == 4.0 && ζ == 1.0
		ŵ_guess = exo_changes.Ā̂ .^ ((σ - 1) / (ε + σ))
		r̂_guess = ones(K) .* 1.0001
	else
		ŵ_guess = exo_changes.Ā̂
		r̂_guess = ones(K)
	end

	gap = compute_employment_gap(ŵ_guess, r̂_guess, treated_nta, destination_ntaid_vector, emp_increase, model_params, exo_changes, eha_comp_params, L)
    print("Prod shock: ", prod_shock, " Gap: ", gap, "\n")
    return gap
end

A_shock=find_zero(compute_employment_gap_wrapper,(range_low,range_high),Roots.A42(), atol = 1e-6, maxiters = 40) 
Ā̂_star = ones(N)
Ā̂_star[destination_ntaid_vector .== treated_nta] .= A_shock
exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K), δ̄̂ = ones(K, N), λ̂ = ones(K, N))

hat_w, hat_r, hat_ell = eha_solver(Ā̂_star, ones(K), model_params, exo_changes, eha_comp_params)

hat_P = sum(((hat_w ./Ā̂_star) .^(1-σ)) .* sum(y_share, dims = 1)[:])^(1/(1-σ))
hat_realr = hat_r/hat_P
hat_realw = hat_w/hat_P
print(size(ell_kn))
print(size(hat_ell))

df_ellkn = DataFrame(
    "j" => baseline_flows.j,
    "i" => baseline_flows.i,
	"X_ij_before" => vec(ell_kn),
	"X_ij_after" => (vec(hat_ell .* ell_kn)))

df_rent = DataFrame(
	"i" => origin_ntaid_vector, 
	"hat_realr" => hat_realr, 
	"hat_r" => hat_r)

df_wage = DataFrame(
	"j" => destination_ntaid_vector,
	"hat_realw" => hat_realw,
	"hat_w" => hat_w)
df_shock = DataFrame(
	"j" => destination_ntaid_vector,
	"A_hat" => Ā̂_star)

CSV.write("../output/amazon_ctfl_"*ARGS[1]*"_ell.csv", df_ellkn)
CSV.write("../output/amazon_ctfl_"*ARGS[1]*"_wage.csv", df_wage)
CSV.write("../output/amazon_ctfl_"*ARGS[1]*"_rent.csv", df_rent)
CSV.write("../output/amazon_ctfl_"*ARGS[1]*"_shock.csv", df_shock)
