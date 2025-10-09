# Jensen Gap Simulate
    This task simulates 100,000 baseline equilibria from the model with a finite number of individuals to evaluate how the gap between the average finite-model equilibrium price and the continuum-model price varies with sigma.
## Output
* `jensen_simulation_sigma_$(sigma)_simulation_$(sim).jld2`: The output of the sim-th round of 1,000 simulations for a given sigma.
Contains 1,000 vectors of wages, rents, residents, and employments.

## Code
* `jensen_simulation.jl`: Produces 1,000 baseline simulations from the finite model for a given value of sigma. 

## Input
* `finitemodel_programs.jl`: Script that draws finite labor allocation and solves for trade-equilibrium prices.
* `nyc2010_time_elasticity.csv`: The commuting time elasticity in 2010
* `primitives_nyc2010_time_sigma_$(sigma).jld2`: Productivities, landendowments, population, wage and rent beliefs, and commuting costs for a model with a sigma value of $(sigma).
* `baseline_equilibrium_outcomes_sigma_$(sigma).jld2`: Baseline equilibrium outcomes. 
