# monte_carlo_iid_exhibit

This task draws the densities of regression coefficients and the histogram of CBM/CSP MSE ratios,
and summarizes the mean statistics of the coefficients and MSEs.

The input structure of this task is similar to `monte_carlo_continuum_exhibit`. 
The differences include 
(a) the counterfactual predictions are from `monte_carlo_iid_predictions` where the counterfactual shocks
are solved by matching the continuum labor allocation changes in the treated tract and 
(b) the LHS variables are realized finite-sample changes with an iid `nu` from `monte_carlo_iid_dgp`.


## Output

* `csp_slope_median_iid_labor_$(Lambda)_$(pop)_$(shock).tex`: median of the CSP slope in predicting changes in labor allocations

* `slopes_intercepts_densities_iid_labor_$(Lambda)_$(pop)_$(shock).eps`: densities of regression coefficients in predicting changes in labor allocations

* `{cbm,csp}_mse_mean_iid_labor_$(Lambda)_$(pop)_$(shock).tex`: mean MSE of CBM or CSP

* `mse_ratio_{median,sd}_iid_labor_$(Lambda)_$(pop)_$(shock).tex`: median or standard deviation of MSE ratio (CBM MSE/CSP MSE) in predicting changes in labor allocations

* `MSE_ratio_histogram_iid_labor_$(Lambda)_$(pop)_$(shock).eps`: histogram of MSE ratio in predicting rent changes

* `sumstats_iid_labor_$(Lambda)_$(shock).tex`: mean statistics of regression coefficients and MSEs across population size in predicting changes in labor allocations

## Code

* `exhibits_labor(1/2).do`: draws the densities of regression coefficients and the histograms of MSE ratios, 
and summarizes the mean statistics of the coefficients and MSEs.

* `sum_all.do`: constructs table summarizing the mean statistics of the regression slope coefficients and MSEs between CBM or CSP across different `Lambda` and `pop`.

## Inputs

* `sum_iid_labor_$(Lambda)_$(pop)_$(shock).dta`: 
records the estimated slopes, intercepts and MSEs when regressing the changes in labor allocation
from the iid model on the CBM/CSP predicted changes.