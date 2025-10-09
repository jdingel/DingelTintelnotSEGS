clear all
assert inrange(`1', 0.25, 0.75)  // value of zeta 
assert inrange(`2', 1, 100)      // Number of simulation 

// Import simulated individuals' optimal choices before and after
// concatenates block-level CSV files for a given simulation (total individual = 2,488,905 )
shell cat ../temp/granular_`1'_`2'_{1..50}_nested.csv | head -2488905 > "../temp/temp_`1'_`2'_nested.csv"
import delimited "../temp/temp_`1'_`2'_nested.csv", clear
shell rm "../temp/temp_`1'_`2'_nested.csv"
rename (v1 v2 v3) (seed row_id_before row_id_after)
assert _N == 2488905
gen int count = 1
tempfile tf_counts 
save `tf_counts'

// Import tract identifiers for mapping
use"../input/nyc2010_lodes_wzero_wdelta.dta", clear
rename (j i) (j_code i_code)
sort j_code i_code
egen j = group(j_code)
egen i = group(i_code)
drop j_code i_code
sort j i
gen row_id_before = _n
gen row_id_after = row_id_before
tempfile tract_identifiers
save `tract_identifiers', replace 

// Compute ell
use row_id_before count using `tf_counts', clear 
collapse (sum) count, by(row_id_before)
merge 1:1 row_id_before using `tract_identifiers', nogen assert(using match)
recode count .= 0
rename count X_ij_before
collapse (sum) X_ij_before, by(i j)
tempfile labor_allocation_before
save `labor_allocation_before', replace

use row_id_after count using `tf_counts', clear
collapse (sum) count, by(row_id_after)
merge 1:1 row_id_after using `tract_identifiers', nogen assert(using match)
recode count .= 0
rename count X_ij_after 
collapse (sum) X_ij_after, by(i j)
merge 1:1 i j using `labor_allocation_before', nogen assert(match)
egen total_xij_after = total(X_ij_after)

// Output 
export delimited "../temp/finite_labor_allocation_`1'_`2'_nested.csv", replace
