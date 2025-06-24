# Amazon counterfactual compute prob

This task computes the commuting flow probabilities of a given model.
## Output
* `amazon_ctfl_(unit)_(model)_prob.csv`: counterfactual flow probabilities for a given model.
## Input
* `model_(model).jld2`: model parameters for a given model.
* `primitives_nyc2010_time.jld2`: primitives for the CBM.
* `amazon_ctfl_(unit)_(model)_(variable).csv`: counterfactual results for a given model and variable. 
Variables include "ell" which are commuting flows, "rent" which are rents, "wage" which are wages, and "shock" which is the productivity shock.
* `granular_programs.jl`: probability computational function for the CBM.
## Code
* `amazon_ctfl_compute_granular_prob.jl`: Uses the baseline and counterfactual equilibrium objects (wages, rents, and commuting flows) and computes a probability matrix of an individual i choosing to commute from tract k to tract n. 