clear all

assert inlist(`1',0,0.1,0.25,0.5,1) // Magnitude of disutility (Lambda)
assert inlist(`2',2.488905,5,12.5,25,50,125,250,2560) // Population size

// calculate the statistics for both models, among 100 events
set obs 100
gen slope_cbm = .
gen slope_cs = .
gen intercept_cbm = .
gen intercept_cs = .
gen mse_cbm = .
gen mse_cs = .
tempfile df
save `df'

foreach i of numlist 1/100{

	use "../input/DGP_iid_1145_treatedonly_`1'_`2'_1.09_`i'.dta", clear 
	assert id_j==1145
	gen obs = d_ell_dgp
	tempfile dgp_tf
	save `dgp_tf'

	import delimited "../input/prediction_cbm_`1'_`2'_1.09_`i'_ell.csv",clear
	gen cbm = x_ij_after - x_ij_before
	keep i cbm
	tempfile cbm_tf
	save `cbm_tf'

	import delimited "../input/prediction_csp_`1'_`2'_1.09_`i'_ell.csv",clear
	gen csp = x_ij_after - x_ij_before
	keep id_i csp
	merge 1:1 id_i using `dgp_tf', assert(match) nogen
	merge 1:1 id_i using `cbm_tf', assert(match) nogen

	reg obs cbm
	local slope_cbm = _b[cbm]
	local intercept_cbm = _b[_cons]
	egen MSE_cbm = mean((obs-cbm)^2)
	local mse_cbm = MSE_cbm[1]

	reg obs csp
	local slope_cs = _b[csp]
	local intercept_cs = _b[_cons]
	egen MSE_cs = mean((obs-csp)^2)
	local mse_cs = MSE_cs[1]

	use `df',clear
	replace slope_cbm = `slope_cbm' if _n==`i'
	replace slope_cs = `slope_cs' if _n==`i'
	replace intercept_cbm = `intercept_cbm' if _n==`i'
	replace intercept_cs = `intercept_cs' if _n==`i'
	replace mse_cbm = `mse_cbm' if _n==`i'
	replace mse_cs = `mse_cs' if _n==`i'
	tempfile df
	save `df'

}
collapse ///
(mean) mean_slope_cbm=slope_cbm mean_slope_cs=slope_cs ///
	mean_intercept_cbm=intercept_cbm mean_intercept_cs=intercept_cs ///
	mean_mse_cbm=mse_cbm mean_mse_cs=mse_cs ///
(median) median_slope_cbm=slope_cbm median_slope_cs=slope_cs ///
	median_intercept_cbm=intercept_cbm median_intercept_cs=intercept_cs ///
	median_mse_cbm=mse_cbm median_mse_cs=mse_cs ///
(min) min_slope_cbm=slope_cbm min_slope_cs=slope_cs ///
	min_intercept_cbm=intercept_cbm min_intercept_cs=intercept_cs ///
	min_mse_cbm=mse_cbm min_mse_cs=mse_cs ///
(max) max_slope_cbm=slope_cbm max_slope_cs=slope_cs ///
	max_intercept_cbm=intercept_cbm max_intercept_cs=intercept_cs ///
	max_mse_cbm=mse_cbm max_mse_cs=mse_cs ///
(sd) sd_slope_cbm=slope_cbm sd_slope_cs=slope_cs ///
	sd_intercept_cbm=intercept_cbm sd_intercept_cs=intercept_cs ///
	sd_mse_cbm=mse_cbm sd_mse_cs=mse_cs

// label vars
// mean
label var mean_slope_cbm "slope, mean, covariates-based model"
label var mean_slope_cs "slope, mean, calibrated-shares procedure"
label var mean_intercept_cbm "intercept, mean, covariates-based model"
label var mean_intercept_cs "intercept, mean, calibrated-shares procedure"
label var mean_mse_cbm "MSE, mean, covariates-based model"
label var mean_mse_cs "MSE, mean, calibrated-shares procedure"
// median
label var median_slope_cbm "slope, median, covariates-based model"
label var median_slope_cs "slope, median, calibrated-shares procedure"
label var median_intercept_cbm "intercept, median, covariates-based model"
label var median_intercept_cs "intercept, median, calibrated-shares procedure"
label var median_mse_cbm "MSE, median, covariates-based model"
label var median_mse_cs "MSE, median, calibrated-shares procedure"
// min
label var min_slope_cbm "slope, min, covariates-based model"
label var min_slope_cs "slope, min, calibrated-shares procedure"
label var min_intercept_cbm "intercept, min, covariates-based model"
label var min_intercept_cs "intercept, min, calibrated-shares procedure"
label var min_mse_cbm "MSE, min, covariates-based model"
label var min_mse_cs "MSE, min, calibrated-shares procedure"
// max
label var max_slope_cbm "slope, max, covariates-based model"
label var max_slope_cs "slope, max, calibrated-shares procedure"
label var max_intercept_cbm "intercept, max, covariates-based model"
label var max_intercept_cs "intercept, max, calibrated-shares procedure"
label var max_mse_cbm "MSE, max, covariates-based model"
label var max_mse_cs "MSE, max, calibrated-shares procedure"
// std dev
label var sd_slope_cbm "slope, standard deviation, covariates-based model"
label var sd_slope_cs "slope, standard deviation, calibrated-shares procedure"
label var sd_intercept_cbm "intercept, standard deviation, covariates-based model"
label var sd_intercept_cs "intercept, standard deviation, calibrated-shares procedure"
label var sd_mse_cbm "MSE, standard deviation, covariates-based model"
label var sd_mse_cs "MSE, standard deviation, calibrated-shares procedure"

// output
save_data "../output/results_`1'_`2'.dta", key(max_slope_cbm) replace log_replace