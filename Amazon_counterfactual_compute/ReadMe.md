# Amazon counterfactual compute

This task computes the predictions of quantitative spatial models for the economic consequences of Amazon's aborted second headquarters in Long Island City using various models.
## Output
* `amazon_ctfl_tract_(model)_(variable).csv`: counterfactual results for a given model, variable, and geographic unit.
Variables include "ell" which are commuting flows, "rent" which are rents, "wage" which are wages, and "shock" which is the productivity shock.
* `amazon_ctfl_(NTA_model)_(variable).csv`: counterfactual results for a given NTA-level model, variable.
The reason for excluding the "geographic unit" signifier from the filename unlike above is that the NTA-level models typically already include the geographic unit in their name.
We only need the name difference to pipe the correct model level into the correct script.
## Input
* `model_(model).jld2`: model parameters for a given model.
* `nyc_(NTA)_2012_2010_observed_changes_tracttotract.dta`: observed changes in commuting flows between 2010 and 2012. Use just for baseline commuting flows.
* `eha_solver.jl`: equilibrium solver for the economic model.
* `employment_gap_fn.jl`: A julia function that evaluates the eha solver for a given set of parameters and returns the difference between its predicted employment increase for a single treated tract and a given employment target.
## Code
* `compute_amazon_ctfl_(nta/tract).jl`: Scripts that compute the amazon counterfactual wages, rents, commuting flows, and counterfactual productivity shock for a given geographic unit.