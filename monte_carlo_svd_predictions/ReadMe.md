# monte carlo svd predictions

This task applies the event-study procedure to simulated data produced and approximated in `monte_carlo_iid_dgp` and
`monte_carlo_SVD_approx`, respectively. 
It computes the productivity shock required to match the observed total employment change and then predicts the 
employment changes for the calibrated-shares procedure, starting from the appropriate SVD-approximated 
baseline commuting shares.

This task is highly computationally intensive. 
It must be executed on a server to process 2,100 specifications (100 DGPs $\times$ 21 NNMF approximations).


## output
* `prediction_svd_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank)_ell.csv`: the counterfactual predictions for employment changes 
from applying the exact hat algebra to the SVD-approximated baseline commuting shares

## code
* `ctfl_svd.jl`: calculates the required productivity shock that match the employment boom in DGP and 
predicts the counterfactual employment change using exact hat algebra.
Compare to `ctfl_csp.jl` from the task `monte_carlo_continuum_predictions`.

## input 
* `DGP_approx_$(Lambda)_$(pop)_$(shock)_$(event)_(rank).csv.zip`: approximated labor allocation 
* `elasticity_%.csv`: commuting elasticity based on the DGP% simulated in `monte_carlo_iid_dgp`.
* `fe_i%.dta`, `fe_j%.dta`: residence and workplace fixed effects.
* `nyc2010_time_elasticity.csv`,`nyc2010_lodes_wzero_wdelta.csv`: baseline NYC 2010 data.