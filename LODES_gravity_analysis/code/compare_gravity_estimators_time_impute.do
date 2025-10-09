
set scheme s2color
// 1. delta as a function of transit time,
// 2. impute observations with missing transit time based on distance
clear all

foreach package in outreg2 reghdfe {
    capture which `package'
    if _rc==111 ssc install `package'
}

assert inlist("`1'","NYC","DetroitUA")
assert inlist(`2',2010,2014)

if "`1'"=="NYC" local location="NYC (`2')" 
if "`1'"=="DetroitUA" local location="Detroit (`2')" 


// prepare data
use "../input/`1'_delta_LODES`2'.dta",clear
gen X_log_ij = log(X_ij)
clonevar x_temp = log_delta
label var x_temp "Commuting cost"

//Impose ORS 2019 manipulation on X_log_ij with X_ij = 10e-12 * X_jj if X_jj!=0
bys j: egen X_j = total(X_ij) 
by  j: egen ownshare = max((X_ij / X_j) * (i==j))
gen X_log_ij_ORS = X_log_ij
replace X_log_ij_ORS = ln(10e-12 * ownshare) if X_ij==0 & missing(X_log_ij_ORS)==1
gen X_ij_ORS = exp(X_log_ij_ORS)

// Compare gravity estimators
//PPML
ppmlhdfe X_ij x_temp, absorb(fe_i_ppml=i fe_j_ppml=j) vce(cluster i j)
local pseudo_r2 = `e(r2_p)'
local num_location = string(`e(N_full)',"%12.0gc")
qui summarize X_ij if e(sample)==1
local num_commuters =  string(`r(sum)',"%12.0gc")
outreg2 using "../output/`1'_`2'_gravity_time_impute.tex", replace tex(frag) ctitle(MLE) noaster nocons label ///
	addstat(R-squared,`pseudo_r2') ///
	addtext("Location pairs","`num_location'","Commuters","`num_commuters'")
//PPML for non-zero obs
ppmlhdfe X_ij x_temp  if X_ij!=0, absorb(i j) vce(cluster i j) d
local pseudo_r2_nonzero = `e(r2_p)'
local num_location_nz = string(`e(N_full)',"%12.0gc")
qui summarize X_ij if X_ij!=0 //there are observations in which a destination tract has only one employee. Thus, it has only one observation, and the destination fixed effect explains it entirely, so Stata drops it from the estimation sample. e(sample)==0 for observations in which X_ij!=0.
local num_commuters_nz =  string(`r(sum)',"%12.0gc")
outreg2 using "../output/`1'_`2'_gravity_time_impute.tex", append tex(frag) ctitle(MLE non-zero) noaster nocons label ///
	addstat(R-squared,`pseudo_r2_nonzero') ///
	addtext("Location pairs","`num_location_nz'","Commuters","`num_commuters_nz'")
//OLS on non-zero observations
reghdfe X_log_ij x_temp if X_ij!=0, absorb(fe_i_ols=i fe_j_ols=j) vce(cluster i j) residuals(resOLS)
local num_location_ols = string(`e(N_full)',"%12.0gc")
qui summarize X_ij if X_ij!=0 //there are observations in which a destination tract has only one employee. Thus, it has only one observation, and the destination fixed effect explains it entirely, so Stata drops it from the estimation sample. e(sample)==0 for observations in which X_ij!=0.
local num_commuters_ols =  string(`r(sum)',"%12.0gc")
outreg2 using "../output/`1'_`2'_gravity_time_impute.tex", append tex(frag) ctitle(OLS non-zero) noaster nocons label ///
	addtext("Location pairs","`num_location_ols'","Commuters","`num_commuters_ols'")
//ORS 2019 recoding
reghdfe X_log_ij_ORS x_temp, absorb(i j) vce(cluster i j)
local num_location_ors = string(`e(N_full)',"%12.0gc")
qui summarize X_ij_ORS
local num_commuters_ors =  string(`r(sum)',"%12.0gc")
outreg2 using "../output/`1'_`2'_gravity_time_impute.tex", append tex(frag) ctitle(OLS recode) noaster nocons label ///
	addtext("Location pairs","`num_location_ors'","Commuters","`num_commuters_ors'")
tempfile df
save `df'

// Scatterplot of OLS dropping zeros destination FEs vs PPML [including zeros] destination FEs 
collapse (firstnm) fe_j_ols fe_j_ppml, by(j)
foreach var of varlist fe* {
	sum `var',d
	gen `var'_norm = `var'-`r(mean)'
}
scatter fe_j_ols_norm fe_j_ppml_norm, /// 
	graphregion(color(white)) title("`location'",size(vlarge)) xtitle("MLE destination FE",size(vlarge)) ytitle("OLS (omit zeros) destination FE",size(vlarge)) ///
	xlabel(,labsize(vlarge)) ylabel(,labsize(vlarge)) msymbol(x) msize(vsmall)
graph export "../output/scatter_destFE_`1'_`2'_impute.eps", replace

// Scatterplot of OLS dropping zeros origin FEs vs PPML [including zeros] origin FEs 
use `df',clear
collapse (firstnm) fe_i_ols fe_i_ppml, by(i)
scatter fe_i_ols fe_i_ppml, /// 
	graphregion(color(white)) title("`location'",size(vlarge)) xtitle("MLE origin FE",size(vlarge)) ytitle("OLS (omit zeros) origin FE",size(vlarge)) ///
	xlabel(,labsize(vlarge)) ylabel(,labsize(vlarge)) msymbol(x) msize(vsmall)
graph export "../output/scatter_origFE_`1'_`2'_impute.eps", replace

//Clean up table
shell sed -i.bak 's/VARIABLES \& /\&/' "../output/`1'_`2'_gravity_time_impute.tex"
shell sed -i.bak 's/Robust standard errors/Standard errors, two-way clustered by k and n,/' "../output/`1'_`2'_gravity_time_impute.tex"
rm "../output/`1'_`2'_gravity_time_impute.tex.bak"
rm "../output/`1'_`2'_gravity_time_impute.txt"
