# monte_carlo_iid_analysis

This task computes the estimated slopes, intercepts and MSEs when regressing the 
changes in labor allocation from the iid model on the covariates-based model (CBM) 
or calibrated-shares procedure (CSP) predicted changes
across 100 simulations, population size, magnitudes of lambda and productivity shocks.

The input structure of this task is similar to `monte_carlo_continuum_analysis`. 
The differences include 
(a) the counterfactual predictions are from `monte_carlo_iid_predictions` where the counterfactual shocks
are solved by matching the continuum labor allocation changes in the treated tract and 
(b) the LHS variables are realized finite-sample changes with an iid `nu` from `monte_carlo_iid_dgp`.

## Output

* `sum_iid_labor_$(Lambda)_$(pop)_$(shock).dta`: 
records the estimated slopes, intercepts and MSEs when regressing the changes in labor allocation
from the iid model on the CBM/CSP predicted changes.

## Code
* `sum_labor.do` computes the estimated slopes, intercepts and MSEs when regressing the iid changes on predicted changes across 100 simulations, population size, magnitudes of lambda and productivity shocks.

## Input
* `DGP_iid_1145_treatedonly_$(Lambda)_$(pop)_$(shock)_$(event).dta`: Before and after commuting flows from the iid DGP, filtered to only include the treated tract as the destination.
* `prediction_{cbm,csp}_%_{ell,w,r,P}.csv`: stores the counterfactual predictions for changes in prices and quantities from CBM and CSP models.