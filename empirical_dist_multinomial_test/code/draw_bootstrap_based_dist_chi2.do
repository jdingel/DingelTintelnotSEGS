clear

set scheme s2color

****** Helper Function to Rename variables ******

capture program drop clean_outputs
program define clean_outputs
	import delimited "`1'", clear
	
	local pos1 = strpos("`1'","dist_") + 5
	local pos2 = strpos("`1'",".csv")
	local temp = substr("`1'", `pos1',`pos2'-`pos1')   // partial out the model name
	
	rename pcentile_value pcentile_value_`temp'
	rename stat_value_lodes stat_value_lodes_`temp'
	
	local output_fname = "`1'" + ".dta"
	
	save `output_fname', replace
end


**************
* Clean Data *
**************
clean_outputs "`1'"
clean_outputs "`2'"
clean_outputs "`3'"
clean_outputs "`4'"


use "`1'.dta", clear
merge 1:1 pcentile using "`2'.dta",  assert(match) nogen
merge 1:1 pcentile using "`3'.dta",  assert(match) nogen
merge 1:1 pcentile using "`4'.dta",  assert(match) nogen


**************
* Visualization *
**************

twoway (kdensity pcentile_value_cbmfit, xlabel(,format(%3.2f)) lpattern(longdash) xtitle("") color(blue) legend(label(1 "CBM")) kernel(epanechnikov)) ///
       (kdensity pcentile_value_ifefit_1, xlabel(,format(%3.2f)) lpattern(solid) xtitle("") color(red%75) legend(label(2 "IFE R1") region(lc(none) fc(none)))) ///
	   (kdensity pcentile_value_ifefit_2, xlabel(,format(%3.2f)) lpattern(dash_dot) xtitle("") color(red%75) legend(label(3 "IFE R2"))) ///
	   (kdensity pcentile_value_ifefit_3, xlabel(,format(%3.2f)) lpattern(longdash) xtitle("")  color(red%75) legend(label(4 "IFE R3"))), ///
	   graphregion(color(white)) title("") legend(rows(2) order(1 2 3 4))

graph export "`5'", as(eps) name("Graph") preview(off) replace fontface(Times)

rm "`1'.dta"
rm "`2'.dta"
rm "`3'.dta"
rm "`4'.dta"