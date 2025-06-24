clear all
use `1', clear
keep i j X_ij
rename X_ij X_ij_preperiod
gen obs = _N // keep obs
tempfile temporary
save `temporary'

use `2', clear
keep i j X_ij
rename X_ij X_ij_postperiod
merge 1:1 i j using `temporary'
replace X_ij_postperiod = 0 if _merge == 2
drop if _merge==1
assert(obs ==_N) 
keep i j X_ij_postperiod X_ij_preperiod
gen X_ij_difference = X_ij_postperiod - X_ij_preperiod
label variable X_ij_difference "The difference in commuters traveling from i to j between 2012 and before"
label variable X_ij_postperiod "The total number of commuters traveling from i to j in 2012"
label variable X_ij_preperiod "The total number of commuters traveling from i to j before 2012"
compress
save_data `3', key(i j) replace log_replace