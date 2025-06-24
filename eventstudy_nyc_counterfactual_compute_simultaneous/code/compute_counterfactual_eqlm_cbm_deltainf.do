clear all

import delimited "../output/nyc_obs_cbm_sigma_4.0_all.csv", stringcol(1/2) case(preserve)
merge 1:1 i j using "../input/nyc2010_lodes_wzero_wdelta.dta", keepusing(X_ij) assert(match) nogen
replace x_ctfl = x_baseline if X_ij == 0
sort j i
order i j x_baseline x_ctfl
keep i j x_baseline x_ctfl
export delimited "../output/nyc_obs_cbm_deltainf_all.csv", replace 