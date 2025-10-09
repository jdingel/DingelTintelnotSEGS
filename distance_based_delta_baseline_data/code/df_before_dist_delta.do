clear all

// functions
do "compute_distance_based_delta_fn.do"
do "../input/merge_geocoords.do"
do "../input/programs_LODES.do"
do "../input/gravity_saveFE_time.do"


local county_list = "36005,36047,36061,36081,36085"

	// prepare delta as a function of transit time
	nyc_dist_delta, df_commute("../input/nyc2010_lodes_wzeros.dta") ///
				output("../output/nyc2010_lodes_wzero_wdistdelta.dta") ///
				keepifnumlist(`county_list')

	// gravity regression
	gravity_saveFE_time using "../output/nyc2010_lodes_wzero_wdistdelta.dta", ///
		time_elasticity("../output/nyc2010_time_elasticity_dist.csv") ///
		bilat_predict("../output/nyc2010_bilat_predicted_dist.dta") ///
		fe_i("../output/nyc2010_orig_dist.dta") ///
		fe_j("../output/nyc2010_dest_dist.dta") 