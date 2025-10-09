********************************************************************************
* This script saves estimated slopes, intercepts and MSEs 
* when regressing the changes in labor allocation
* from the continuum model on the CSP predicted changes
* across 100 simulations, population sizes and magnitudes of lambda
********************************************************************************

clear all

// Check arguments are valid
assert inlist(`1',0,0.1,0.25,0.5,1) // Magnitude of random effect (Lambda)
assert inlist(`2',2.488905,5,12.5,25,50,125,250,2560) // Population size
assert inlist(`3',1.09,1.18) // Size of productivity shocks
assert inlist("`4'", "1", "2", "3", "4", "5", "6", "8", "10") | ///
	inlist("`4'", "12", "14", "16", "18", "20","22", "24", "26") | ///
	inlist("`4'", "15", "50", "100", "500", "900", "1000", "1100", "1500", "full") // Rank of approximation

// Create dataframe that stores statistics from each regression
set obs 100
gen slope_svd = .
gen intercept_svd = .
gen mse_svd = .
tempfile df
save `df'

foreach idx of numlist 1/100{
	
	// Import continuum labor allocations
	import delimited "../input/DGP_continuum_`1'_`3'_ell.csv", clear
	// Keep commuting flows to the treated tract
	keep if id_j == 1145
	gen d_ell_cont = x_ij_after - x_ij_before
	tempfile df_cont
	save `df_cont', replace

	// Import SVD-CSP-predicted labor allocation
	import delimited "../input/prediction_svd_`1'_`2'_`3'_`idx'_`4'_ell.csv", clear
	gen d_ell_svd = x_ij_after - x_ij_before
	merge 1:1 id_i using `df_cont', assert(match using) keepusing(d_ell_cont) nogen

	// Run regressions and get summary statistics
	reg d_ell_cont d_ell_svd
	local slope_svd = _b[d_ell_svd]
	local intercept_svd = _b[_cons]
	egen MSE_svd = mean((d_ell_cont - d_ell_svd)^2)
	local mse_svd = MSE_svd[1]

	// Save sum stats into dataframe
	use `df',clear
	replace slope_svd = `slope_svd' if _n==`idx'
	replace intercept_svd = `intercept_svd' if _n==`idx'
	replace mse_svd = `mse_svd' if _n==`idx'
	tempfile df
	save `df'
}

// Output lambda-population-specific summary statistics 
save "../output/sum_continuum_labor_`1'_`2'_`3'_`4'.dta", replace