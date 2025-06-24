clear all

assert inrange(`1',2002,2017) & `1'==int(`1') //Integer-valued year

do "programs.do"


// Tract 36085008900 doesn't exist in transit-time data and distance data, drop it.
import delimited "../input/2015_gaz_tracts_36.txt",clear
assert geoid!=36085008900

use "../input/NYC_tractpairs_DDMM.dta",clear
assert geoid11_orig!="36085008900" & geoid11_dest!="36085008900"

// clean data
foreach i of numlist `1' {
	import delimited using "../input/ny_od_main_JT01_`i'.csv", clear
	load_LODES_tracts,keepifnumlist(36005,36047,36061,36081,36085)
}
drop if i=="36085008900" | j=="36085008900"
save_data "../output/lodes_NYC_`1'.dta", key(i j) replace log_replace
