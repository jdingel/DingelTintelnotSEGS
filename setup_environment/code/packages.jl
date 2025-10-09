##This script instantiates the Julia packages used throughout the project.

import Pkg
Pkg.activate("../output")
Pkg.instantiate()
using LinearAlgebra, Random, Distributions
using Optim # contains optimization methods: GradientDescent(), L-BFGS()
using CSV, DataFrames, JLD2, FileIO, StatsBase, StatFiles
using HypothesisTests, Plots, KernelDensity, GLM
using Roots
using Distances, StatsFuns, Calculus, LaTeXStrings
using ZipFile
using GLM # general linear models
using NMF # non-negative matrix factorization
using Interpolations
using CategoricalArrays # contains the function levelcode
using Parameters, UnPack
using TimerOutputs # Julia's macro @timeit

open("../output/julia_packages.txt", "w") do f
    write(f, "Successfully instantiated Project.toml")
end
