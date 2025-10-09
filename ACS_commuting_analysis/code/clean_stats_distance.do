clear all

do "clean_stats_programs_distance.do"

// prepare data
// distance
import delimited "../input/sf12010countydistance100miles.csv", clear
gen dist_km = mi_to_county*1.60934
keep if inrange(dist_km,0,120)==1
gen ID_h = string(county1, "%05.0f")
gen ID_w = string(county2, "%05.0f")
keep ID* dist_km
tempfile distance_data
save `distance_data'

// ACS_20062010 
import excel "../input/ACS_20062010_commuting.xlsx", cellrange(A5:J136799) firstrow clear
rename (StateFIPSCode CountyFIPSCode StateUSIslandAreaForeignC D          E      F   State      County      I           J) ///
		(StateID_h    CountyID_h     StateID_w                 CountyID_w X_ij MOE  State_h     County_h    State_w     County_w)
select_UScounties
merge 1:1 ID_h ID_w using `distance_data', keepusing(dist_km)
merge_w_dist
keep_label_vars
save_data "../output/ACS_20062010_dist_within120km.dta", key(ID_h ID_w) replace log_replace

// ACS_20092013 
import excel "../input/ACS_20092013_commuting.xlsx", cellrange(A6:N137498) firstrow clear
rename (StateFIPSCode CountyFIPSCode StateName CountyName MetropolitanStatisticalAreaFI MetropolitanStatisticalAreao G         H          I       J        K         L       WorkersinCommutingFlow MarginofError) ///
		(StateID_h    CountyID_h     State_h   County_h   MetroID_h                     Metro_h                      StateID_w CountyID_w State_w County_w MetroID_w Metro_w X_ij                   MOE)
select_UScounties
merge 1:1 ID_h ID_w using `distance_data', keepusing(dist_km)
merge_w_dist
keep_label_vars
save_data "../output/ACS_20092013_dist_within120km.dta", key(ID_h ID_w) replace log_replace

// ACS_20112015 
import excel "../input/ACS_20112015_commuting.xlsx", cellrange(A7:J139440) firstrow clear
rename (StateFIPSCode CountyFIPSCode StateName CountyName E         F          G       H        WorkersinCommutingFlow MarginofError) ///
		(StateID_h    CountyID_h     State_h   County_h   StateID_w CountyID_w State_w County_w X_ij                   MOE)
select_UScounties
rename (ID_h ID_w) (ID_h_temp ID_w_temp)
gen ID_h = ID_h_temp
gen ID_w = ID_w_temp
// manually replace county changes across years
// source: https://www.census.gov/programs-surveys/acs/technical-documentation/table-and-geography-changes.replace_year_here.html
replace ID_h = "02270" if ID_h_temp == "02158"
replace ID_w = "02270" if ID_w_temp == "02158"
replace ID_h = "46113" if ID_h_temp == "46102"
replace ID_w = "46113" if ID_w_temp == "46102"
merge 1:1 ID_h ID_w using `distance_data', keepusing(dist_km)
merge_w_dist
replace ID_h_temp = ID_h if mi(ID_h_temp)==1 & mi(ID_h)==0
replace ID_w_temp = ID_w if mi(ID_w_temp)==1 & mi(ID_w)==0
drop ID_h ID_w
rename (ID_h_temp ID_w_temp) (ID_h ID_w) 
keep_label_vars
save_data "../output/ACS_20112015_dist_within120km.dta",key(ID_h ID_w) replace log_replace


