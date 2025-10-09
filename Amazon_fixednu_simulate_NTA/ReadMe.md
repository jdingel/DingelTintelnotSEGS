# Amazon_fixednu_simulate_NTA

This task investigates the uncertainty induced by individual idiosyncrasies for the Neighborhood Tabulation Areas (NTAs) specification.

Specifically, this task performs two tasks:
(i) simulates individuals' choices over NTA-pairs for the Amazon counterfactual 
(ii) aggregates individuals' choices into labor allocations and computes the prices.

This task is computationally intensive and ought to be run on a high-performance computing cluster.

## code:
* `finitemodel_simulate_choices_NTA.jl`: generates 2.488 million individuals' location choices before and after the shock.
* `finitemodel_collect_choices_NTA.do`: collects individuals' location choices into labor allocation.
* `finitemodel_simulation_NTA.jl`: computes changes in employment and residence and real prices for a given simulation.


## output:
* `finite_labor_allocation_NTA_s$(simulation).csv.zip`: collects the individuals' choices for a given simulation 

* `simulation_fixednu_NTA_s$(simulation).jld2`: stores the real wages and rents as well as the number of residents and workers before and after the shock.

## temp: 
* `granular_NTA_s$(simulation).csv`: stores the individuals' locational choices before and after the shock. 
The first column is the individual identifier and the second and third columns are the tract-pair identifier magnifying individuals' choices. 
* `amazon_ctfl_cbm_nta_meanutil.csv`: stores the mean utility before and after the shock for each NTA-pair.
* `finite_labor_allocation_s$(simulation).csv`: labor allocation aggregated from a given simulation in CSV format.

## input:
* `model_cbm_nta.jld2`: model parameters for the CBM with the NTA specification.
* `compute_meanutil.jl`: computes the mean utility before and after the shock for each NTA-pair.
* `finitemodel_programs.jl`: Script that draws finite labor allocation and solves for trade-equilibrium prices.
* `shock_tract.jl`: defines a function that applies a productivity shock to a single tract. Given a productivity vector $A$, it returns a new vector $\hat{A}$ in which only the specified treatment tract’s productivity is scaled by a given factor.
* `nyc_NTA_2010_time_elasticity.csv`: time elasticity implied by gravity model.
* `primitives_nyc_NTA_2010_time.jld2`: stores the economic primitives of the NTA specification.
* `baseline_equilibrium_outcomes_nta.jld2`: contains baseline equilibrium outcomes for the NTA specification.
* `amazon_ctfl_cbm_nta_$(sigma)_{ell,rent,wage,shock}.csv`: counterfactual predictions of commuting flows, rents, wages, and shock for the CBM. 
