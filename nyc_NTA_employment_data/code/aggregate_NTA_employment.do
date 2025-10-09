clear all
foreach t of numlist 2010(2)2012  {
use "../input/lodes_NYC_`t'.dta", clear
collapse (sum) X_ij, by(j)
rename (X_ij j) (employment tract)
gen year = `t'
merge 1:m tract using "../input/nyc_tract_NTA_crosswalk.dta", assert(using match) keep(match) nogen 
collapse (sum) employment, by(NTA_code)
rename employment emp_`t'  
tempfile df`t'
save `df`t''
}
use `df2010', clear
merge 1:1 NTA_code using `df2012', assert(match) nogen  
label var emp_2010 "NTA total employment of NYC residents in 2010"
label var emp_2012 "NTA total employment of NYC residents in 2012"
save_data "../output/NTA_employment.dta", key(NTA_code) replace log_replace

