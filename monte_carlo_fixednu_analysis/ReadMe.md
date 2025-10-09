# monte_carlo_fixednu_analysis

This task produces descriptive statistics for the monte carlo fixed $\nu$ exercise.
It uses inputs from `monte_carlo_fixednu_dgp` and `monte_carlo_fixednu_predictions`.

## output
* `monte_carlo_cs_mean_$(shock)_fixednu.tex`, `monte_carlo_cs_slope_stats_$(shock)_fixednu.tex`: tables of the summary statistics of the slope and intercept from 100 simulations
* `montecarlo_slopes_intercepts_densities_$(shock)_fixednu.eps`: plots the slope and intercept density from the two models
* `montecarlo_MSE_ratio_histogram_$(shock)_fixednu.eps`: the plot of the ratio of MSE of CBM to the MSE of CSP
* `sumstats_montecarlo_fixednu_empchanges_$(shock).tex`, `sd_montecarlo_fixednu_emp_changes_$(shock).tex`, `hist_montecarlo_fixednu_empchanges_$(shock).eps`: 
summary statistics and histogram of employment changes in the treated tract
* `{cbm,csp}_mse_mean_fixednu_labor_1.09_fixednu.tex`: mean MSE of the CBM or CSP
* `csp_slope_median_fixednu_labor_1.09_fixednu.tex`: median slope of CSP
* `mse_ratio_{median,sd}_fixednu_labor_1.09_fixednu.tex`: median or standard deviation of the MSE ratio (CBM MSE / CSP MSE)

## code
* `exhibits_labor_fixednu.do:`: calculates the slope, intercept and MSE retrieved from regressing observed changes on the predicted values from both the covariates-based model (CBM) and calibrated-share procedure (CSP) 
* `sum_labor_fixednu.do`: summarizes mean, median, min, max and standard derivation of the slope, intercept and MSE retrieved from regressing observed changes on the predicted values
* `sum_emp_changes.do`: computes descriptive statistics (std dev, min, p10, p25, p50, p75, p90, and max) for employment in the treated tract before and after shock

## input
* `DGP_%_fixednu.csv`: Fixed-nu DGP outputs from `monte_carlo_fixednu_dgp`.
* `prediction_{cbm,csp}_%_treated_ell_change_fixednu.csv`: modeled predictions from both the covariates-based model (CBM) and calibrated-share procedure (CSP) from `monte_carlo_fixednu_predictions`.

## temp
* `sum_labor_$(shock)_fixednu.dta`: summary statistics of the slope, intercept and MSE from regressing observed changes on the predicted changes
