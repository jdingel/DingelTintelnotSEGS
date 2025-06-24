********************************************************************************
* This script saves estimated slopes, intercepts and MSEs 
* when regressing the changes in labor allocation
* from the continuum DGP on the CBM/CSP predicted changes
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

/*	For testing purpose
	local 1 = 0
	local 2 = 2.488905
	local 3 = 1.09
	local idx = 35
	di `idx'  */
	// Import continuum labor allocations

	if `1' == 0{
		use "../input/DGP_continuum_1145_treatedonly_`1'_1.09_1.dta", clear
	}
	else{
		use "../input/DGP_continuum_1145_treatedonly_`1'_1.09_`idx'.dta", clear
	}
	tempfile df_continuum
	save `df_continuum', replace

	// Import CBM-predicted labor allocations
	import delimited "../input/prediction_cbm_`1'_`2'_`3'_`idx'_ell.csv", clear
	gen d_ell_cbm = x_ij_after - x_ij_before
	tempfile df_cbm
	save `df_cbm', replace

	// Import CSP-predicted labor allocation
	import delimited "../input/prediction_csp_`1'_`2'_`3'_`idx'_ell.csv", clear
	gen d_ell_csp = x_ij_after - x_ij_before

	merge 1:1 id_i using `df_cbm', assert(match) keepusing(d_ell_cbm) nogen
	merge 1:1 id_i using `df_continuum', assert(match using) keepusing(d_ell_dgp) nogen

	// Run regressions and get summary statistics
	reg d_ell_dgp d_ell_cbm
	local slope_cbm = _b[d_ell_cbm]
	local intercept_cbm = _b[_cons]
	egen MSE_cbm = mean((d_ell_dgp - d_ell_cbm)^2)
	local mse_cbm = MSE_cbm[1]

	reg d_ell_dgp d_ell_csp
	local slope_csp = _b[d_ell_csp]
	local intercept_csp = _b[_cons]
	egen MSE_csp = mean((d_ell_dgp - d_ell_csp)^2)
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
save_data "../output/sum_continuum_labor_`1'_`2'_`3'.dta", key(slope_cbm) replace log_replace