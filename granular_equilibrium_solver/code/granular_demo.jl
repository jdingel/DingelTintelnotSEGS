import Pkg
Pkg.activate("../input/Project.toml")
using Random
include("granular_programs.jl")

##Simulate a free-commuting model with beliefs of equal wages and equal rents
α = 0.4;
σ = 3.0;
ε = 1.0;
headcount = 25;
A = ones(10);
T = ones(10);
prob = prob_i_choose_kn(ones(10),ones(10),ones(10,10),ε,α)
L = labor_realization(10,10,prob,headcount,headcount)
wages,rl = freetrade_equilibrium_solver(A,L,σ,true,ones(10,10))
rents = land_rent_solver(rl,wages,T,α)

#print all of the above to an output file
open("../output/demo_confirmation.txt", "w") do io
    println(io, "residents: ",dropdims(sum(L,dims=2),dims=2))
    println(io, "employees: ",dropdims(sum(L,dims=1),dims=1))
    println(io, "wages: ",round.(wages;digits=3))
    println(io, "rents: ",round.(rents;digits=3))
    println(io, "rents per resident: ",round.(rents ./ dropdims(sum(L,dims=2),dims=2);digits=3))
    println(io, "var(rents): ", round(var(rents);digits=4)," var(wages): ",round(var(wages);digits=4))
end