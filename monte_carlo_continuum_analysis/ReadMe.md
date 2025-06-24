# monte_carlo_continuum_analysis

This task computes the estimated slopes, intercepts and MSEs when regressing the 
changes in labor allocation or rents from the continuum model on the covariates-based model (CBM) 
or calibrated-shares procedure (CSP) predicted changes
across 100 simulations, population size, magnitudes of lambda and productivity shocks.

The input structure of this task is similar to `monte_carlo_iid_analysis`. 
The differences include 
(a) the counterfactual predictions are from `monte_carlo_continuum_predictions` where the counterfactual shocks
are solved by matching the continuum labor allocation changes in the treated tract and 
(b) the LHS variables are continuum changes from `monte_carlo_continuum_compute`.

## Output
* `sum_continuum_{labor,prices}_$(Lambda)_$(pop)_$(shock).dta`: 
records the estimated slopes, intercepts and MSEs when regressing the changes in labor allocation or rents
from the continuum model on the CBM/CSP predicted changes.

## Code
* `sum_{labor,prices}.do`: computes the estimated slopes, intercepts and MSEs when regressing the continuum changes 
on predicted changes across 100 simulations, population size, magnitudes of lambda and productivity shocks.

## INPUT
* `DGP_continuum_1145_treatedonly_$(Lambda)_$(pop)_$(shock)_$(event).dta`: Before and after commuting flows from the continuum DGP, filtered to only include the treated tract as the destination
* `predictions_{cont,cs}_%_{ell,w,r,P}.csv`: stores the counterfactual predictions for changes in prices and quantities from CBM and CSP models