# Amazon p-uncertainty calibrate
This task develops the calibrated primitives for each of the 100 parameter uncertainty variations of the baseline commuting shares matrix.

## Output
* `primitives_nyc2010_time_puncertainty_#.jld2`: The calibrated primitives (land endowment, productivity, wage & rent beliefs, commuting cost matrix, and population) for parameter uncertainty baseline scenario #.

## Input
* `nyc2010_dest_time_puncertainty_#.dta`: Destination tract fixed effects for commuting flows with google maps times as bilateral covariate
* `nyc2010_orig_time_puncertainty_#.dta`: Origin tract fixed effects for commuting flows with google maps times as bilateral covariate
* `nyc2010_time_elasticity_puncertainty_#.csv`: The commuting time elasticity in preperiod
* `nyc2010_lodes_wzero_wdelta_puncertainty_#.dta`: LODES data on 2010 commuting patterns in NYC with zero commuting flows and commuting costs.
* `calibrate_main.jl`: This script takes in the baseline data and calibrates the primitives using `calibrate_function.jl`. 
It then saves the calibrated primitives as a jld2 file.
* `calibrate_function.jl`: This script defines a function that solves $A$ and $T$ given origin and destination fixed effects.
