# Amazon_fixednu_simulate

This exercise simulates individual's choices with fixed preference shifter and aggregates the choices 
into labor allocations before and after the Amazon HQ2 shock.

This task is computationally intensive and ought to be run on a high-performance computing cluster.
The total runtime of this task is very long (see `metadata/time.txt`), but this is a direct consequence of the scale of the simulation.
There are 100 simulations in this task, each requiring a 4.6-million-element vector from the Gumbel distribution for each of 2.5 million individuals.
To make this more feasible, the computation of one simulation is split into 50 blocks, each representing 50,000 individuals.
Each block requires about two CPU hours.
It takes less than five minutes to collect the simulated choices into labor allocation and to compute prices and changes in quantities for a given simulation.

## Folder Structure

`code/`:

* `finitemodel_simulate_choices.jl`: generates individuals' location choices before and ater the shock.
It takes argument `simulation` that indicates which DGP it is and `block` that indicates which block of 50,000 people are simulated.

* `finitemodel_collect_choices.do`: collects individuals' location choices into labor allocation.

* `finitemodel_simulation.jl`: computes changes in employment and residence and real prices for a given simulation.

* `compute_meanutil.jl`: Computes the mean utility before and after the shock for each tract-pair.

`output/`:

* `finite_labor_allocation_$(sigma)_$(simulation).csv.zip`: collects the individuals' choices for a given simulation and convert the results into commuting matrix.

* `simulation_fixednu_$(sigma)_$(simulation).jld2`: stores the real wages and rents as well as the number of residents and workers before and after the shock.

`temp/`: 

* `granular_$(sigma)_$(simulation)_$(block).csv`: stores the individuals' locational choices before and after the shock for a givenvalue of sigma. 
The first column is the individual identifier and the second and third columns are the tract-pair identifier magnifying individuals' choices.

* `amazon_ctfl_tract_cbm_%_meanutil.csv`: stores the mean utility before and after the shock for each tract-pair.
* `temp_s%.csv`: concatenates all individual's location choices from 50 blocks for a given simulation.
* `finite_labor_allocation_$(sigma)_$(simulation).csv`: labor allocation aggregated from a given simulation in CSV format.

## Input
* `primitives_nyc2010_time_sigma_$(sigma).jld2`: The calibrated primitives (land endowment, productivity, wage & rent beliefs, commuting cost matrix, and population).
* `model_cbm_sigma_$(sigma).jld2`: model parameters for the CBM.
* `finitemodel_programs.jl`: Script that draws finite labor allocation and solves for trade-equilibrium prices.
* `amazon_ctfl_tract_cbm_sigma_$(sigma)_{rent,wage,shock}.csv`: counterfactual predictions of rents, wages, and shock for the CBM. 
* `baseline_equilibrium_outcomes_%.jld2`: contains baseline equilibrium outcomes.