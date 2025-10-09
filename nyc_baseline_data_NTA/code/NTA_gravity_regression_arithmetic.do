clear all
use "../input/NTA_commutingflows_2010.dta", clear
merge 1:1 i j using "../input/NTA_delta_arithmetic.dta", assert(match) nogen keepusing(delta)
gen log_delta = log(delta)
save_data "../output/nyc_NTA_2010_lodes_wzero_wdelta.dta", key(i j) replace log_replace
do "NTA_gravity_saveFE_time.do"

gravity_saveFE_time using "../output/nyc_NTA_2010_lodes_wzero_wdelta.dta", ///
		time_elasticity("../output/nyc_NTA_2010_time_elasticity.csv") ///
		bilat_predict("../output/nyc_NTA_2010_bilat_predicted_time.dta") ///
		fe_i("../output/nyc_NTA_2010_orig_FE.dta") ///
		fe_j("../output/nyc_NTA_2010_dest_FE.dta")  ///
		r2p("../output/nyc_NTA_2010_r2p.txt") 
