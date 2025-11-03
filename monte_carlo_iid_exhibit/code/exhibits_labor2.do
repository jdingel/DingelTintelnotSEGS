// This script takes estimated slopes and intercepts, and MSEs 
// from the regression where the iid DGP is the truth, 
// fixed \lambda=0 and across 100 simulations and population sizes.
// It summarizes the mean statistics across different magnitudes of population and productivities.

clear all

// Check arguments are valid
assert inlist(`1',0,0.1,0.25,0.5,1) // Magnitude of random effect (Lambda)
assert inlist(`2',1.09,1.18) // Size of productivity shocks

//Load data
use "../input/sum_iid_labor_`1'_2.488905_`2'.dta", clear
gen pop = 2.488905
foreach pop in 5 12.5 25 50 125 250 2560 {
	append using "../input/sum_iid_labor_`1'_`pop'_`2'.dta"
	replace pop = `pop' if pop == .
}

// Report summary statistics for predictions by varying population size
gen ratio_MSE = mse_cbm / mse_csp
collapse (mean) mean_intercept_cbm=intercept_cbm mean_intercept_csp=intercept_csp ///
	mean_slope_cbm=slope_cbm mean_slope_csp=slope_csp ///
	mean_mse_cbm=mse_cbm mean_mse_csp=mse_csp mean_mse_ratio=ratio_MSE, by(pop)

mkmat mean_slope_csp mean_intercept_csp mean_mse_csp, matrix(iid_changes)
matrix iid_changes = iid_changes'
matrix list iid_changes

frmttable using "../output/sumstats_iid_labor_`1'_`2'.tex", replace ///
	statmat(iid_changes) sdec(3) ///
	ctitle("\textit{I}" "2.5" "5" "12.5" "25" "50" "125" "250" "2560") ///
	rtitle("Calibrated-shares: slope" \ ///
		"Calibrated-shares: intercept" \ ///
		"Calibrated-shares: MSE") ///
	tex frag nocenter
shell sed -i.bak 's/\\end{tabular}\\\\/\\end{tabular}/g' "../output/sumstats_iid_labor_`1'_`2'.tex"
rm ../output/sumstats_iid_labor_`1'_`2'.tex.bak