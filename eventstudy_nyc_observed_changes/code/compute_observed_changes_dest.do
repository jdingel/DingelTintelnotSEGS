clear all
use `1', clear
keep i j X_ij
rename X_ij X_ij_preperiod
tempfile temporary
save `temporary'

use `2', clear
keep i j X_ij
rename X_ij X_ij_postperiod
merge 1:1 i j using `temporary' // merge on i and j
replace X_ij_postperiod = 0 if _merge == 2
drop if _merge==1 
collapse (sum) X_ij_postperiod X_ij_preperiod, by(j)
rename X_ij_postperiod X_j_postperiod
rename X_ij_preperiod X_j_preperiod
keep j X_j_postperiod X_j_preperiod
gen X_j_difference = X_j_postperiod - X_j_preperiod
gen X_j_ratio = (X_j_postperiod) / X_j_preperiod
replace X_j_ratio = 1 if missing(X_j_ratio) // no change if both are missing
label variable X_j_difference "The observed difference in total commuters to j"
label variable X_j_ratio "The 2012/before ratio of total commuters to j"
label variable X_j_postperiod "The total number of commuters to j in 2012"
label variable X_j_preperiod "The total number of commuters to j in the earlier period"
compress
save_data `3', key(j) replace log_replace