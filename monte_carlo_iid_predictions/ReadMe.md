# monte_carlo_iid_predictions

This task applies the event-study procedure to simulated data produced in `monte_carlo_iid_dgp`.
In particular, it computes the productivity shock required to match the observed total employment change
and then predicts the employment changes for the covariates-based model and the calibrated-shares procedure.

This task is highly computationally intensive. It must be executed on a server to process 4,000 Data Generating Processes (DGPs).

## output
* The total number of output files is 16 * (5 * 8 * 100) = 64,000.
* `elasticity_%.csv`: commuting elasticity based on the DGP% simulated in `monte_carlo_iid_dgp`.
* `fe_i%.dta`, `fe_j%.dta`: stores the residence and workplace fixed effects
* `primitives%.jld2`: contains the primitives
* `{cbm,csp}_shock%.jld2`: contains the shock solved from the continuum equilibrium model
* `prediction_{cbm,csp}_%_{ell,w,r,P}.csv`: stores the counterfactual predictions for changes in prices and quantities from CBM and CSP models
* `nyc2010_lodes_wzero_wdelta_$(Λ)_$(headcount)_$(A_shock)_$(sim).dta`: contains labor allocation before and after the productivity increase,
where `$(Λ)` $= 0, 0.1, 0.25, 0.5, 1$.
`$(headcount)` $= 2.488905, 5, 12.5, 25, 50, 125, 250, 2560$.
`$(A_shock)` $= 1.09$.
`$(sim)` $= 1,2,..,100$.

## code
* `gravity_regressions.do`: computes the commuting elasticity, origin and destination fixed effects
* `ctfl%.jl`: calculates required productivity shocks that match the employment change in DGP and predicts the counterfactual employment change
* `ctfl_method_comparison.jl`: verifies the productivity shock and equilibrium quantities from the default bisection and A42 methods are almost identical

## input
* `DGP_$(Lambda)_$(pop)_$(shock)_$(event).csv`: before and after the productivity increase simulated by iid Monte Carlo.
* `DGP_continuum_%_w.csv`: the equilibrium wage in the continuum model based on iid simulated DGP%.
* `nyc2010_lodes_wzero_wdelta.csv` `primitives_nyc2010_time.jld2`: baseline NYC 2010 data.
* `calibrate_main.jl`: calibrates the primitives including commuting costs, land endowment and productivity 
