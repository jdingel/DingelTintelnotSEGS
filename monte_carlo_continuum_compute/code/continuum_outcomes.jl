import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames, Distributions, JLD2, FileIO, StatFiles, Statistics, Random, UnPack

# Functions
include("../input/baseline_equilibrium_solver.jl")
include("../input/eha_solver.jl")
include("../input/employment_gap_fn.jl")
include("../input/hat_P.jl")

# Extract passed-in arguments
Λ = parse(Float64, ARGS[1])
Â_dgp = parse(Float64, ARGS[2])
@assert Â_dgp == 1.09
seed = parse(Int, ARGS[3])

cond1 = (Λ == 0 && seed ∈ [1, 2])
cond2 = (Λ ∈ [0.1, 0.25, 0.5, 1.0] && seed ∈ (1:100))
@assert cond1 || cond2 "Continuum simulations are deterministic when Λ == 0"

# Set arguments
treatmentID = 1145
σ = 4.0
α = 0.24
epsilon = abs(parse(Float64,read("../input/nyc2010_time_elasticity.csv",String)))

# Prepare data
primitives = load("../input/primitives_nyc2010_time.jld2") 
(K, N) = size(primitives["delta_bar"])
A_pre = primitives["productivity"]
T_pre = primitives["landendowment"]
δ̄ = primitives["delta_bar"]

# Import LODES
lodes_df = CSV.read("../input/nyc2010_lodes_wzero_wdelta.csv", DataFrame)
lodes_df = sort(lodes_df, [:id_j, :id_i])
agg_labor = convert(Float64,sum(lodes_df[!,:X_ij]))

# Draw log(λₖₙ)
log_δ̄ = log.(δ̄)
std_log_δ̄ = std(vec(log_δ̄)[vec(log_δ̄) .!=Inf]) # There are two tract pairs where commute infeasible
std_log_λ_pop = Λ * std_log_δ̄
Random.seed!(seed);
log_λ = rand(Normal(0, std_log_λ_pop), size(log_δ̄)) # The 2nd argument of Normal() is std.
λ_sim = exp.(log_λ)

primitives_pre = (A_bar = A_pre, T = T_pre, δ_bar = δ̄, 
    λ = λ_sim, 
    α = α, ε = epsilon, σ = σ, η = 0, ζ = 1.0, nests = nothing, L = agg_labor
)

# Double-check Monte Carlo DGP
println("Population variance of log(λ): ", std_log_λ_pop^2)
println("Sample variance of log(λ): ", var(log_λ))
@assert abs((std_log_λ_pop^2)/var(log_λ) - 1) < 0.05 || Λ .== 0.0

# Baseline equilibrium in levels
w_pre, r_pre, ell_pre = cont_baseline_eqlm_solver(primitives_pre, 0.1, 1e-5, 1000, true)

p_nb = w_pre ./ A_pre
replace!(p_nb, Inf => 0.0)
P_b = (sum(p_nb.^(1-σ)))^(1/(1-σ))

# Post shock equilibrium
# Initial share for the EHA
model_params = (
    α = α,
    ε = epsilon,
    σ = σ,
    η = 0.0,
    ζ = 1.0,
    nests = nothing,
    l_share = ell_pre ./ sum(ell_pre),
    y_share = (ell_pre .* w_pre' ./ δ̄) ./ sum(ell_pre .* w_pre' ./δ̄)
)

eha_comp_params = (tol = 1e-6, damp_low = 0.2, damp_high = 0.2, max_iter = 1000)

# Compute post shock equilibrium using EHA
Ā̂_vec = ones(N)
Ā̂_vec[treatmentID] = Â_dgp
@assert sum(Ā̂_vec .> 1.0) == 1
@assert maximum(Ā̂_vec) == Â_dgp

exo_changes = (Ā̂ = Ā̂_vec, T̂ = ones(K), δ̄̂ = ones(K, N), λ̂ = ones(K, N))
ŵ_star, r̂_star, l̂_star = eha_solver(ones(N), ones(K), model_params, exo_changes, eha_comp_params; show_every=5)
ell_post = ell_pre .* l̂_star

# Save commuting flows' DGP
ell_df = DataFrame(id_j = lodes_df.id_j, id_i = lodes_df.id_i, X_ij_before = ell_pre[:], X_ij_after = ell_post[:])

# Save prices' DGP
P̂_star = hat_P(Ā̂_vec, ŵ_star, model_params.y_share, σ)
wages_df = DataFrame(id_j = collect(1:N), nom_w_pre = w_pre, hat_w = ŵ_star, hat_realw = ŵ_star/P̂_star)
rents_df = DataFrame(id_i = collect(1:K), nom_r_pre = r_pre,  hat_r = r̂_star, hat_realr = r̂_star/P̂_star)

# Output
CSV.write("../output/DGP_continuum_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_ell.csv", ell_df)
CSV.write("../output/DGP_continuum_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_w.csv", wages_df)
CSV.write("../output/DGP_continuum_"*ARGS[1]*"_"*ARGS[2]*"_"*ARGS[3]*"_r.csv", rents_df)
