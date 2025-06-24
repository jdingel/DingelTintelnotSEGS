# nyc baseline compute
This task computes the baseline equilibrium prices and quantities (wages, rents, commuting flows) for all covariates-based models (including the IFE extension).
This task takes approximately 20 minutes to run. 
*Warning*: Parallelization may cause errors, so we disable the use of `make -j` with `.NOTPARALLEL`.

## Output
* `baseline_equilibrium_outcomes_`type`.jld2`: Contains baseline equilibrium outcomes. 
Note that `baseline_equilibrium_outcomes_sigma_4.0.jld2` is our baseline CBM. 

## Code
* `baseline_equilibrium_solver.jl`: Contains a solver that computes the equilibrium prices and quantities for multiple specifications (CBM with varying $\sigma$, nested logit, pooled data, NTA, local increasing returns, and IFE).

* `baseline_compute_%.jl`:
This takes in a commuting elasticity $\epsilon$, productivity $A$, land endowment $T$, and $\bar{\delta}$
and computes the baseline equilibrium outcomes.

## Input
* `nyc2012_lodes_wzeros.dta`: LODES NYC 2012 data with zero commuting flows. 
* `nyc2010_lodes_wzeros_w(dist)delta.dta`: LODES NYC 2010 data with zero commuting flows and (distance-predicted) covariate.
* `nyc2010_time_elasticity(_dist).csv`: The commuting time elasticity in 2010 (estimated with distance-predicted covariate)
* `primitives_nyc2010_(time|dist).jld2`: The calibrated primitives (land endowment, productivity, wage & rent beliefs, time/distance-predicted commuting cost matrix, and population) for the 2010 baseline data.
