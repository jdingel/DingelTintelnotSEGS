cap program drop nyc_dist_delta // this script heavily borrows from the original nyc_delta.do in `common_scripts`
cap program define nyc_dist_delta
syntax, df_commute(string) [output(string)] [keepifnumlist(string)]

// prepare data for NYC
use "../input/NYC_tractpairs_DDMM.dta",clear // 2110i * 2110j
tempfile nyc_time
save `nyc_time'
rename (geoid11_orig geoid11_dest traveltime_public) (geoid11_dest geoid11_orig time_ij)
drop traveltime_car physical_distance
merge 1:1 geoid11_orig geoid11_dest using `nyc_time', keep(match) keepusing(traveltime_public) nogen
rename (geoid11_orig geoid11_dest traveltime_public) (j i time_ji)
tempfile nyc_commute_time
save `nyc_commute_time'

use `df_commute',clear 
merge 1:1 i j using `nyc_commute_time', keep(master match) nogen 
tempfile df_early_withdelta
save `df_early_withdelta'

// impute commuting time based on distance
merge_geocoords, geo("../input/2015_gaz_tracts_36.txt") keepifnumlist(`keepifnumlist')
merge 1:1 i j using `df_early_withdelta', keep(match) nogen
assert time_ij>0|missing(time_ij) if i!=j
assert time_ji>0|missing(time_ji) if i!=j
assert dist_ij>0|missing(dist_ij) if i!=j
gen log_timeij = log(time_ij)
gen log_timeji = log(time_ji)
gen log_dist = log(dist_ij)
reghdfe log_timeij log_dist, absorb(i j)
predict log_timeij_predict
local rounded_r2 = round(e(r2),0.01)
shell echo -n "`rounded_r2'" > "../output/log_time_log_dist_r2.tex"
reghdfe log_timeji log_dist, absorb(i j)
predict log_timeji_predict

qui count if missing(time_ij)==1|missing(time_ji)==1
drop time_ij time_ji
gen time_ij = exp(log_timeij_predict)
gen time_ji = exp(log_timeji_predict)
replace time_ij = 0 if i==j
replace time_ji = 0 if i==j
assert mi(time_ij)==0
assert mi(time_ji)==0
gen delta = 540/(540-time_ij-time_ji)
assert inrange(delta,1,.) if X_ij>0 
replace delta = . if 540 < time_ij + time_ji //Commute is infeasible.
keep i j X_ij delta
gen log_delta = log(delta)
label var i "Tract of residence (11-digit FIPS)"
label var j "Tract of workplace (11-digit FIPS)"
label var X_ij "Number of commuters residing in i and working in j"
label var delta "Commuting cost as a function of transit time"
label var log_delta "Commuting cost as a function of transit time (log)"
compress
if "`output'"!="" save_data `output', key(i j) replace log_replace

end