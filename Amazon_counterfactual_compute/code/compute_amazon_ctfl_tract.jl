import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, UnPack, Roots

include("../input/eha_solver.jl")
include("../input/employment_gap_fn.jl")

treated_tract = "36081000700" # Long Island City
emp_increase = 25_000.0
model_params= load("../input/model_"*ARGS[1]*".jld2")["model_parameters"]
@unpack σ, η, α, ζ, l_share, y_share = model_params

if ζ == 1
	@unpack ε = model_params
else
	@unpack ε_ring = model_params
end

(K, N) = size(l_share)

if ARGS[1] != "csp_2008"
    baseline_flows = DataFrame(load("../input/nyc2010_lodes_wzero_wdelta.dta"))
else
	baseline_flows = DataFrame(load("../input/nyc2008_lodes_wzero_wdelta.dta"))
end
baseline_flows = sort(baseline_flows, [:j, :i])
destination_tractid_vector = unique(baseline_flows.j)
origin_tractid_vector = unique(baseline_flows.i)
if occursin("autarky", ARGS[1])
	destination_tractid_vector = model_params.dest_ids
	origin_tractid_vector = model_params.dest_ids
end
L = sum(baseline_flows.X_ij)
if ARGS[1] != "csp_2008"
    @assert L == 2488905
else
	@assert L == 2271169
end
ell_kn = l_share .* L

if σ == 1.1 
	range_low = 1e12
    range_high = 1e13
	# be careful with the following parameters, 
	# they are particularly sensitive in the case of sigma = 1.1 due to a high potential for local minima
	eha_comp_params = (tol = 1e-3, damp_low = 0.001, damp_high = 0.001, max_iter = 3000)
else
	range_low = 1
	range_high = 12
	eha_comp_params = (tol = 1e-6, damp_low = 0.1, damp_high = 0.3, max_iter = 3000)
end

function compute_employment_gap_wrapper(prod_shock)
    Ā̂_star = ones(N)
    Ā̂_star[destination_tractid_vector .== treated_tract] .= prod_shock
	exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K), δ̄̂ = ones(K,N), λ̂ = ones(K,N))

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

	gap = compute_employment_gap(ŵ_guess, r̂_guess, treated_tract, destination_tractid_vector, emp_increase, model_params, exo_changes, eha_comp_params, L)
    print("Prod shock: ", prod_shock, " Gap: ", gap, "\n")
    return gap
end

A_shock = find_zero(compute_employment_gap_wrapper,(range_low,range_high), Roots.A42(), atol = 1e-6, maxiters = 40) 
Ā̂_star = ones(N)
Ā̂_star[destination_tractid_vector .== treated_tract] .= A_shock

## Solve the counterfactual outcomes given Ā̂_star
exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K), δ̄̂ = ones(K,N), λ̂ = ones(K,N))

if σ == 1.1
	w_guess =  exo_changes.Ā̂ .^ ((σ - 1) / (8 + σ)) #8 instead of epsilon to avoid issues with nested variations
	r_guess = ones(K) .* 1.01
else
	w_guess = exo_changes.Ā̂
	r_guess = ones(K)
end

hat_w, hat_r, hat_ell = eha_solver(w_guess, r_guess, model_params, exo_changes, eha_comp_params)

if σ != Inf
	hat_P = sum(((hat_w ./Ā̂_star) .^(1 - σ)) .* sum(y_share, dims = 1)[:])^(1/(1-σ))
else
	not_one = findall(!=(1.0), hat_w)
	@assert all(hat_w[Ā̂_star .== 1.0] .== 1.0)
    @assert all(isapprox.(hat_w[not_one], Ā̂_star[not_one]; atol=1e-12))
	hat_P = 1.0
end

hat_realr = hat_r./hat_P
hat_realw = hat_w./hat_P

df_ellkn = DataFrame(
    "j" => repeat(destination_tractid_vector, inner = K),
    "i" => repeat(origin_tractid_vector, outer = N),
	"X_ij_before" => vec(ell_kn),
	"X_ij_after" => (vec(hat_ell .* ell_kn)))

df_rent = DataFrame(
	"i" => origin_tractid_vector, 
	"hat_realr" => hat_realr, 
	"hat_r" => hat_r)

df_wage = DataFrame(
	"j" => destination_tractid_vector,
	"hat_realw" => hat_realw,
	"hat_w" => hat_w)
df_shock = DataFrame(
	"j" => destination_tractid_vector,
	"A_hat" => Ā̂_star)

CSV.write("../output/amazon_ctfl_tract_"*ARGS[1]*"_ell.csv", df_ellkn)
CSV.write("../output/amazon_ctfl_tract_"*ARGS[1]*"_wage.csv", df_wage)
CSV.write("../output/amazon_ctfl_tract_"*ARGS[1]*"_rent.csv", df_rent)
CSV.write("../output/amazon_ctfl_tract_"*ARGS[1]*"_shock.csv", df_shock)
