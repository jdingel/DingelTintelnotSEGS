clear all

set scheme s2color

//1. 2010--2012 change in employment in the census tract in New York City that contains 200 Fifth Avenue. [36061005800]
//2. the tract containing 111 Eighth Avenue, a large building that Google acquired during 2010--2012 [36061008300]
local tract_Tiffany = "36061005800"
local tract_Google = "36061008300"

tempfile tf_collect

forvalues yr=2002/2017 {
use "../input/lodes_NYC_`yr'.dta", clear
collapse (sum) employment = X_ij, by(j)
gen int year = `yr'
cap confirm file `tf_collect'
if _rc==0 append using `tf_collect'
save `tf_collect', replace
}
label variable employment "Employees in workplace tract"

keep if inlist(j,"`tract_Tiffany'","`tract_Google'")==1
gen year_short = year - 2000
label variable year_short "Year (2000s)"
gen employment_k = employment / 1000
label variable employment_k "Employment (000s)"

twoway (connected employment_k year_short if j=="`tract_Tiffany'", xline(10, lpattern(dash)) xline(12, lpattern(dash)) yscale(range(0)) xlabel(#16)), graphregion(color(white)) ///
	title("Tract containing 200 Fifth Avenue", color(black)) name(tiffany, replace)
graph export "../output/tract_employmentcountsOD_`tract_Tiffany'.eps", replace
twoway (connected employment_k year_short if j=="`tract_Google'", xline(10, lpattern(dash)) xline(12, lpattern(dash)) yscale(range(0)) xlabel(#16)), graphregion(color(white)) ///
	title("Tract containing 111 Eighth Avenue", color(black)) name(google, replace)
graph export "../output/tract_employmentcountsOD_`tract_Google'.eps", replace
shell echo This figure depicts the number of primary jobs held by New York City residents in tracts `tract_Tiffany' and `tract_Google' in the LODES data.% > ../output/tract_employmentcountsOD_notes.tex
