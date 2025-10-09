clear all

local tract =  "36081000700"

// Prepare data
// distance data
import delimited "../input/2015_gaz_tracts_36.txt",clear
tostring geoid, replace format("%11.0f")
keep if inlist(substr(geoid,1,5),"36005","36047","36061","36081","36085")==1
rename (geoid intptlat intptlong) (i lat_i lon_i)
keep i lat_i lon_i

tempfile tf_i
save `tf_i'
rename (i lat_i lon_i) (j lat_j lon_j)
cross using `tf_i'
geodist lat_i lon_i lat_j lon_j, gen(dist_ij)
drop lat_i lon_i lat_j lon_j

keep if j=="`tract'"
keep i dist_ij
sort i
label var i "Tract of residence (11-digit FIPS)"
label var dist_ij "Distance between tract i and tract 36081000700 (km)"
save_data "../output/NYC_dist_to_treated.dta", key(i) replace log_replace

