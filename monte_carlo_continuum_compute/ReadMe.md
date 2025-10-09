# monte_carlo_continuum_compute

This task computes counterfactual outcomes in the continuum model for the data-generating process and productivity shock that are used in the Monte Carlo simulations.

## Output
* `DGP_continuum_$(Lambda)_$(shock)_$(event)_{ell,w,r}.csv`: the counterfactual outcomes - labor allocations (`ell`), wages (`w`), and rents (`r`) - in the continuum model.

## Code
* `continuum_outcomes.jl`: computes the counterfactual outcomes - labor allocations (`ell`), wages (`w`), and rents (`r`) - 
in the continuum model.

## Input
* `nyc2010_time_elasticity.csv`,`nyc2010_lodes_wzero_wdelta.csv`, `primitives_nyc2010_time.jld2`: baseline NYC 2010 data.