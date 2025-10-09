clear all
local imgfmt = "eps"

import delimited using "../input/slope_int_MSE_all_cbm_sigma_4.0.csv", clear
qui summarize slope, d
local tot_event_cbm = `r(N)'
local cbm_mean_slope = string(`r(mean)',"%4.2f")
local cbm_median_slope = string(`r(p50)',"%4.2f")
file open meanslope using ../output/predictions_slope_mean.txt, write replace
file write meanslope "The average slope across the `tot_event_cbm' events is `cbm_mean_slope'."
file close meanslope
qui summarize intercept, d
local cbm_mean_incpt = string(`r(mean)',"%4.2f")
local cbm_median_incpt = string(`r(p50)',"%4.2f")
file open intercepts using "../output/predictions_intercept_mean.txt", write replace
file write intercepts "`cbm_mean_incpt'."
file close intercepts

import delimited using "../input/slope_int_MSE_all_csp_sigma_4.0.csv", clear
qui summarize slope, d
local tot_event_csp = `r(N)'
local csp_mean_slope = string(`r(mean)',"%4.2f")
local csp_median_slope = string(`r(p50)',"%4.2f")
assert (`tot_event_csp'==`tot_event_cbm') // both sets of predictions should be for the same events
count if slope<0
assert(`r(N)'>`tot_event_csp'/2)
file open negativeslopes using "../output/text_CSP_negativeslope.tex", write replace
file write negativeslopes "the counterfactual predictions from the calibrated-shares procedure are \textit{negatively} correlated with the observed changes in commuting in more than half of the `tot_event_csp' events.%"
file close negativeslopes
qui summarize intercept, d
local csp_mean_incpt = string(`r(mean)',"%4.2f")
local csp_median_incpt = string(`r(p50)',"%4.2f")

import delimited using "../input/slope_int_MSE_all_cbm_pool_2008_2010.csv", clear
qui summarize slope, d
local tot_event_cbm_pool = `r(N)'
local cbm_pool_mean_slope = string(`r(mean)',"%4.2f")
local cbm_pool_median_slope = string(`r(p50)',"%4.2f")
qui summarize intercept, d
local cbm_pool_mean_incpt = string(`r(mean)',"%4.2f")
local cbm_pool_median_incpt = string(`r(p50)',"%4.2f")

import delimited using "../input/slope_int_MSE_all_csp_pool_2008_2010.csv", clear
qui summarize slope, d
local tot_event_csp_pool = `r(N)'
local csp_pool_mean_slope = string(`r(mean)',"%4.2f")
local csp_pool_median_slope = string(`r(p50)',"%4.2f")
local total_count_csp_pool = `r(N)'
qui summarize intercept, d
local csp_pool_mean_incpt = string(`r(mean)',"%4.2f")
local csp_pool_median_incpt = string(`r(p50)',"%4.2f")
count if slope>0
loc csp_pool_pos_frac = `r(N)' / `total_count_csp_pool'*100
local csp_pool_pos_frac_string = string(`csp_pool_pos_frac',"%4.0f")
file open positiveslopes using "../output/text_csp_pool_2008_2010_pos_frac.tex", write replace
file write positiveslopes "Its predictions are now positively correlated with observed outcomes for `csp_pool_pos_frac_string'\% of the events.%"
file close positiveslopes
assert (`tot_event_csp_pool'==`tot_event_cbm_pool') // both sets of predictions should be for the same events
file open medians using "../output/predictions_contrast_slopes_intercepts.tex", write replace
file write medians "For our covariates-based model, the slope coefficients are roughly centered on one (median of `cbm_median_slope') and the intercept coefficients are roughly centered on zero (median of `cbm_median_incpt')." _n ///
"The calibrated-shares procedure does not perform as well." _n ///
"Across the `tot_event_csp' events, the median slope coefficient is `csp_median_slope' and the median intercept coefficient is `csp_median_incpt'."
file close medians

file open median_cbm_coefs using "../output/cbm_events_median_coefficients.tex", write replace
file write median_cbm_coefs "For our covariates-based model, the slope coefficients are roughly centered on one (median of `cbm_median_slope'), and the intercept coefficients are roughly centered on zero (median of `cbm_median_incpt')."
file close median_cbm_coefs

file open median_csp_coefs using "../output/csp_events_median_coefficients.tex", write replace
file write median_csp_coefs "Across the `tot_event_csp' events, the median slope coefficient is `csp_median_slope', and the median intercept coefficient is `csp_median_incpt'."
file close median_csp_coefs

file open medians_pool using "../output/predictions_contrast_slopes_intercepts_pool.tex", write replace
file write medians_pool "The covariates-based approach's slope coefficients are closer to one (median of `cbm_pool_median_slope' vs. `csp_pool_median_slope'), and its intercept coefficients are closer to zero (`cbm_pool_median_incpt' vs. `csp_pool_median_incpt')."
file close medians_pool

