clear all

local rank = `1'
assert inrange(`rank', 1, 3)

import delimited using "../input/nyc2010_orig_time_ife_`rank'.csv", stringcols(1)  clear

assert _N ==  2160 // check number of observations
rename (v1 v2) (i fe_i)
label variable i "Tract of residence (11-digit FIPS)"
label variable fe_i "Residence tract fixed effect"
save_data "../output/nyc2010_orig_time_ife_`rank'.dta", key(i) replace log_replace
