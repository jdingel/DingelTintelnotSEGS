clear all
use "../input/NTA_employment.dta", clear
gen pct_change = 100*(emp_2012-emp_2010)/emp_2010
drop if substr(NTA_code,-2,2)=="99" // drop if NTA code ends in 99 which indicate a geographically non-contiguous NTA
keep if inrange(emp_2010,2000,.)

keep if inrange(pct_change,5,.)
assert _N == 64
local N = _N
outsheet NTA_code using "../output/NTA_spikes_list_5pct.csv", replace
save "../temp/NTA_spikes_list_5pct.dta", replace
file open booms_5_pct using "../output/NTA_boom_count_5pct.tex", write replace
file write booms_5_pct "There are `N' NTAs that had 2010-2012 employment growth of at least 5\% from a level of at least 2,000 employees in 2010."
file close booms_5_pct

keep if inrange(pct_change,10,.)
assert _N==41
local N = _N
outsheet NTA_code using "../output/NTA_spikes_list_10pct.csv", replace
save "../temp/NTA_spikes_list_10pct.dta", replace
file open booms_10_pct using "../output/NTA_boom_count_10pct.tex", write replace
file write booms_10_pct "There are `N' NTAs that had 2010-2012 employment growth of at least 10\% from a level of at least 2,000 employees in 2010."
file close booms_10_pct

keep if inrange(pct_change,12.5,.)
assert _N==35
local N = _N
outsheet NTA_code using "../output/NTA_spikes_list_12.5pct.csv", replace
save "../temp/NTA_spikes_list_12.5pct.dta", replace
file open booms_12_5_pct using "../output/NTA_boom_count_12.5pct.tex", write replace
file write booms_12_5_pct "There are `N' NTAs that had 2010-2012 employment growth of at least 12.5\% from a level of at least 2,000 employees in 2010."
file close booms_12_5_pct
file open num_booms_12_5_pct using "../output/NTA_boom_count_12.5pct_num.tex", write replace
file write num_booms_12_5_pct "`N'"
file close num_booms_12_5_pct