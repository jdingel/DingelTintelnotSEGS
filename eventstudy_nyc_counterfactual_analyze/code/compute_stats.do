clear all

// assert treatment locations
assert inlist("`1'", "../temp/treatmentIDS.csv", "../temp/treatmentIDS_NTA.csv")
/* 
"../temp/treatmentIDS.csv" for the list of tracts that experienced employment booms in 2010-2012
"../input/NTA_spikes_list_12.5pct.csv" for the list of NTAs that experienced employment booms in 2010-2012
*/

// assert model class
import delimited "../input/specification_list.csv", varnames(1) clear 
keep if specification_name == "`2'"
assert _N == 1

// assert observed changes
assert inlist("`3'", "../input/nyc_2012_2010_observed_changes_tracttotract.dta", ///
	"../input/nyc_NTA_2012_2010_observed_changes_origtodest.dta")

// template for saving results
clear
tempfile template
save `template', emptyok

// a list of treatment ID
import delimited "`1'", varnames(1) stringcols(_all) clear

levelsof id, local(treatment_list)

// counterfactual predictions
import delimited "../input/nyc_obs_`2'_all.csv", stringcols(1 2) clear
gen predicted_changes = x_ctfl - x_baseline

if strpos("`2'", "pool") > 0{
	merge 1:1 j i using "`3'", assert(match master) nogen
}
else{
	merge 1:1 j i using "`3'", assert(match) nogen
}

rename X_ij_difference observed_changes

foreach id in `treatment_list'{
	preserve 
		keep if j == "`id'"
		egen mse_temp = mean((predicted_changes - observed_changes)^2)
		summ mse_temp
		local MSE = r(mean)
		
		reg observed_changes predicted_changes
		local SLOPE: display %5.4f _b[predicted_changes]
		local INTERCEPT: display %5.4f _b[_cons]
		
		clear 
		set obs 1
		gen j = "`id'"
		gen mse = `MSE'
		gen slope = `SLOPE'
		gen intercept = `INTERCEPT'
		append using `template'
		save `template', replace
		clear
	restore
}

use `template', clear
order j slope intercept mse 
sort j

foreach var in slope intercept mse{
	format `var' %5.4f
}

export delimited "../output/slope_int_MSE_all_`2'.csv", datafmt replace