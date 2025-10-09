clear all
// Loading LODES employment data
use "../input/nyc2010_lodes_wzero_wdelta.dta", clear
collapse (sum) employment = X_ij, by(j)
rename j geoid11_work
merge 1:1 geoid11_work using "../input/nyc2010_wage.dta", assert(match) nogen keepusing(Wj)
rename (geoid11_work Wj) (tract wage)
merge 1:1 tract using "../input/nyc_tract_NTA_crosswalk.dta", assert(using match) keep(match) nogen
collapse (mean) wage [w=employment], by(NTA_code)
rename wage avg_wage
gen geoid11_work = NTA_code
label var avg_wage "Average wage in NTA (2010)"
label var geoid11_work "NTA code, named for compatibility with prep functions used on tract-level data"
save_data `1', key(NTA_code) replace log_replace

