# Amazon counterfactual compute prob

This task computes the commuting flow probabilities of a covariates-based model with sigma = 4 or infinity.
## Output
* `amazon_ctfl_tract_cbm_sigma_%_prob.csv`: counterfactual flow probabilities for the CBM.
## Input
* `model_cbm_%.jld2`: model parameters for the CBM.
* `baseline_equilibrium_outcomes_sigma_%.jld2`: baseline equilibrium outcomes for the CBM.
* `primitives_nyc2010_time_sigma_%.jld2`: primitives for the CBM.
* `amazon_ctfl_tract_cbm_sigma_%_(variable).csv`: counterfactual results for the CBM and a given variable. 
Variables include "rent" which are rents, "wage" which are wages, and "shock" which is the productivity shock.
* `finitemodel_programs.jl`: Script that draws finite labor allocation and solves for trade-equilibrium prices.
## Code
* `amazon_ctfl_compute_cbm_prob.jl`: Uses the baseline and counterfactual equilibrium objects (wages, rents, and commuting flows) and computes the labor-allocation matrix probabilities at baseline and in counterfactual.
