# Amazon_fixednu_simulate_nested

This task examines the uncertainty about counterfactual changes induced by individual nested-logit (NL) idiosyncrasies.
In particular, this task
(i) simulates individual's choices with fixed NL idiosyncratic preference shocks before and after the Amazon HQ2 shock,
(ii) aggregates the choices into labor allocations,
(iii) derive equilibrium prices and quantities given the simulated labor allocations.

## Remarks
* This task is computationally intensive and ought to be run on a high-performance computing cluster.
* If we parellelize `finitemodel_collect_choices_nested.do` and `finitemodel_simulation_nested.jl` using `make -j 100`, 
it takes less than five minutes to aggregate the simulated individual choices and compute prices and changes in quantities 
for 100 simulations.
* Due to the NL structure, simulation-individual-nest specific seeds are required.

## Folder Structure

`code/`:

* `rlaptrans.r`: is a generalized function for generating random numbers from a distribution specified by its Laplace transform. 
See Ridout (2009, Statistics and Computing) for more details.
This script is taken from https://www.kent.ac.uk/smsas/personal/msr/webfiles/rlaptrans/rlaptrans.r

* `log_psd_draws.r`: generates 1 million iid random draws from a positive stable distribution (PSD) based on `rlaptrans.r` and creates an empirical cumulative distribution (stored in `log_psd_cdf_0.25.csv`). 

Note that we use inverse transform sampling and linear interpolation to generate random draws from the log(PSD) distribution.

* `finitemodel_simulate_choices_nested.jl`: generates individuals' location choices before and after the AHQ2 shock.
It takes three arguments:
(i) `zeta` = 0.25, which is the NL within-nest correlation parameter
(ii) `simulation` = 1, ..., 100, that describes the round of outer loop
(iii) `block` = 1, ..., 50_000, that describes which block of 50,000 people are simulated.

* `finitemodel_collect_choices_nested.do`: collects individuals' location choices into labor allocation.

* `finitemodel_simulation_nested.jl`: computes changes in employment and residence and real prices for a given simulation.

* `compute_meanutil_nested.jl`: computes changes in mean utility before and after the employment boom for each tract-pair in the nested model.

* `custom.sbatch`: automates slurm tasks up to 100 jobs per user account.

`output/`:

* `finite_labor_allocation_$(zeta)_$(simulation)_nested.csv.zip`: collects the individuals' choices for a given simulation and convert the results into commuting matrix.

* `simulation_fixednu_$(zeta)_$(simulation)_nested.jld2`: stores the real wages and rents as well as the number of residents and workers before and after the shock.

`temp/`:
* `granular_$(zeta)_$(simulation)_$(block)_nested.csv`: stores the individuals' locational choices before and after the shock for a given value of sigma. 
The first column is the individual identifier and the second and third columns are the tract-pair identifier magnifying individuals' choices. 
* `log_psd_cdf_0.25.csv`: empirical CDF for the log(PSD).
* `temp_s%.csv`: concatenates all individual's location choices from 50 blocks for a given simulation.
* `finite_labor_allocation_$(zeta)_$(simulation)_nested.csv`: collects the individuals' choices for a given simulation and convert the results into commuting matrix.
* `amazon_ctfl_tract_cbm_ntaorigin_$(zeta)_meanutil.jld`: stores the mean utility before and after the shock for each tract-pair in the nested model.

`input/`: 
* `finitemodel_programs.jl`: Script that draws finite labor allocation and solves for trade-equilibrium prices.
* `shock_tract.jl`: defines a function that applies a productivity shock to a single tract. Given a productivity vector $A$, it returns a new vector $\hat{A}$ in which only the specified treatment tract’s productivity is scaled by a given factor.
* `amazon_ctfl_tract_cbm_ntaorigin_$(zeta)_shock.csv`: counterfactual equilibrium outcomes of shock in the nested-logit CBM with the origin NTA as the outer nest.
* `primitives_nyc2010_time_ntaorigin_$(zeta).jld2`: stores the economic primitives for the nested-logit model.
* `baseline_equilibrium_outcomes_ntaorigin_$(zeta).jld2`: contains baseline equilibrium outcomes for the nested-logit model.
* `model_cbm_ntaorigin_$(zeta).jld2`: model parameters for the nested-logit CBM.
* `nyc2010_lodes_wzero_wdelta.dta`: LODES NYC 2010 data with zero commuting flows and commuting costs.
