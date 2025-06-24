# Amazon p-uncertainty compute
This task computes the CBM's counterfactual predictions for each of the 100 parameter uncertainty variations of the baseline commuting shares matrix. 

## Output
* `cont_(var)_puncertainty_#.csv`: The AHQ2 counterfactual predictions for the parameter uncertainty scenario #. 
This output contains results for employment, rents, wages, and residents.

## Code
* `compute_cont_counterfactual.jl`: This script takes in the baseline data and calibrates the primitives. It then saves the calibrated primitives as a jld file.

## Input
* `nyc2010_dest_time_puncertainty_#.dta`: Destination tract fixed effects for commuting flows with google maps times as bilateral covariate
* `nyc2010_orig_time_puncertainty_#.dta`: Origin tract fixed effects for commuting flows with google maps times as bilateral covariate
* `nyc2010_time_elasticity_puncertainty_#.csv`: The commuting time elasticity in preperiod
* `nyc2010_lodes_wzeros_wdelta_puncertainty_#.dta`: LODES data nyc in 2010 with zero commuting flows and commuting costs.
* `primitives_nyc2010_time_puncertainty_#.jld2`: The calibrated primitives (land endowment, productivity, wage & rent beliefs, commuting cost matrix, and population) for the parameter uncertainty baseline scenario #.