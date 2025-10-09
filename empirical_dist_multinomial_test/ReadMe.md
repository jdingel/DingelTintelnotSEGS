# empirical_dist_multinomial_test
This task constructs the empirical distribution of the test statistics based on 1000 simulations.
Each simulation (i) generates a random sample according the commuting flow distribution implied by the model and 
(ii)  computes the weighted sum of squared difference between the model’s expected value and finite-sample realizations from the same model. 
Formally, the statistic is
$ \Chi^2 = \sum_{kn}\frac{(\ell_{kn}^{\text{sim}}- \mathbb{E}[\ell_{kn}])^2}{\mathbb{E}[\ell_{kn}]}, \quad \ell_{kn}^{\text{sim}} \stackrel{\text{iid}}{\sim} \text{Multinomial}(I, \{p_{kn}\}) $

## Remarks
A. We use simulations rather than the asymptotic Chi-squared distribution to handle the problem of sparse, small, and unbalanced data. (see [Fisher Exact Test](https://en.wikipedia.org/wiki/Fisher%27s_exact_test))

B. If commuting flows in LODES are significantly different from the distribution of the statistics ($\Chi^2$ and MSE) computed using the model’s probabilities as the multinomial DGP, then we reject the model (including CBM, IFE, and SVD).

C. SVD predictions contain zeros. The task called "svd_zeros" produces a table called "svd_zeros.tex". The rank-2 SVD has 2% zeros; the rank-16 SVD has 17% zeros  (# of missing == 766,276); the rank-500 SVD has 37% zeros (# of missing == 1,704,344).

## Output
Each file includes three columns :(i) pcentile_value, (ii) pcentile, and (iii) stat_value_lodes
* `Chi2_test_statistic_dist_cbmfit.csv`: The empirical Chi2 test statistics distribution given a covariates-based model
* `Chi2_test_statistic_dist_ifefit_%.csv`: The empirical Chi2 test statistics distribution given a rank-% interactive fixed effect model
* `Chi2_test_statistic_dist_svdfit_%.csv`: The empirical Chi2 test statistics distribution given a rank-% singular value decomposition model
* `Chi2_stat_value_cbmfit.tex`: The empirical Chi2 test statistics using the commuter counts in the 2010 LODES data given a CBM
* `Chi2_stat_value_ifefit_%.tex`: The empirical Chi2 test statistics using the commuter counts in the 2010 LODES data given an IFE model
* `Chi2_stat_value_svdfit_%.tex`: The empirical Chi2 test statistics using the commuter counts in the 2010 LODES data given a CBM
* `MSE_test_statistic_dist_cbmfit.csv`: The empirical MSE test statistics distribution given a CBM
* `MSE_test_statistic_dist_ifefit_%.csv`: The empirical MSE test statistics distribution given a rank-% interactive fixed effect model
* `MSE_test_statistic_dist_svdfit_%.csv`: The empirical MSE test statistics distribution given a rank-% singular value decomposition model
* `MSE_stat_value_cbmfit.tex`: The empirical MSE test statistics using the commuter counts in the 2010 LODES data given a CBM
* `MSE_stat_value_ifefit.tex`: The empirical MSE test statistics using the commuter counts in the 2010 LODES data given an IFE model
* `MSE_stat_value_svdfit.tex`: The empirical MSE test statistics using the commuter counts in the 2010 LODES data given a CBM
*`Chi2_parametric_dist.eps`: Figures of the Chi2 test statistics distribution based on parametric bootstrap.
*`MSE_parametric_dist.eps`: Figures of the MSE test statistics distribution based on parametric bootstrap.

## Input
* `nyc2010_lodes_cbmfit.dta`: Commuting flow matrix approximated by the CBM
* `labor_b_approx_ife_%.csv.zip`: Commuting flow matrix approximated by the R% IFE
* `nyc_2010_levels_tracttotract_approx_svd_%.dta.zip`: Commuting flow matrix approximated by the R% SVD

## Temp

* `nyc2010_lodes_ifefit_%.csv`: unzipped csv file for `labor_b_approx_ife_%.csv.zip`
* `nyc2010_lodes_ifefit_%.dta`: re-formatted file for `nyc2010_lodes_ifefit_%.csv`

* `nyc_2010_levels_tracttotract_approx_svd_%.dta`: unzipped csv file for `nyc_2010_levels_tracttotract_approx_svd_.dta.zip`
* `nyc2010_lodes_svdfit_%.dta`: re-formatted file for `nyc_2010_levels_tracttotract_approx_svd_%.dta`


## Code
* `clean_ife_fitted_values.do`: This script cleans the csv formatted IFE outputs and converts into a dta format.
* `clean_svd_fitted_values.do`: This script cleans the SVD outputs to be consistent with CBM and IFE outputs.
* `empirical_dist.jl`: This script performs two separate tasks:
(i) it takes `nyc2010_lodes_cbmfit.dta` `nyc2010_lodes_ife%.dta` and `nyc2010_lodes_svd%.dta` as inputs and constructs "the distribution of multinomial test statistic based on parametric bootstrap".
(ii) it calculates the test statistic value using the LODES NYC 2010 as the observed data.
* `draw_bootstrap_based_dist_chi2.do`: This do file visualizes the parametric bootstrap-based distribution for CBM and IFE.
* `draw_bootstrap_based_dist_MSE.do`: This do file visualizes the parametric bootstrap-based distribution for SVD.
