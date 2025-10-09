import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, Roots, StatsBase

simulation = parse(Int64, ARGS[1])
function total_income_loop(i)
    primitives = load("../input/primitives_nyc2010_time.jld2")
    δ̄ = primitives["delta_bar"]
        simulation = load("../input/simulation_fixednu_4.0_" * string(i) * ".jld2")
        simulation_ell = CSV.read("../temp/finite_labor_allocation_s" * string(i) * ".csv", DataFrame)
        orig_tract_length = length(simulation["real_rb"])
        dest_tract_length = length(simulation["real_wa"])
        
        X_ij_before = simulation_ell[!, :X_ij_before] 
        realized_ell_kn_before = reshape(X_ij_before, (orig_tract_length, dest_tract_length))./ δ̄
        real_wages_before = simulation["real_wb"]
        Y_b = sum(repeat(real_wages_before',orig_tract_length) .* realized_ell_kn_before)

        X_ij_after = simulation_ell[!, :X_ij_after] 
        realized_ell_kn_after = reshape(X_ij_after, (orig_tract_length, dest_tract_length)) ./ δ̄
        real_wages_after = simulation["real_wa"]
        Y_a = sum(repeat(real_wages_after',orig_tract_length) .* realized_ell_kn_after)

    return(Y_b, Y_a)
end
total_real_income_before, total_real_income_after = total_income_loop(simulation)
total_real_income_change = total_real_income_after .- total_real_income_before
CSV.write(ARGS[2], DataFrame(:total_real_income_before => total_real_income_before, :total_real_income_after => total_real_income_after, :total_real_income_change => total_real_income_change))