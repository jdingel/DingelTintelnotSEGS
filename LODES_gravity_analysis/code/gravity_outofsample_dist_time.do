* PPML regression, predict with transformation of transit times / distance
* regress observed data in 2014 on observed data in 2013
* regress observed data in 2014 on PPML prediction based on observed data in 2013

clear all

assert inlist("`1'","DetroitUA","NYC")

if "`1'"=="NYC" local countylist="36005,36047,36061,36081,36085"
if "`1'"=="NYC" local state_id=36
if "`1'"=="DetroitUA" local countylist="26099,26125,26163"
if "`1'"=="DetroitUA" local state_id=26


foreach package in logout frmttable outreg {
    capture which `package'
    if _rc==111 ssc install `package'
}

//Load all pairs of geographic units
insheet using "../input/2015_gaz_tracts_`state_id'.txt", clear
tostring geoid, replace format("%11.0f")
if "`countylist'"!="" foreach element of numlist `countylist' {
	local keepiflist = `"`keepiflist'"' + `""`element'""' + ", " //Construct a list of strings from the numlist
}
local keepiflist = substr(`"`keepiflist'"',1,length(`"`keepiflist'"')-2) //Drop the final unnecessary comma
if "`countylist'"!="" keep if inlist(substr(geoid,1,5),`keepiflist')
rename (geoid intptlat intptlong) (i lat_i lon_i)
keep i lat_i lon_i

tempfile tf_i
save `tf_i'
rename (i lat_i lon_i) (j lat_j lon_j)
cross using `tf_i'
geodist lat_i lon_i lat_j lon_j, gen(dist_ij)
drop lat_i lon_i lat_j lon_j

tempfile geo_coords
save `geo_coords'


// Prepare commuting data and covariates
use "../input/`1'_delta_LODES2013.dta", clear
rename X_ij X_ij2013
tempfile df2013_delta
save `df2013_delta'

use "../input/lodes_`1'_2014.dta", clear
fillin i j
recode X_ij .=0 if _fillin==1
drop _fillin
rename X_ij X_ij2014
merge 1:1 i j using `df2013_delta', keep(match using)
replace X_ij2014 = 0 if _merge==2
drop _merge

merge 1:1 i j using `geo_coords', assert(match using) keep(match) nogen
gen dist_log_ij = log(dist_ij)
label var dist_log_ij "Distance (log)"
assert dist_ij==0 if missing(dist_log_ij)==1

//PPML regression with log delta
ppmlhdfe X_ij2013 log_delta, absorb(i j) d
predict X_ij_predicted_delta

//PPML regression with log distance
ppmlhdfe X_ij2013 dist_log_ij, absorb(i j) d
predict X_ij_predicted_dist


//Comparisons of predictions (log delta covariate)
foreach valmax of numlist 5 10 {
	count if inrange(X_ij2013,0,`valmax')==1
	local sample_share = string(`r(N)'/_N,"%4.3f")
	qui regress X_ij2014 X_ij2013    		if inrange(X_ij2013,0,`valmax')==1 & missing(X_ij_predicted_delta)==0
	assert _b[X_ij2013]>0
	gen byte sample_`valmax'_delta = (e(sample)==1)
	local martingale_r2 = string(e(r2),"%4.3f")
	qui regress X_ij2014 X_ij_predicted_delta	if inrange(X_ij2013,0,`valmax')==1 & missing(X_ij_predicted_delta)==0
	assert _b[X_ij_predicted_delta]>0
	local gravity_r2 = string(e(r2),"%4.3f")
	local list_time_`valmax' ="`sample_share'" +" " + "`gravity_r2'" + " " + "`martingale_r2'"
}


//Comparisons of predictions (log distance covariate)
foreach valmax of numlist 5 10  {
	qui regress X_ij2014 X_ij2013    		if inrange(X_ij2013,0,`valmax')==1 & missing(X_ij_predicted_dist)==0
	assert _b[X_ij2013]>0
	gen byte sample_`valmax'_dist = (e(sample)==1)
	local martingale_r2 = string(e(r2),"%4.3f")
	qui regress X_ij2014 X_ij_predicted_dist	if inrange(X_ij2013,0,`valmax')==1 & missing(X_ij_predicted_dist)==0
	assert _b[X_ij_predicted_dist]>0
	local gravity_r2 = string(e(r2),"%4.3f")
	local list_dist_`valmax' = "`gravity_r2'" +" " +  "`martingale_r2'"

}

// Output
mat input mat_time = (`list_time_5' \ `list_time_10')
mat input mat_dist = (`list_dist_5' \ `list_dist_10')
mat mat_gravity = mat_time,mat_dist
frmttable using "../output/gravity_outofsample_`1'.tex", ///
	statmat(mat_gravity) sd(3) tex frag nocenter replace ///
	ctitle("# of commuters" "Share" "Gravity: time" "2013 values" "Gravity: distance" "2013 values") ///
	rtitle("$\leq$ 5" \ "$\leq 10$")
