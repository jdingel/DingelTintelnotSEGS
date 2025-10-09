# nyc_baseline_data_SVD

This task has two tasks.
First, it computes the transformed rank-restricted SVD approximation of the 2010 labor allocation matrix across different ranks
and reports the share of zeros in the approximated matrix.
Second, it evaluates the performance of the SVD approximations of the commuting cost matrix and commuting flows matrix.

## output
* `zero_shares_${rank}.txt`: share of zero counts in the approximated matrix
* `nyc_2010_levels_tracttotract_approx_svd_18.dta.zip`: approximated labor allocation in Stata format

## code 
* `labor_approximation.jl`: produces transformed low-rank approximation of 2010 LODES commuting matrix 
and reports the share of zeros in the approximated matrix

## temp
* `labor_b_approx_${rank}.csv`: approximated labor allocation in CSV format

## input
* `nyc2010_lodes_wzero_wdelta.dta`: commuting flows in NYC 2010, with zero commuting flows.
* `SVD_funcs.jl`: returns the SVD rank-`r` approximation of a given matrix, where `r` is exogenous rank option
* `convert_labor_b_to_dta.do`: converts approximated labor allocation matrices to dta format for approximated baseline data.