clear all
import delimited using `1', clear case(preserve) stringcols(1 2)
keep i j X_ij_preperiod
label variable X_ij_preperiod "The approximated number of commuters traveling from i to j in 2010"
compress
save_data `2', key(i j) replace log_replace