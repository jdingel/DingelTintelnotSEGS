clear all

do "../input/nyc_delta.do"
do "programs.do"

// prepare delta as a function of transit time
foreach i of numlist 2010 {
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

