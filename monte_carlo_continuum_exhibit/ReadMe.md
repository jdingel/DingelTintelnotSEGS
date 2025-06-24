# monte_carlo_continuum_exhibit

This task draws the densities of regression coefficients and the histogram of CBM/CSP MSE ratios,
and summarizes the mean statistics of the coefficients and MSEs.

The input structure of this task is similar to `monte_carlo_iid_exhibit`. 
The differences include 
(a) the counterfactual predictions are from `monte_carlo_continuum_predictions` where the counterfactual shocks
are solved by matching the continuum labor allocation changes in the treated tract and 
(b) the LHS variables are continuum changes from `monte_carlo_continuum_compute`.

## Output

* `csp_slope_median_continuum_{prices,labor}_$(Lambda)_$(pop)_$(shock).tex`: median of the CSP slope in predicting rent changes or changes in labor allocations

* `slopes_intercepts_densities_continuum_{prices,labor}_$(Lambda)_$(pop)_$(shock).eps`: densities of regression coefficients in predicting rent changes or changes in labor allocations

* `mse_ratio_median_continuum_{prices,labor}_$(Lambda)_$(pop)_$(shock).tex`: median of MSE ratio (CBM MSE/CSP MSE) in predicting rent changes or changes in labor allocations

* `MSE_ratio_histogram_continuum_{prices,labor}_$(Lambda)_$(pop)_$(shock).eps`: histogram of MSE ratio in predicting rent changes

* `sumstats_continuum_{prices,labor}_$(Lambda)_$(shock).tex`: mean statistics of regression coefficients and MSEs across population size in predicting rent changes or changes in labor allocations

## Code

* `sum_{labor,prices}.do`: computes the estimated slopes, intercepts and MSEs when regressing the continuum changes 
on predicted changes across 100 simulations, population size, magnitudes of lambda and productivity shocks.

* `exhibits_{labor,prices}.do`: draws the densities of regression coefficients and the histograms of MSE ratios, 
and summarizes the mean statistics of the coefficients and MSEs.

## Inputs

* `sum_continuum_{labor,prices}_$(Lambda)_$(pop)_$(shock).dta`: 
records the estimated slopes, intercepts and MSEs when regressing the changes in labor allocation or rents
from the continuum model on the CBM/CSP predicted changes.
