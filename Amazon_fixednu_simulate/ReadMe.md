# Amazon_fixednu_simulate

This exercise simulates individual's choices with fixed preference shifter and aggregates the choices 
into labor allocations before and after the Amazon HQ2 shock.

This task is computationally intensive and ought to be run on a high-performance computing cluster.
Computing one block of one simulation takes less than two hours. 
There are 50 blocks per simulation, so one simulation requires about 100 CPU hours.
It takes less than five minutes to collect the simulated choices into labor allocation and to compute prices and changes in quantities for a given simulation.

## Folder Structure

`code/`:

* `granular_sim_choices.jl`: generates individuals' location choices before and ater the shock.
It takes argument `simulation` that indicates which DGP it is and `block` that indicates which block of 50,000 people are simulated.

* `granular_collect_choices.do`: collects individuals' location choices into labor allocation.

* `granular_simulation.jl`: computes changes in employment and residence and real prices for a given simulation.

* `compute_meanutil.jl`: Computes the mean utility before and after the shock for each tract-pair.

`output/`:

* `granular_$(sigma)_$(simulation)_$(block).csv`: stores the individuals' locational choices before and after the shock for a givenvalue of sigma. 
The first column is the individual identifier and the second and third columns are the tract-pair identifier magnifying individuals' choices.

* `granular_labor_allocation_$(sigma)_$(simulation).csv.zip`: collects the individuals' choices for a given simulation and convert the results into commuting matrix.

* `simulation_fixednu_$(sigma)_$(simulation).jld2`: stores the real wages and rents as well as the number of residents and workers before and after the shock.

`temp/`: 

* `temp_s%.csv`: concatenates all individual's location choices from 50 blocks for a given simulation.
* `granular_labor_allocation_$(sigma)_$(simulation).csv`: labor allocation aggregated from a given simulation in CSV format.

## Input
* `primitives_nyc2010_time_sigma_$(sigma).jld2`: The calibrated primitives (land endowment, productivity, wage & rent beliefs, commuting cost matrix, and population).