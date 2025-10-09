clear all

// programs
do "../input/nyc_delta.do"
do "../input/merge_geocoords.do"
do "../input/gravity_saveFE_time.do"

// arguments
local county_list = "36005,36047,36061,36081,36085"

// prepare delta as a function of transit time
nyc_delta, df_commute("../output/nyc_avg_labor_`1'_`2'.dta") ///
			output("../output/nyc_pool_`1'_`2'_lodes_wzero_wdelta.dta") ///
			keepifnumlist(`county_list')

// gravity regression
gravity_saveFE_time using "../output/nyc_pool_`1'_`2'_lodes_wzero_wdelta.dta", ///
	time_elasticity("../output/nyc_pool_`1'_`2'_time_elasticity.csv") ///
	bilat_predict("../output/nyc_pool_bilat_predicted_`1'_`2'.dta") ///
	fe_i("../output/nyc_pool_`1'_`2'_orig_time.dta") ///
	fe_j("../output/nyc_pool_`1'_`2'_dest_time.dta") 
