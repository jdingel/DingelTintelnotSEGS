clear all

// programs
do "../input/clean_wage.do"
do "../input/nyc_delta.do"
do "../input/programs_LODES.do"
do "../input/merge_geocoords.do"
do "../input/gravity_saveFE_time.do"

// arguments
local county_list = "36005,36047,36061,36081,36085"

//assume two arguments `1' is first year and `2' is last year (don't assume pooling three years; could be five)
assert inrange(`1',2001,2016)==1

//Average labor allocation
forvalues year = `1'/`2' {
	import delimited "../input/ny_od_main_JT01_`year'.csv",clear
	tempfile tf_lodes`year'
	load_LODES_tracts, keepifnumlist(`county_list') saveas(`tf_lodes`year'')
}
use `tf_lodes`1'', clear
rename X_ij X_ij`1'
local plusone = `1' + 1
forvalues year = `plusone'/`2' {
	merge 1:1 i j using `tf_lodes`year'', nogen
	rename X_ij X_ij`year'
}
fillin i j
forvalues year = `1'/`2' {
	recode X_ij`year' .=0
}
egen X_ij = rowmean(X_ij2???)
keep i j X_ij
label var X_ij "Average number of commuters residing in i and working in j between 2001 and 2016"
compress
save_data "../output/nyc_avg_labor_`1'_`2'.dta", key(i j) replace log_replace

//Average wages
forvalues year = `1'/`2' {
	local tract_year = `year'
	if `year'<2010 local tract_year = 2010
	if `year'>2010 local wage_dig = 1
	local yr = string(`year' - 2000,"%02.0f")
	
	clean_wage, county_list(`county_list') ///
		zip_tract("../input/ZIP_TRACT_12`tract_year'.xlsx") ///
		zip_wage("../input/CB`yr'00CZ1`wage_dig'.txt") ///
		lodes("../input/ny_od_main_JT01_`year'.csv") ///
		output("../temp/tf_wage`year'.dta")
}

use ../temp/tf_wage`1', clear
rename Wj Wj`1'
local plusone = `1' + 1
forvalues year = `plusone'/`2' {
	merge 1:1 geoid11_work using "../temp/tf_wage`year'.dta", nogen
	rename Wj Wj`year'
	rm "../temp/tf_wage`year'.dta"
}
rm ../temp/tf_wage`1'.dta
egen avg_wage = rowmean(Wj2???)
keep geoid11_work avg_wage
label var geoid11_work "Tract of workplace (11-digit FIPS)"
label var avg_wage "Average workplace wage between 2008 and 2010"
compress
save_data "../output/nyc_avg_wage_`1'_`2'.dta", key(geoid11_work) replace log_replace


