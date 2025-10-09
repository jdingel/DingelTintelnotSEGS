clear all

do "../input/nyc_delta.do"
do "programs.do"

// prepare delta as a function of transit time
foreach i of numlist 2010 2012 2013 2014 {
	use "../input/lodes_NYC_`i'.dta",clear
	fillin i j
	recode X_ij .=0
	drop _fillin
	tempfile df`i'
	save `df`i''

	nyc_delta,df_commute(`df`i'') keepifnumlist("36005,36047,36061,36081,36085") ///
				mi_obs_tex("../output/NYC_`i'_times_imputed.tex") ///
				output("../output/NYC_delta_LODES`i'.dta")
}


// prepare distance as covariate
merge_geocoords, geo("../input/2015_gaz_tracts_36.txt") ///
					keepifnumlist("36005,36047,36061,36081,36085") ///
					saveasfile("../output/NYC_dist_covariates.dta")


// prepare pooled data
tempfile tf_lodes_NYC
pool_LODES_years, usingstem("../input/lodes_NYC_") usingsuffix(".dta") firstyear(2009) lastyear(2014) saveasfile(`tf_lodes_NYC')

use `tf_lodes_NYC', clear
gen X_ij_pooled = (1/5) * (X_ij_2009 + X_ij_2010 + X_ij_2011 + X_ij_2012 + X_ij_2013)
keep i j X_ij_pooled X_ij_2013 X_ij_2014
label var i "Tract of residence (11-digit FIPS)"
label var j "Tract of workplace (11-digit FIPS)"
label var X_ij_pooled "Number of commuters residing in i and working in j pooled from 2009 to 2013"
label var X_ij_2013 "Number of commuters residing in i and working in j in 2013"
label var X_ij_2014 "Number of commuters residing in i and working in j in 2014"
compress
save_data "../output/NYC_LODES_pooled.dta", key(i j) replace log_replace
