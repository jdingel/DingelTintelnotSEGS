import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames, JLD2, FileIO, StatFiles, UnPack, Roots

# Function
include("../input/eha_solver.jl")
include("../input/employment_gap_fn.jl")

# Extract passed-in arguments
A_shock = parse(Float64, ARGS[1])
@assert A_shock == 1.09
seed = parse(Int, ARGS[2])
@assert seed ∈ (1:100)

# Set arguments
treatmentID = 1145
σ = 4.0
epsilon = abs(parse(Float64,read("../temp/elasticity_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.csv", String)))

# Prepare data
df = CSV.read("../input/DGP_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.csv", DataFrame)
orig_df = DataFrame(load("../temp/fe_i_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.dta"))
orig_df = sort(orig_df[completecases(orig_df),:],[:i])
rename!(orig_df,["id_i","fe_i_ppml"])

dest_df = DataFrame(load("../temp/fe_j_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.dta"))
dest_df = sort(dest_df[completecases(dest_df),:], [:j])
dest_df = dest_df[completecases(dest_df),:]
rename!(dest_df,["id_j", "fe_j_ppml"])
dest_tractIDS = dest_df.id_j

lodes_df = CSV.read("../input/nyc2010_lodes_wzero_wdelta.csv", DataFrame)
agg_labor = load("../temp/primitives_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.jld2")["pop"]

delta_df = select(lodes_df, :id_j, :id_i, :delta)
rename!(delta_df, :delta=>:bardelta)

df = innerjoin(df, orig_df, on=:id_i)
df = innerjoin(df, dest_df, on=:id_j)
df = innerjoin(df, delta_df, on=[:id_i,:id_j])
df = sort(df, [:id_j, :id_i])

K_dgp = length(unique(df[!,:id_i]))
N_dgp = length(unique(df[!,:id_j]))

# Replace missing δ̄ with Inf and create a commuting cost matrix
df[!,:bardelta] = convert(Array{Float64,1},coalesce.(df[!,:bardelta],Inf))
δ̄ = reshape(df[!,:bardelta], K_dgp, N_dgp)

# Load commuting matrix before the shock
ell_pre = reshape(df[!,:X_ij_before], K_dgp, N_dgp)
ell_pre = convert(Array{Float64,2}, ell_pre)

# Compute employment increase
emp_b = sum(df[df[!,:id_j] .== treatmentID,:][!,:X_ij_before])
emp_a = sum(df[df[!,:id_j] .== treatmentID,:][!,:X_ij_after])
emp_increase = emp_a - emp_b
emp_ratio = emp_a/emp_b
@assert emp_ratio > 1.0

# Load the productivity shock solved by CBM as the initial guess for CSP
Â_cont = load("../temp/cbm_shock_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.jld2")["A_shock"]

# Load continuum wages 
wage_df = CSV.read("../input/DGP_continuum_0_"*ARGS[1]*"_1_w.csv", DataFrame) # With Λ == 0, simulations are identical.    
wage_df = innerjoin(wage_df, dest_df, on=:id_j)
wage = convert(Array{Float64, 1}, wage_df[!, :nom_w_pre])

# Find and save the required productivity shock
model_params = (
    α = 0.24,
    ε = epsilon,
    σ = 4.0,
    η = 0.0,
    ζ = 1.0,
    nests = nothing,
    l_share = ell_pre ./ sum(ell_pre),
    y_share = (ell_pre .* wage' ./ δ̄) ./ sum(ell_pre .* wage' ./δ̄)
)

eha_comp_params = (tol = 1e-6, damp_low = 0.2, damp_high = 0.2, max_iter = 500)

# Use better price guess to speed up the inner loop of the shock solver
Â_csp_guess = ones(N_dgp)
Â_csp_guess[dest_tractIDS .== treatmentID] .= Â_cont
exo_changes = (Ā̂ = Â_csp_guess, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
ŵ_guess, r̂_guess, _ = eha_solver(ones(N_dgp), ones(K_dgp), model_params, exo_changes, eha_comp_params; show_every=5)

function compute_employment_gap_wrapper(prod_shock)
    Ā̂_star = ones(N_dgp)
    Ā̂_star[dest_tractIDS .== treatmentID] .= prod_shock
	exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
	gap = compute_employment_gap(ŵ_guess, r̂_guess, treatmentID, dest_tractIDS, emp_increase, model_params, exo_changes, eha_comp_params, agg_labor)
    print("Prod shock: ", prod_shock, " Gap: ", gap, "\n")
    return gap
end

A_shock = find_zero(compute_employment_gap_wrapper,(1, 8), Roots.A42(), atol = 1e-6) 

save("../temp/csp_shock_"*ARGS[1]*"_"*ARGS[2]*"_fixednu.jld2","A_shock", A_shock)

# Compute post shock equilibrium using EHA solver
Ā̂_star = ones(N_dgp)
Ā̂_star[dest_tractIDS .== treatmentID] .= A_shock
exo_changes = (Ā̂ = Ā̂_star, T̂ = ones(K_dgp), δ̄̂ = ones(K_dgp, N_dgp), λ̂ = ones(K_dgp, N_dgp))
ŵ_star, r̂_star, l̂_star = eha_solver(ones(N_dgp), ones(K_dgp), model_params, exo_changes, eha_comp_params; show_every=5)

# changes in commuting flows in the treated tract pair
ell_treated_pre = ell_pre[:, dest_tractIDS .== treatmentID][:]
ell_treated_post = (ell_pre .* l̂_star)[:, dest_tractIDS .== treatmentID][:]

ell_change = ell_treated_post .- ell_treated_pre
output_df = DataFrame(id_i = orig_df.id_i, id_j = treatmentID, diff_csp = ell_change)

# Output
CSV.write("../output/prediction_csp_"*ARGS[1]*"_"*ARGS[2]*"_treated_ell_change_fixednu.csv", output_df)
