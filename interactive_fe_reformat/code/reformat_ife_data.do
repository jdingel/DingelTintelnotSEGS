clear all

import delimited i j X_ij_preperiod using "`1'", stringcols(1 2)  clear
assert _N ==  4628880 // check number of observations
label variable i "Tract of residence (11-digit FIPS)"
label variable j "Tract of workplace (11-digit FIPS)"
label variable X_ij_preperiod "Number of IFE-approximated commuters residing in i and working in j"
save_data "`2'", key(i j) replace log_replace
