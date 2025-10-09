clear all

set scheme s2color

assert inlist(`1', 1.09) // Magnitude of productivity shock

// Import DTA file that contain regression coefficients and MSEs
use "../temp/sum_labor_`1'_fixednu.dta", clear

// Report summary statistics for slopes, intercepts and MSE ratio
quietly summarize slope_csp, detail 
local slope_csp_median = string(`r(p50)', "%3.2f")
quietly summarize intercept_csp, detail
local intercept_csp_median = string(`r(p50)', "%3.2f")
// Output median slope only that allows separate description
shell echo -n `slope_csp_median' > "../output/csp_slope_median_fixednu_labor_`1'_fixednu.tex"
shell echo -n `intercept_csp_median' > "../output/csp_intercept_median_fixednu_labor_`1'_fixednu.tex"

quietly summarize mse_cbm, detail
local cbm_mse_mean = string(`r(mean)', "%4.2f") 
shell echo -n `cbm_mse_mean' > "../output/cbm_mse_mean_fixednu_labor_`1'_fixednu.tex"
quietly summarize mse_csp, detail
local csp_mse_mean = string(`r(mean)', "%4.2f")
shell echo -n `csp_mse_mean' > "../output/csp_mse_mean_fixednu_labor_`1'_fixednu.tex"


gen ratio_MSE = mse_cbm / mse_csp
quietly sum ratio_MSE, detail 
local mse_ratio_median = string(100*`r(p50)', "%3.0f") //Round to integer percentage
shell echo -n `mse_ratio_median' > "../output/mse_ratio_median_fixednu_labor_`1'_fixednu.tex"
local mse_ratio_sd = string(`r(sd)', "%4.2f")
shell echo -n `mse_ratio_sd' > "../output/mse_ratio_sd_fixednu_labor_`1'_fixednu.tex"
local ratio_MSE_start = floor(`r(min)' * 10) / 10
twoway (hist ratio_MSE, /// 
	lcolor(black) fcolor(none) start(`ratio_MSE_start') width(0.025) fraction), ///
	graphregion(color(white)) ///
	xtitle("Covariates-based MSE / Calibrated-shares MSE") xlabel(#6) legend(off)
graph export "../output/montecarlo_MSE_ratio_histogram_fixednu.eps", replace
shell mv "../output/montecarlo_MSE_ratio_histogram_fixednu.eps" ///
	"../output/montecarlo_MSE_ratio_histogram_`1'_fixednu.eps"

// plot density of slope and intercept
twoway (kdensity slope_cbm, lcol(blue) yaxis(1)) (kdensity intercept_cbm, lcol(blue) lpattern(dash) yaxis(2)) ///
       (kdensity slope_csp, lcol(red) yaxis(1)) (kdensity intercept_csp, lcol(red) lpattern(dash) yaxis(2)) ///
       , graphregion(color(white)) ///
       legend(region(lstyle(none)) ///
       		label(1 "Covariates-based: slope") ///
       		label(3 "Covariates-based: intercept") ///
       		label(2 "Calibrated-shares: slope") ///
       		label(4 "Calibrated-shares: intercept")) ///
       ytitle("Density") xtitle("")
graph export "../output/montecarlo_slopes_intercepts_densities_fixednu.eps", replace
shell mv "../output/montecarlo_slopes_intercepts_densities_fixednu.eps" ///
	"../output/montecarlo_slopes_intercepts_densities_`1'_fixednu.eps"

// Collapse to get summary statistics 
collapse (mean) mean_slope_cbm=slope_cbm mean_slope_csp=slope_csp ///
	mean_intercept_cbm=intercept_cbm mean_intercept_csp=intercept_csp ///
	mean_mse_cbm=mse_cbm mean_mse_csp=mse_csp ///
	(median) median_slope_cbm=slope_cbm median_slope_csp=slope_csp ///
	median_intercept_cbm=intercept_cbm median_intercept_csp=intercept_csp ///
	median_mse_cbm=mse_cbm median_mse_csp=mse_csp ///
	(min) min_slope_cbm=slope_cbm min_slope_csp=slope_csp ///
        min_intercept_cbm=intercept_cbm min_intercept_csp=intercept_csp ///
        min_mse_cbm=mse_cbm min_mse_csp=mse_csp ///
        (max) max_slope_cbm=slope_cbm max_slope_csp=slope_csp ///
        max_intercept_cbm=intercept_cbm max_intercept_csp=intercept_csp ///
        max_mse_cbm=mse_cbm max_mse_csp=mse_csp ///
        (sd) sd_slope_cbm=slope_cbm sd_slope_csp=slope_csp ///
        sd_intercept_cbm=intercept_cbm sd_intercept_csp=intercept_csp ///
        sd_mse_cbm=mse_cbm sd_mse_csp=mse_csp

// Output tables
// CSP slope and intercept: mean
mkmat mean_slope_csp mean_intercept_csp, matrix(csp_mean)
mat csp_mean = csp_mean'

frmttable using "../output/monte_carlo_csp_mean_`1'_fixednu.tex", replace statmat(csp_mean) ///
	ctitle("\textit{I}" "2.5") ///
	rtitle( "slope" \ "intercept") ///
	note("This table reports the mean value of the slope and intercept from 100 simulations as we set $ I  = 2,488,905 $, which is the number of individuals who reside and work in New York City in the 2010 LODES data.") ///
	sd(2) tex frag nocenter  

// CSP slope: mean, median, min, max, std dev
mkmat mean_slope_csp median_slope_csp min_slope_csp max_slope_csp sd_slope_csp ///
	, matrix(csp_slope_stats)
mkmat mean_intercept_csp median_intercept_csp min_intercept_csp max_intercept_csp sd_intercept_csp ///
	, matrix(csp_intercept_stats)
mat csp_stats = csp_slope_stats', csp_intercept_stats'

frmttable using "../output/monte_carlo_csp_stats_`1'_fixednu.tex", replace statmat(csp_stats) ///
	ctitle("Statistics" "Slope" "Intercept") ///
	rtitle( "Mean" \ "Median" \ "Min" \ "Max" \ "Std dev") ///
	note("This table reports the summary statistics of the slope from 100 simulations as we set $ I = 2,488,905 $, which is the number of individuals who reside and work in New York City in the 2010 LODES data.") ///
	sd(2) tex frag nocenter 
