import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, Plots, Statistics, CSV

# Load Data
primitives_baseline = load("../input/primitives_nyc2010_time.jld2")
primitives_nests = load("../input/primitives_nyc2010_time_"*ARGS[1]*".jld2")

# Function: plot scatter plot to compare outcomes
plot_scatter = function(outcome_baseline::Array{Float64, 1}, outcome_nests::Array{Float64, 1}, outcome_name::String, output_filename::String)
    outcome_baseline = exp.(log.(outcome_baseline) .- mean(log.(outcome_baseline)))
    outcome_nests = exp.(log.(outcome_nests) .- mean(log.(outcome_nests)))
    scatter(outcome_baseline, outcome_nests, label = "")
    xmin = minimum(outcome_baseline[outcome_baseline .< Inf])
    xmax = maximum(outcome_baseline[outcome_baseline .< Inf])
    line45_grid = range(xmin, xmax, length = 20)
    plot!(line45_grid, line45_grid, color = "red", width = 1.5, label = "45 degree line")
    xlabel = outcome_name * ", standard logit"
    ylabel = outcome_name * ", nested logit"
    plot!(dpi = 150, xlabel = xlabel, ylabel = ylabel)
    savefig(output_filename)
end


# Compare wages 
filename = "../output/compare_wage_"*ARGS[1]*".png"
plot_scatter(primitives_baseline["wagebelief"], primitives_nests["wagebelief"], "Wage", filename)

# Compare rents 
filename = "../output/compare_rent_"*ARGS[1]*".png"
plot_scatter(primitives_baseline["rentbelief"], primitives_nests["rentbelief"], "Rent", filename)

# Compare productivities
filename = "../output/compare_productivity_"*ARGS[1]*".png"
plot_scatter(primitives_baseline["productivity"], primitives_nests["productivity"], "Productivity", filename)

# Compare land endowments
filename = "../output/compare_landendowment_"*ARGS[1]*".png" 
plot_scatter(primitives_baseline["landendowment"], primitives_nests["landendowment"], "Land endowment", filename)

# Correlate land endowments
correlation = cor(primitives_baseline["landendowment"], primitives_nests["landendowment"])
correlation = string(round(correlation, digits = 2))
filename = "../output/correlation_landendowment_"*ARGS[1]*".tex" 
write(filename, correlation)

# Correlate productivity
correlation = cor(primitives_baseline["productivity"], primitives_nests["productivity"])
correlation = string(round(correlation, digits = 2))
filename = "../output/correlation_productivity_"*ARGS[1]*".tex" 
write(filename, correlation)

# Save commuting elasticity
elasticity = string(round(primitives_nests["epsilon_ring"], digits = 2))
filename = "../output/commuting_elasticity_"*ARGS[1]*".tex" 
write(filename, elasticity)