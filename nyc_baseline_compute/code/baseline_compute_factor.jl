import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, Roots, StatsBase, Parameters, UnPack

include("baseline_equilibrium_solver.jl") # baseline equilibrium solver

primitives = load(ARGS[2])

# elasticities
epsilon = primitives["epsilon"]
alpha = 0.24
sigma = 4.0
eta = 0.0
zeta = 1.0

# exogenous parameters
A_vec = primitives["productivity"]
T_vec = primitives["landendowment"]
δ̄_mat = primitives["delta_bar"]
lambda = primitives["lambda"]

# solve baseline equilibrium outcomes
max_iter = 1000
tol = 1e-9
verbose = false
damp = 0.2
primitives_tuple = (A_bar = A_vec, T = T_vec, δ_bar = δ̄_mat, λ = lambda, α = alpha, ε = epsilon, σ = sigma, η = eta, ζ = zeta, nests = nothing, L = primitives["pop"])

cont_w_b, cont_r_b, ell_kn_b = cont_baseline_eqlm_solver(primitives_tuple, damp, tol, max_iter, verbose)

save(ARGS[1], "CommutingFlows", ell_kn_b, "rents", cont_r_b[:], "wages", cont_w_b[:])