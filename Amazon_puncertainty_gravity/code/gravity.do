clear all

// programs
do "../input/nyc_delta.do"
do "../input/merge_geocoords.do"
do "../input/gravity_saveFE_time.do"

// arguments
local county_list = "36005,36047,36061,36081,36085"

// prepare delta as a function of transit time
import delimited "../input/baseline_data_puncertainty_s`1'.csv", clear
tostring i j, replace format("%11.0f")
rename x_ij X_ij
tempfile temp
save `temp' //save as 
nyc_delta, df_commute(`temp') ///
			output("../output/nyc2010_lodes_wzero_wdelta_puncertainty_`1'.dta") ///
			keepifnumlist(`county_list')

// gravity regression
gravity_saveFE_time using "../output/nyc2010_lodes_wzero_wdelta_puncertainty_`1'.dta", ///
	time_elasticity("../output/nyc2010_time_elasticity_puncertainty_`1'.csv") ///
	bilat_predict("../output/nyc2010_bilat_predicted_time_puncertainty_`1'.dta") ///
	fe_i("../output/nyc2010_orig_time_puncertainty_`1'.dta") ///
	fe_j("../output/nyc2010_dest_time_puncertainty_`1'.dta") 