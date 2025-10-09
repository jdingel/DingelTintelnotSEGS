********************************************************************************
* This script takes estimated slopes and intercepts, and MSEs 
* from the regression where the continuum model is the truth, 
* fixed \lambda=0 and across 100 simulations.
* It draws the densities of regression coefficients and the histogram of CBM MSE/CSP MSE.
* It only handles results for pop = 2.488905
********************************************************************************
clear all
set scheme s2color
graph set window fontface "Times"
graph set print fontface "Times"

// Check arguments are valid
assert inlist(`1',0,0.1,0.25,0.5,1) // Magnitude of random effect (Lambda)
assert inlist(`3',1.09,1.18) // Size of productivity shocks

// Create dataset that combines sum stats across population size
local popu = 2.488905
use "../input/sum_continuum_prices_`1'_`popu'_`3'.dta", clear
gen pop = `popu'

// Report summary statistics for slopes, intercepts and MSE ratio
quietly summarize slope_csp, detail 
local slope_csp_median = string(`r(p50)', "%3.2f")
quietly summarize intercept_csp, detail
local intercept_csp_median = string(`r(p50)', "%3.2f")
// Output median slope only that allows separate description
shell echo -n `slope_csp_median' > "../output/csp_slope_median_continuum_prices_`1'_`popu'_`3'.tex"
shell echo -n `intercept_csp_median' > "../output/csp_intercept_median_continuum_prices_`1'_`popu'_`3'.tex"

// Plot density of slope and intercept
twoway (kdensity slope_cbm, lcol(blue) yaxis(1)) (kdensity intercept_cbm, lcol(blue) lpattern(dash) yaxis(1)) ///
       (kdensity slope_csp, lcol(red) yaxis(2)) (kdensity intercept_csp, lcol(red) lpattern(dash) yaxis(2)) ///
       , graphregion(color(white)) ///
       legend(region(lstyle(none)) ///
       		label(1 "Covariates-based: slope") ///
       		label(2 "Covariates-based: intercept") ///
       		label(3 "Calibrated-shares: slope") ///
       		label(4 "Calibrated-shares: intercept")) ///
       ytitle("Density") xtitle("")
graph export "../output/slopes_intercepts_densities_continuum_prices.eps", replace fontface("Times")
// graph export is not compatible with decimal numbers in filenames
shell mv "../output/slopes_intercepts_densities_continuum_prices.eps" ///
	"../output/slopes_intercepts_densities_continuum_prices_`1'_`popu'_`3'.eps"

gen ratio_MSE = mse_cbm / mse_csp
quietly summarize ratio_MSE, detail
local MSE_median_percent = string(100*`r(p50)', "%4.3f") // Round to first significant figure
shell echo -n `MSE_median_percent' > "../output/mse_ratio_median_continuum_prices_`1'_`popu'_`3'.tex"

// Plot histogram of MSE ratio
sum ratio_MSE, detail 
local ratio_MSE_start = floor(`r(min)' * 10) / 10
local ratio_MSE_max = `r(max)'

if `ratio_MSE_max' < 0.0015 {
    local hist_width = 0.000025 
    local bin_counts = 12
} 
else {
    local hist_width = 0.0002
    local bin_counts = 6
}

twoway (hist ratio_MSE, lcolor(black) fcolor(none) start(`ratio_MSE_start') width(`hist_width') fraction), ///
	graphregion(color(white)) xtitle("Covariates-based MSE / Calibrated-shares MSE") ///
	xlabel(#`bin_counts') legend(off)
graph export "../output/MSE_ratio_histogram_continuum_prices_`1'_`popu'_`3'.eps", replace as(eps) fontface("Times")
	
