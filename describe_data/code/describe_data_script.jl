import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, StatsBase
include("../input/describe_data.jl")

describe_data_output(ARGS[1])
