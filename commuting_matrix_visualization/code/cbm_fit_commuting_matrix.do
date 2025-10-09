// This script estimates PPML on 2010 LODES data and gets the CBM-fitted values
clear all

use "../input/nyc2010_lodes_wzero_wdelta.dta", clear

ppmlhdfe X_ij log_delta, absorb(i j) d
predict X_ij_pred

save "../temp/nyc2010_lodes_cbmfit.dta", replace

