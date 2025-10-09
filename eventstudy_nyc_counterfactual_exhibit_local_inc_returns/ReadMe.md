# eventstudy_nyc_counterfactual_exhibit_local_inc_returns
This task compares the slopes, intercepts, and mean squared errors (MSEs) from regressions of the 
observed change in commuters on the CSP predicted change in commuters for different values of eta. 
The results are visualized with scatterplots.

## Output
* `$(stat)_eta_(value)_comparison_scatterplot.eps`: a comparison of regression statistics for each of the 83 tract-level employment booms with a given value of eta.
* `slope_eta_(value)_comparison_regression.txt`: regression tables corresponding to the scatterplots.

## Code
* `plot_slope_int_mse_comparison_csp.do`: plots the slope, intercept, and MSE from regressions on the CSP predictions.

## Input
* `slope_int_MSE_all_(model).csv`: The slope, intercept, MSE, and tract ID for all tracts using the predictions of the model.
