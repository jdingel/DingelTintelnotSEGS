clear all

// Verifies that filename exists and is readable
confirm file `1'
confirm file `2'

// Read SVD data
use "`1'"

rename (X_ij_preperiod)(X_ij_pred)
drop if length(i) != 11
sort j i

// IFE_fitted_df doesn't have observed values, merge w/ CBM_fitted_df to get one
merge 1:1 i j using "`2'", keepusing(X_ij) assert(match) nogen

save "`3'", replace