// prepare delta as a function of transit time for Detroit UA 
// impute missing commuting time based on distance

cap program drop DetroitUA_delta
cap program define DetroitUA_delta
syntax, df_commute(string) [mi_obs_tex(string)] [output(string)] [keepifnumlist(string)]

import excel "../input/Tract_Classification.xlsx", firstrow clear
tempfile ID_tract
save `ID_tract'

import excel "../input/Kij_GoogleTime.xlsx", firstrow clear
reshape long duration_minutes, i(work_ID)
rename (work_ID _j) (j i)
tempfile detroit_time
save `detroit_time'

rename (i j duration_minutes) (j i t_ij)
merge 1:1 i j using `detroit_time', keepusing(duration_minutes) assert(match) nogen
rename (t_ij duration_minutes) (t_ji t_ij)

rename i ID
merge m:1 ID using `ID_tract', assert(match) keepusing(tract_str) nogen
rename tract_str i
drop ID
rename j ID
merge m:1 ID using `ID_tract', assert(match) keepusing(tract_str) nogen
rename tract_str j
drop ID
tempfile detroit_commute_time
save `detroit_commute_time'

use `df_commute',clear
merge 1:1 i j using `detroit_commute_time', keepusing(t_ij t_ji) keep(master match) nogen
tempfile df
save `df'

// impute commuting time based on distance
merge_geocoords, geo("../input/2015_gaz_tracts_26.txt") keepifnumlist(`keepifnumlist')
merge 1:1 i j using `df', keep(match using) nogen
assert t_ij>0|missing(t_ij) if i!=j
assert t_ji>0|missing(t_ji) if i!=j
assert dist_ij>0 if i!=j
gen log_timeij = log(t_ij)
gen log_timeji = log(t_ji)
gen log_dist = log(dist_ij)
reghdfe log_timeij log_dist, absorb(i j) // r2=0.9488 for 2014 data
predict log_timeij_predict
reghdfe log_timeji log_dist, absorb(i j) // r2=0.9488 for 2014 data
predict log_timeji_predict
qui count if missing(t_ij)==1|missing(t_ji)==1
local N_missing = string(100*`r(N)'/_N,"%4.1f")
if "`mi_obs_tex'"!="" shell echo -n "fewer than `N_missing'\% of tract pairs in Detroit%" > `mi_obs_tex'
gen impute = 0
replace impute = 1 if missing(t_ij)==1|missing(t_ji)==1
gen time_ij_impute = exp(log_timeij_predict)
gen time_ji_impute = exp(log_timeji_predict)
replace t_ij = round(time_ij_impute) if missing(t_ij)==1
replace t_ji = round(time_ji_impute) if missing(t_ji)==1
assert missing(t_ij)==0
assert missing(t_ji)==0
gen delta = 540/(540-t_ij-t_ji)
replace delta=1 if i==j // We impose delta=1 for i==j, whereas ORS impose t_ij==1 if i==j
assert inrange(delta,1,.) if X_ij>0 
replace delta = . if 540 < t_ij + t_ji //Commute is infeasible.
keep i j X_ij delta impute
gen log_delta = log(delta) 
label var i "Tract of residence (11-digit FIPS)"
label var j "Tract of workplace (11-digit FIPS)"
label var X_ij "Number of commuters residing in i and working in j"
label var delta "Commuting cost as a function of transit time"
label var log_delta "Commuting cost as a function of transit time (log)"
label var impute "=1 if missing commuting time is imputed"
compress
if "`output'"!="" save `output', replace
end
