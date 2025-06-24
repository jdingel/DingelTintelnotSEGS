cap program drop pool_LODES_years
program define pool_LODES_years

syntax, usingstem(string) usingsuffix(string) firstyear(integer) lastyear(integer) saveasfile(string)

use "`usingstem'`firstyear'`usingsuffix'", clear
rename (X_ij) (X_ij_`firstyear')
local firstyearplusone = `firstyear' + 1
forvalues year = `firstyearplusone'/`lastyear' {
	merge 1:1 i j using "`usingstem'`year'`usingsuffix'", gen(_merge_`year')
	rename (X_ij) (X_ij_`year')
}
fillin i j
drop _fillin
foreach var of varlist X_ij_20?? {
	recode `var' .= 0
}
save "`saveasfile'", replace

end


cap program drop merge_geocoords
program define merge_geocoords
syntax, geo(string) [keepifnumlist(string)] [saveasfile(string)]

//Load geographic coordinates 
insheet using `geo', clear
tostring geoid, replace format("%11.0f")

if "`keepifnumlist'"!="" foreach element of numlist `keepifnumlist' {
	local keepiflist = `"`keepiflist'"' + `""`element'""' + ", " //Construct a list of strings from the numlist
}
local keepiflist = substr(`"`keepiflist'"',1,length(`"`keepiflist'"')-2) //Drop the final unnecessary comma
if "`keepifnumlist'"!="" keep if inlist(substr(geoid,1,5),`keepiflist')==1 
rename (geoid intptlat intptlong) (i lat_i lon_i)
keep i lat_i lon_i

//Create all possible pairs 
tempfile tf_i
save `tf_i'
rename (i lat_i lon_i) (j lat_j lon_j)
cross using `tf_i'
geodist lat_i lon_i lat_j lon_j, gen(dist_ij)
drop lat_i lon_i lat_j lon_j

/* 
//Distance covariates
gen dist_log_ij = log(dist_ij)
label var dist_log_ij "Distance (log)"
assert dist_ij==0 if missing(dist_log_ij)==1
 */

label var i "Tract of residence (11-digit FIPS)"
label var j "Tract of workplace (11-digit FIPS)"
label var dist_ij "Distance between i and j (geodesic distance between centroids)"
compress

if "`saveasfile'"!="" save_data "`saveasfile'", key(i j) replace log_replace

end
