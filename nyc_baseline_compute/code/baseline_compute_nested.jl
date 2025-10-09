import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, Roots, StatsBase, Parameters, UnPack

include("baseline_equilibrium_solver.jl") # baseline equilibrium solver

type = ARGS[1]
@assert type ∈ ["ntaorigin", "workplace", "residence"]

primitives = load(ARGS[3])

# elasticities
epsilon_ring = primitives["epsilon_ring"]
alpha = 0.24
sigma = 4.0
eta = 0.0
zeta = abs(parse(Float64,ARGS[2]))
@assert zeta ∈ [0.25, 0.5, 0.75]

# exogenous parameters
A_vec = primitives["productivity"]
T_vec = primitives["landendowment"]
nests = primitives["nests"]
δ̄_mat = primitives["delta_bar"]
lambda = ones(size(δ̄_mat))

# solve baseline equilibrium outcomes
max_iter = 2000
tol = 1e-9
verbose = false
damp = zeta > 0.5 ? 0.2 : 0.15
primitives_tuple = (A_bar = A_vec, T = T_vec, δ_bar = δ̄_mat, λ = lambda, α = alpha, ε_ring = epsilon_ring, σ = sigma, η = eta, ζ = zeta, nests = nests, L = primitives["pop"])

cont_w_b, cont_r_b, ell_kn_b = cont_baseline_eqlm_solver(primitives_tuple, damp, tol, max_iter, verbose)

save("../output/baseline_equilibrium_outcomes_"*type*"_"*string(zeta)*".jld2", "CommutingFlows", ell_kn_b, "rents", cont_r_b[:], "wages", cont_w_b[:])