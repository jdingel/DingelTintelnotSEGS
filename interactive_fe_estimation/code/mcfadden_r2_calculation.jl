import Pkg
Pkg.activate("../input/Project.toml")
using CSV, DataFrames, Statistics, SpecialFunctions, FileIO

function poisson_log_ll(Y, X, beta, fe)
    Z = X * beta .+ fe
    sum(Y .* Z .- exp.(Z)) - sum(map(y -> loggamma(y + 1), Y))
end

lodes_data = DataFrame(load("../input/nyc2010_lodes_wzero_wdelta.dta"))
lodes_data = sort(lodes_data, [:j, :i])
X = convert(Array{Float64}, coalesce.(lodes_data[:, :log_delta], 9))
Y = convert(Array{Float64}, coalesce.(lodes_data[:, :X_ij], 0))

I = length(unique(lodes_data[:, :i]))
J = length(unique(lodes_data[:, :j]))
Rmax = parse(Int64, ARGS[1])

beta = map(r -> 
            CSV.File(open(string("../output/beta_", r, ".csv")), header = 0) |> 
                Tables.matrix |> 
                (x -> x[1]), 
            0:Rmax)

additive_fes = map(r -> 
                [CSV.File(open(string("../output/fe_i_", r, ".csv")), header = 0, select = [2]) |> 
                Tables.matrix, 
                CSV.File(open(string("../output/fe_j_", r, ".csv")), header = 0, select = [2]) |> 
                Tables.matrix],
                    0:Rmax)

additive_fes_sum = map((x -> reshape(x[1] * ones(1, J) + ones(I, 1) * x[2]', I*J, 1)), additive_fes)
ife = map((r -> CSV.File(open(string("../output/ife_ij_", r, ".csv")), 
                                    header = 0, select = [3]) |> 
                            Tables.matrix), 0:Rmax)

constants = map((r -> log(sum(Y)) - log(sum(exp.(X .* beta[r] + additive_fes_sum[r] + ife[r])))), 1:(Rmax+1))

lls = map(r -> poisson_log_ll(Y, X, beta[r], additive_fes_sum[r] + ife[r] .+ constants[r]), 1:(Rmax+1))
ll_null = poisson_log_ll(Y, X, 0, log(mean(Y)) .* ones(I * J, 1))
mcFaddenRSquared = map(t -> (1 - t / ll_null), lls)

CSV.write("../temp/ife_mcf_r2.csv", DataFrame(R = 0:Rmax, R2 = mcFaddenRSquared))