clear all

assert inrange(`1', 1.09, 1.18)  // Productivity shocks 
assert inrange(`2', 1, 100)  // Number of simulation 

// Import simulated individuals' optimal choices across 50 blocks before and after,
// and concatenate the choices into a temp file
shell cat ../temp/choices_`1'_`2'_b{1..50}_fixednu.csv | head -2488905 > "../temp/temp_`1'_`2'.csv"
import delimited "../temp/temp_`1'_`2'.csv", clear
shell rm "../temp/temp_`1'_`2'.csv"
rename (v1 v2 v3) (seed row_id_before row_id_after)
gen int count = 1
tempfile tf_counts 
save `tf_counts'

// Import tract identifiers for mapping
import delimited "../temp/mean_util_`1'_fixednu.csv", clear
keep id_i id_j row_id
rename row_id row_id_before
gen row_id_after = row_id_before
tempfile tract_identifiers
save `tract_identifiers', replace 

use row_id_before count using `tf_counts', clear 
collapse (sum) count, by(row_id_before)
merge 1:1 row_id_before using `tract_identifiers', nogen assert(using match)
recode count .=0
rename count X_ij_before
collapse (sum) X_ij_before, by(id_i id_j)
tempfile labor_allocation_before
save `labor_allocation_before', replace

use row_id_after count using `tf_counts', clear
collapse (sum) count, by(row_id_after)
merge 1:1 row_id_after using `tract_identifiers', nogen assert(using match)
recode count .=0
rename count X_ij_after 
collapse (sum) X_ij_after, by(id_i id_j)
merge 1:1 id_i id_j using `labor_allocation_before', nogen assert(match)

// Output 
export delimited "../output/DGP_`1'_`2'_fixednu.csv", replace
