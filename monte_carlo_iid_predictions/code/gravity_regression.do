clear all

// arguments
assert inlist(`1',0,0.1,0.25,0.5,1) // magnitude of random effect
assert inlist(`2',2.488905,5,12.5,25,50,125,250,2560) // population
assert inlist(`3', 1.09, 1.18) // magnitude of shock
assert inrange(`4',1,100) // event

// programs
do "../input/gravity_saveFE_time.do"

// prepare delta as a function of transit time
import delimited "../input/nyc2010_lodes_wzero_wdelta.csv", clear
keep id_i id_j log_delta
tempfile LODES
save `LODES', replace

import delimited "../input/DGP_`1'_`2'_`3'_`4'.csv", clear
merge 1:1 id_j id_i using `LODES', assert(using match) keep(match) nogen
rename (x_ij_before id_i id_j) (X_ij i j)
tempfile df
save `df' //save as 
gen delta = exp(log_delta)
save_data "../output/nyc2010_lodes_wzero_wdelta_`1'_`2'_`3'_`4'.dta", key(i j) replace log_replace
// gravity regression
gravity_saveFE_time using `df', ///
	time_elasticity("../output/elasticity_`1'_`2'_`3'_`4'.csv") ///
	fe_i("../output/fe_i_`1'_`2'_`3'_`4'.dta") ///
	fe_j("../output/fe_j_`1'_`2'_`3'_`4'.dta")