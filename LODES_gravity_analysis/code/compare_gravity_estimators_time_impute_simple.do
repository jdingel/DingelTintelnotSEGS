// 1. delta as a function of transit time,
// 2. impute observations with missing transit time based on distance
clear all

foreach package in outreg2 reghdfe {
    capture which `package'
    if _rc==111 ssc install `package'
}

cap program drop reg_table
cap program define reg_table
syntax, location(string) year(string) pos1(string)
// prepare data
use "../input/`location'_delta_LODES`year'.dta",clear
gen X_log_ij = log(X_ij)
clonevar x_temp = log_delta
label var x_temp "Commuting cost"

// Compare gravity estimators
//PPML
ppmlhdfe X_ij x_temp, absorb(fe_i_ppml=i fe_j_ppml=j) vce(cluster i j)
local pseudo_r2 = `e(r2_p)'
local num_location = string(`e(N_full)',"%12.0gc")
qui summarize X_ij if e(sample)==1
local num_commuters =  string(`r(sum)',"%12.0gc")
outreg2 using "../output/NYC2010_gravity_time_impute_simple.tex", `pos1' tex(frag) ctitle(PPML/MLE) noaster nocons label ///
	addstat(R-squared,`pseudo_r2') ///
	addtext("Location pairs","`num_location'","Commuters","`num_commuters'")

//OLS on non-zero observations
reghdfe X_log_ij x_temp if X_ij!=0, absorb(fe_i_ols=i fe_j_ols=j) vce(robust) residuals(resOLS)
local num_location_ols = string(`e(N_full)',"%12.0gc")
qui summarize X_ij if X_ij!=0 //there are observations in which a destination tract has only one employee. Thus, it has only one observation, and the destination fixed effect explains it entirely, so Stata drops it from the estimation sample. e(sample)==0 for observations in which X_ij!=0.
local num_commuters_ols =  string(`r(sum)',"%12.0gc")
outreg2 using "../output/NYC2010_gravity_time_impute_simple.tex", append tex(frag) ctitle(OLS) noaster nocons label ///
	addtext("Location pairs","`num_location_ols'","Commuters","`num_commuters_ols'")
end

//reg_table, location(DetroitUA) year(2014) pos1(replace)
reg_table, location(NYC) year(2010) pos1(replace)

//Clean up table
shell sed -i.bak 's/VARIABLES \& /\&/' "../output/NYC2010_gravity_time_impute_simple.tex"
rm "../output/NYC2010_gravity_time_impute_simple.tex.bak"
rm "../output/NYC2010_gravity_time_impute_simple.txt"
