# Amazon counterfactual dispersion simulation

This task computes the predictions of quantitative spatial models for the economic consequences of Amazon's aborted second headquarters in Long Island City. 
Models include the finite model, continuum model, and calibrated-shares procedure.

It is a computationally expensive task that needs to be run on the server (needs more memory than other tasks; see task-specific `run.sbatch` file).

## Output
* `simulation#.jld2`: finite-model simulation results (prices and quantities) at baseline and counterfactual. Each file contains 10,000 simulations.
* `simulation_orig(dest).csv`: mean change in quantities and prices based on 10,000 simulations and 100,000 simulations.
* `simulation_100k_distribution_(orig|dest).csv`: change in quantities and prices based on 100,000 simulations with more details, including p5, p95, mean, and sd.

## Input
* `finitemodel_programs.jl`: Script that draws finite labor allocation and solves for trade-equilibrium prices.
* `amazon_ctfl_(unit)_(model)_(variable).csv`: counterfactual results for a given model and variable. 
Variables include "ell" which are commuting flows, "rent" which are rents, "wage" which are wages, and "shock" which is the productivity shock.
* `nyc2010_time_elasticity.csv` `primitives_nyc2010_time.jld2`: baseline NYC 2010 data.
* `baseline_equilibrium_(model).jld2`: baseline equilibrium wages, rents, and commuting flows for a given model.


## Code
* `simulation.jl`: output finite-model simulation results (prices and quantities at baseline and counterfactual).
* `sum_by_simulation_count.jl`: summarize the statistics based on 10,000 simulations and 100,000 simulations.
* `simulation_100k_stats.jl`: summarize the statistics based on 100,000 simulations with more details, including p5, p95, mean, and sd.
