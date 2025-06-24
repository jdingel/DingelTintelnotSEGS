clear all

local rank = `1'
assert inrange(`rank', 1, 3)

import delimited using "../input/nyc2010_dest_time_ife_`rank'.csv", stringcols(1)  clear


assert _N ==  2143  // check number of observations
rename (v1 v2) (j fe_j)
label variable j "Tract of workplace (11-digit FIPS)"
label variable fe_j "Workplace tract fixed effect"
save_data "../output/nyc2010_dest_time_ife_`rank'.dta", key(j) replace log_replace

