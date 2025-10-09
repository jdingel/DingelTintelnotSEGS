# eventstudy nyc counterfactual varying sigma comparison
    This task compares the slopes, intercepts, and MSEs of the CSP predictions for varying sigma values. 

## Output
* `$(var)_$(sigma_1)_$(sigma_1)_comparison_scatterplot.eps`: scatterplot comparing the counterfactual commuting flow predictions between CSPs of varying sigma.

## Code
* `plot_slope_int_mse_comparison.do`: plots the slope coefficients from regressions of the observed change in commuters on the predicted change in commuters for each of the 83 tract-level employment booms.

## Input
* `slope_int_MSE_all_csp_sigma_$(sigma).csv`: slopes, intercepts, and MSEs for all treatment tracts from regressing the observed changes on the CSP-predicted changes.

