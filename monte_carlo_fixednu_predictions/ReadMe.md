# monte_carlo_fixednu_prediction

This task applies the event-study procedure to simulated data produced in `monte_carlo_fixednu_dgp`.
It computes the productivity shock required to match the observed total employment change and 
then predicts the employment changes for the covariates-based model and the calibrated-shares procedure.

It is a very computationally expensive task that needs to be run on the server.

## output
* `prediction_{cbm,csp}_$(shock)_$(event)_treated_ell_change_fixednu.csv`: changes in commuting flows in the treated tract pair $\Delta \ell_{kn*}$

## code
* `gravity_regression_fixednu.do`: computes the commuting elasticity, origin and destination fixed effects
* `ctfl_%_fixednu.jl`: calculates the required productivity shock that match the employment boom in DGP and predicts the counterfactual employment change

## input
* `DGP_continuum_%.csv`: the counterfactual outcomes in the continuum model.
* `DGP_%_fixednu.csv`: the labor allocation collected from individuals' choices for a given DGP.
* `nyc2010_time_elasticity.csv`,`nyc2010_lodes_wzero_wdelta.csv`, `nyc2010_lodes_wzero_wdelta.dta`,`primitives_nyc2010_time.jld2`: baseline NYC 2010 data.
* `calibrate_main.jl`: calibrates the primitives including commuting costs, land endowment and productivity 
