# nyc baseline compute
This task computes the baseline equilibrium prices and quantities (wages, rents, commuting flows) for all covariates-based models (including the IFE extension).
*Warning*: Parallelization may cause errors, so we disable the use of `make -j` with `.NOTPARALLEL`.

## Output
* `baseline_equilibrium_outcomes_`type`.jld2`: Contains baseline equilibrium outcomes. 
Note that `baseline_equilibrium_outcomes_sigma_4.0.jld2` is our baseline CBM. 

## Code
* `baseline_equilibrium_solver.jl`: Contains a solver that computes the equilibrium prices and quantities for multiple specifications (CBM with varying $\sigma$, nested logit, pooled data, NTA, local increasing returns, and IFE). This code is used by several downstream tasks including `Amazon_puncertainty_compute`, `monte_carlo_continuum_compute`, `monte_carlo_(continuum|iid|fixednu)_predictions`, etc.
* `baseline_compute_%.jl`:
This takes in a commuting elasticity $\epsilon$, productivity $A$, land endowment $T$, and $\bar{\delta}$
and computes the baseline equilibrium outcomes.

## Input
* `primitives_nyc2010_(time|dist).jld2`: The calibrated primitives (land endowment, productivity, wage & rent beliefs, time/distance-predicted commuting cost matrix, and population) for the 2010 baseline data.
