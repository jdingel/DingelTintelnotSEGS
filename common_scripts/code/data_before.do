clear all

log using "slurmlogs/data_before_`1'.log", replace

// functions
do "../input/nyc_delta.do"
do "../input/clean_wage.do"
do "../input/merge_geocoords.do"
do "../input/programs_LODES.do"
do "../input/gravity_saveFE_time.do"

assert inlist(`1',2008,2010,2013)

if `1'==2008 local zip_wage `""../input/CB0800CZ1.txt""'
if `1'==2010 local zip_wage `""../input/CB1000CZ1.txt""'
if `1'==2013 local zip_wage `""../input/CB1300CZ11.txt""' 

if `1' <= 2010 local zip_tract `""../input/ZIP_TRACT_122010.xlsx""'
if `1' > 2010 local zip_tract `""../input/ZIP_TRACT_12`i'.xlsx""'

local county_list = "36005,36047,36061,36081,36085"

foreach i of numlist `1' {

	// prepare delta as a function of transit time
	nyc_delta, df_commute("../output/nyc`i'_lodes_wzeros.dta") ///
				output("../output/nyc`i'_lodes_wzero_wdelta.dta") ///
				keepifnumlist(`county_list')

	// gravity regression
	gravity_saveFE_time using "../output/nyc`i'_lodes_wzero_wdelta.dta", ///
		time_elasticity("../output/nyc`i'_time_elasticity.csv") ///
		bilat_predict("../output/nyc`i'_bilat_predicted_time.dta") ///
		fe_i("../output/nyc`i'_orig_time.dta") ///
		fe_j("../output/nyc`i'_dest_time.dta") 

	clean_wage, ///
		county_list(`county_list') ///
		zip_tract(`zip_tract') ///
		zip_wage(`zip_wage') ///
		lodes("../input/ny_od_main_JT01_`i'.csv") ///
		output("../output/nyc`i'_wage.dta")
}

log close

