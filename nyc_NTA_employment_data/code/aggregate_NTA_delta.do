clear all
use "../input/nyc_tract_NTA_crosswalk.dta", clear
rename (NTA_code tract) (i_NTA i)
tempfile temporaryi
save `temporaryi'
rename (i i_NTA) (j j_NTA)
tempfile temporaryj
save `temporaryj'

use i j X_ij delta using "../input/nyc2010_lodes_wzero_wdelta.dta", clear
count if missing(delta)
display `r(N)'
assert `r(N)' == 2
replace delta = 10000.0 if missing(delta)
merge m:1 i  using `temporaryi', assert(using match) keep(match) nogen
merge m:1 j  using `temporaryj', assert(using match) keep(match) nogen 
summarize
tempfile baseline_results
save `baseline_results'
// Compute the arithmetic mean of each tract-pair within each NTA pair
collapse (mean) delta, by(j_NTA i_NTA)
replace delta = 1.0 if j_NTA == i_NTA 
sort i_NTA j_NTA
rename (i_NTA j_NTA) (i j)
label var i "NTA of residence (4-digit NTA-Code)"
label var j "NTA of workplace (4-digit NTA-Code)"
label var delta "Commuting cost as a function of transit time"
save_data "../output/NTA_delta_arithmetic.dta", key(j i) replace log_replace
// Compute harmonic mean of each tract-pair within each NTA pair
use `baseline_results', clear
gen inv_delta = 1/delta
collapse (mean) inv_delta, by(j_NTA i_NTA)
gen delta = 1/inv_delta
replace delta = 1.0 if j_NTA == i_NTA 
sort i_NTA j_NTA
rename (i_NTA j_NTA) (i j)
label var i "NTA of residence (4-digit NTA-Code)"
label var j "NTA of workplace (4-digit NTA-Code)"
label var delta "Commuting cost as a function of transit time"
keep i j delta
save_data "../output/NTA_delta_harmonic.dta", key(j i) replace log_replace
// Compute weighted mean of each tract-pair within each NTA pair
use `baseline_results', clear
collapse (sum) X_ij, by (j)
keep X_ij j
rename X_ij X_j
merge 1:m j using `baseline_results', assert(using match) keep(match) nogen
collapse (mean) delta [aw = X_j], by(j_NTA i_NTA)
replace delta = 1.0 if j_NTA == i_NTA 
sort i_NTA j_NTA
rename (i_NTA j_NTA) (i j)
label var i "NTA of residence (4-digit NTA-Code)"
label var j "NTA of workplace (4-digit NTA-Code)"
label var delta "Commuting cost as a function of transit time"
keep i j delta
save_data "../output/NTA_delta_weighted.dta", key(j i) replace log_replace