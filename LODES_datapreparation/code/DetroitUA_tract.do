clear all

assert inrange(`1',2005,2014) & `1'==int(`1') //Integer-valued year

do "programs.do"

//https://en.wikipedia.org/wiki/Metro_Detroit says the following: The Detroit Urban Area... covers parts of the counties of Macomb, Oakland, and Wayne.

// Detroit UA
foreach i of numlist `1' {
	import delimited using "../input/mi_od_main_JT01_`i'.csv", clear
	load_LODES_tracts, saveas("../output/lodes_DetroitUA_`i'.dta") ///
		keepifnumlist(26099,26125,26163)
}
