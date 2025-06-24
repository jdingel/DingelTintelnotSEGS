import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, StatsBase

tuple = (a = [1.0; 2.0; 3.0], b = [4.0; 5.0; 6.0], c = "hello world")

save("../output/named_tuple_mwe.jld2", "my_tuple", tuple)