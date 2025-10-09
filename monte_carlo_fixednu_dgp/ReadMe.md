# monte_carlo_fixednu_dgp

These Monte Carlo simulations assess how well the calibrated-shares procedure for computing counterfactual outcomes performs in a granular setting. 
The "fixed" in the title reflects the assumption that the idiosyncratic logit shocks from the T1EV distribution before and after the shock are unchanged. 
The variance of the tract-pair disutility is set to be 0, $Var(\lambda) = 0$.

This task is highly computationally intensive. 
It must be executed on a server to process 100 Data Generating Processes (DGPs). 

Please parallel the task by using `make -j`.

## output
* `DGP_$(shock)_$(event)_fixednu.csv`: labor allocation collected from individuals' choices for a given DGP.

## code
* `compute_pre_and_post_mean_util.jl`: calculates the tract-level mean utility for before and after equilibria, given the parameterized model economy (the NYC 2010 baseline). It takes about 3.5 minutes to run the script.

* `simulate_choices.jl`: generates individuals' location choices before and after the shock. 
It takes three arguments: `event` that indicates which DGP it is, 
`shock` that indicates the size of the productivity increase,
and `block` that indicates which block of 50,000 people are simulated.
* `collect_chices_bysim.do`: collects individuals' location choices given a fixed simulation. 

## input
* `nyc2010_time_elasticity.csv`,`nyc2010_lodes_wzero_wdelta.csv`, `nyc2010_lodes_wzero_wdelta.dta`,`primitives_nyc2010_time.jld2`: baseline NYC 2010 data.

## temp
* `mean_util_$(shock)_fixednu.csv`: tract-pair level mean utility before and after the shock
* `choices_$(shock)_$(event)_b$(block)_fixednu.csv`: individuals' locational choices before and after the shock. 
The first column is the individual identifier and the second and third columns are the tract-pair an individual chooses.

