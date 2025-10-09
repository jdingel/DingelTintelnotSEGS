********************************************************************************
* This script saves estimated slopes, intercepts and MSEs 
* when regressing the changes in prices, rents specifically,
* from the continuum model on the CBM/CSP predicted changes
* across 100 simulations, population sizes and magnitudes of lambda
********************************************************************************

clear all

// Check arguments are valid
assert inlist(`1',0,0.1,0.25,0.5,1) // Magnitude of disutility (Lambda)
assert inlist(`2',2.488905,5,12.5,25,50,125,250,2560) // Population size
assert `3' == 1.09 // Size of productivity shocks

// Create dataframe that stores statistics from each regression
set obs 100
gen slope_cbm = .
gen slope_csp = .
gen intercept_cbm = .
gen intercept_csp = .
gen mse_cbm = .
gen mse_csp = .
tempfile df
save `df'

foreach idx of numlist 1/100{

/* 	For testing purpose */
/* 	local 1 = 0
	local 2 = 5
	local idx = 1  */
*/
	// Import continuum rents
	if `1' == 0{
		import delimited "../input/DGP_continuum_`1'_1.09_1_r.csv", clear
	}
	else{
		import delimited "../input/DGP_continuum_`1'_1.09_`idx'_r.csv", clear
	}
	
	// Generate hat changes in real rents
	rename hat_realr hat_realr_cont
	tempfile df_cont
	save `df_cont', replace

	// Import CBM-predicted labor allocations
	import delimited "../input/prediction_cbm_`1'_`2'_`3'_`idx'_r.csv", clear
	rename hat_realr hat_realr_cbm
	tempfile df_cbm
	save `df_cbm', replace

	// Import CSP-predicted labor allocation
	import delimited "../input/prediction_csp_`1'_`2'_`3'_`idx'_r.csv", clear
	rename hat_realr hat_realr_csp

	// Model predictions have the same number of observations (2159 or 2160)
	merge 1:1 i using `df_cbm', assert(match) keepusing(hat_realr_cbm) nogen
	// Continuum rents have 2160 observations
	merge 1:1 i using `df_cont', assert(using match) keepusing(hat_realr_cont) nogen

	// Run regressions and get summary statistics
	reg hat_realr_cont hat_realr_cbm
	local slope_cbm = _b[hat_realr_cbm]
	local intercept_cbm = _b[_cons]
	egen MSE_cbm = mean((hat_realr_cont - hat_realr_cbm)^2)
	local mse_cbm = MSE_cbm[1]

	reg hat_realr_cont hat_realr_csp
	local slope_csp = _b[hat_realr_csp]
	local intercept_csp = _b[_cons]
	egen MSE_csp = mean((hat_realr_cont - hat_realr_csp)^2)
	local mse_csp = MSE_csp[1]

	// Save sum stats into dataframe
	use `df',clear
	replace slope_cbm = `slope_cbm' if _n==`idx'
	replace slope_csp = `slope_csp' if _n==`idx'
	replace intercept_cbm = `intercept_cbm' if _n==`idx'
	replace intercept_csp = `intercept_csp' if _n==`idx'
	replace mse_cbm = `mse_cbm' if _n==`idx'
	replace mse_csp = `mse_csp' if _n==`idx'
	tempfile df
	save `df'

}

// Output lambda-population-specific summary statistics 
save "../output/sum_continuum_prices_`1'_`2'_`3'.dta", replace