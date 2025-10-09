# monte_carlo_svd_analysis

This task computes the estimated slopes, intercepts and MSEs when regressing the 
changes in labor allocation or rents from the continuum model on the predicted changes from
the SVD-approximated model across 100 simulations and varying approximation rank.

The input structure of this task is similar to `monte_carlo_continuum_analysis`.
The differences include 
(a) the counterfactual predictions are from `monte_carlo_continuum_predictions` where the counterfactual shocks
are solved by matching the continuum labor allocation changes in the treated tract and 
(b) the LHS variables are continuum changes from `monte_carlo_continuum_compute`.

## Output

* `sum_continuous_labor_$(Lambda)_$(pop)_$(shock)_$(rank).dta`: 
records the estimated slopes, intercepts and MSEs when regressing the changes in labor allocation
from the continuum model on the SVD predicted changes.

* `monte_carlo_svd_performance.tex`: Summary of SVD Monte Carlo and event study performance across ranks, appropriately formatted for 
inclusion in the paper.
## Code

* `sum_labor.do`: computes the estimated slopes, intercepts and MSEs when regressing the continuum changes 
on predicted changes across 100 simulations and various ranks of approximation via SVD

* `svd_table_generator.R`: Summarization script which accepts as inputs the substantial summaries of event study and
Monte Carlo results, and formats them to fill out the table skeleton.

* `monte_carlo_svd_performance_skeleton.tex`: Empty skeleton for specialized table formatting which is not feasible to 
accomplish using prebuilt table packages

## INPUT

* `predictions_svd_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank)_ell.csv`: stores the counterfactual commuting flows.
* `slope_int_MSE_all_svd_$(rank).csv`: stores the tract ID, slope, intercept, and MSE for the predicted vs actual changes of the commuting flows to the treated tracts in the eventstudy.
* `DGP_continuum_$(Lambda)_$(shock)_$(event)_{ell, w}.csv`: stores the counterfactual commuting flows (`ell`) and wages (`w`) in the continuum model.