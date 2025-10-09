clear all
assert inrange(`1', 1, 100)  // Number of simulation 

// Import simulated individuals' optimal choices before and after
import delimited "../temp/granular_NTA_s`1'.csv", clear
assert _N == 2488905
gen int count = 1
tempfile tf_counts 
save `tf_counts'

// Import tract identifiers for mapping
import delimited "../temp/amazon_ctfl_cbm_nta_meanutil.csv", stringcols(1/2) clear
sort j i
gen row_id_before = _n
gen row_id_after = row_id_before
tempfile NTA_identifiers
save `NTA_identifiers', replace 

use row_id_before count using `tf_counts', clear 
collapse (sum) count, by(row_id_before)
merge 1:1 row_id_before using `NTA_identifiers', nogen assert(using match)
recode count .= 0
rename count X_ij_before
collapse (sum) X_ij_before, by(i j)
tempfile labor_allocation_before
save `labor_allocation_before', replace

use row_id_after count using `tf_counts', clear
collapse (sum) count, by(row_id_after)
merge 1:1 row_id_after using `NTA_identifiers', nogen assert(using match)
recode count .= 0
rename count X_ij_after 
collapse (sum) X_ij_after, by(i j)
merge 1:1 i j using `labor_allocation_before', nogen assert(match)

// Output 
export delimited "../temp/finite_labor_allocation_NTA_s`1'.csv", replace
