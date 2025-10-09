clear all
assert inrange(`2', 1, 100)  // Number of simulation 
assert inlist("`1'", "1.1", "4.0", "Inf", "inf") // sigma

// Import simulated individuals' optimal choices before and after
shell cat ../temp/granular_`1'_`2'_{1..50}.csv | head -2488905 > "../temp/temp_`1'_`2'.csv"
import delimited "../temp/temp_`1'_`2'.csv", clear
shell rm "../temp/temp_`1'_`2'.csv"
rename (v1 v2 v3) (seed row_id_before row_id_after)
assert _N == 2488905
gen int count = 1
tempfile tf_counts 
save `tf_counts'

// Import tract identifiers for mapping
import delimited "../temp/amazon_ctfl_tract_cbm_sigma_`1'_meanutil.csv", stringcols(1/2) clear
sort j i
gen row_id_before = _n
gen row_id_after = row_id_before
tempfile tract_identifiers
save `tract_identifiers', replace 

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

// Output 
export delimited "../temp/finite_labor_allocation_`1'_`2'.csv", replace
