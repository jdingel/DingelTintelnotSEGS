# Amazon fixednu distance bins
This task takes in each of the fixed-$\nu$ simulations and aggregates the results by distance bins to the treated tract. 
## Output
* `simulation_bydistbin_fixednu_orig_sigma_$(sigma).csv`: aggregates the simulated changes in rents and residents by distance bins for a given value of sigma.
* `simulation_bydistbin_fixednu_dest_sigma_$(sigma).csv`: aggregates the simulated changes in wages and employment by distance bins for a given value of sigma.

## Input
* `amazon_ctfl_tract_cbm_sigma_$(sigma)_{wage,rent}.csv`: counterfactual predictions of wages and rents for the CBM. 
* `NYC_dist_to_treated.dta`: the distance from each tract to the nearest treated tract.
* `simulation_fixednu_$(sigma)_$(simulation).jld2`: stores the real wages and rents as well as the number of residents and workers before and after the shock.

## Code
* `aggregate_simulation_bydistbin_{dest,orig}.jl`: aggregates the simulated changes in employment and wages (if dest) or residents and rents (if orig) by distance ventiles to the treated tract.