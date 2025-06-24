#Purpose: a simple test of SVD_approximation()

import Pkg
Pkg.activate("../input/Project.toml")
using Random, LinearAlgebra, Test
include("SVD_funcs.jl")

@testset "Low-rank approximation via SVD" begin 

	Random.seed!(1)
	X = rand(5,5)
	@test minimum(abs.(X - SVD_approximation(X,rank(X))) .< 10e-5)

end;