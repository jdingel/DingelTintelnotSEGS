clear all

assert inlist(`1', 1.09, 1.18) // Magnitude of productivity shock
assert inrange(`2',1,100) // event

do "../input/gravity_saveFE_time.do"

import delimited "../input/nyc2010_lodes_wzero_wdelta.csv", clear
tempfile LODES
save `LODES'

import delimited "../input/DGP_`1'_`2'_fixednu.csv", clear
merge 1:1 id_i id_j using `LODES', assert(match) keepusing(log_delta) nogen
rename (id_i id_j x_ij_before) (i j X_ij)
tempfile df
save `df'
gen delta = exp(log_delta)
save_data "../temp/nyc2010_lodes_wzero_wdelta_`1'_`2'_fixednu.dta", key(i j) replace log_replace
// gravity regression
gravity_saveFE_time using `df', ///
	time_elasticity("../temp/elasticity_`1'_`2'_fixednu.csv") ///
	fe_i("../temp/fe_i_`1'_`2'_fixednu.dta") ///
	fe_j("../temp/fe_j_`1'_`2'_fixednu.dta")

