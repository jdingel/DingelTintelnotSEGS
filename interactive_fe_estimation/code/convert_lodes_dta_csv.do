// This script simply converts the LODES data from .dta to .csv for
// use in the MATLAB script that performs the IFE estimation, int_fe_est.m

use "../input/nyc2010_lodes_wzero_wdelta.dta"
replace log_delta = 9 if missing(log_delta) // handle two missing values
replace delta = 1e9 if missing(delta) // handle two missing values
sort j i
export delimited using "../temp/nyc2010_lodes.csv", replace