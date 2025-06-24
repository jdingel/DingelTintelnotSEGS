# monte_carlo_continuum_predictions

This task applies the covariates-based model (CBM) and the calibrated-shares procedure (CSP) to initial cross-section labor allocation produced in `monte_carlo_iid_dgp`.
It computes the productivity shocks that match the employment change in the treated tract from the *continuum model*.
It then computes the counterfactual predictions for quantities and prices. 

According to the approximation in logbook A.37 (20211019 JD) that \hat{L} = \hat{A}^{2},
the 9% increase in productivity leads to a roughly 18% increase in employment.

The task is very similar to `monte_carlo_iid_predictions`, where the counterfactual shocks are solved by matching the 
simulation-specific changes from the *iid finite draws*.

Running each CBM script takes approximately 2 minutes, while each CSP script requires around 5 minutes. 
Due to its high computational requirements, this task needs to be run on the server.

## output
* `{cbm,csp}_shock%.jld2`: contains the shock solved from CBM or CSP
* `predictions_{cbm,csp}_%_{ell,w,r,P}.csv`: stores the counterfactual predictions for changes in prices and quantities from CBM or CSP.

## code
* `ctfl_{cbm,csp}.jl`: calculates required productivity shocks that match the employment change in continuum outcomes and predicts the counterfactual employment change. 
`cbm` refers to the covariates-based model and `csp` refers to the calibrated-shares procedure. 

## input
* `DGP_%.csv`: the initial cross-section labor allocation from `monte_carlo_iid_dgp`. 