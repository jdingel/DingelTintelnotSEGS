clear all

set scheme s2color

graph set window fontface "Garamond"
graph set eps fontface "Times" 

import delimited using "../input/simulation_distribution_dest_sigma_4.0.csv", clear
keep id d_emp_p95 d_emp_p5 d_emp_mean d_real_wage_ratio_p95 d_real_wage_ratio_p5 d_real_wage_ratio_mean
// add _fixednu to end of all variable names
foreach var of varlist d_* {
    rename `var' `var'_fixednu
}
tempfile fixednu
save `fixednu'

import delimited using "../input/cont_wage_puncertainty_pctile.csv", clear
gen id = _n
keep id geoid11 wage_change_mean wage_change_p5 wage_change_p95
foreach var of varlist wage_change_* {
    rename `var' `var'_bootstrap
}
merge 1:1 id using `fixednu', assert(match) nogen
local tract = 36081000700
drop if geoid11 == `tract'
// plot fixednu 95th percentile vs fixednu mean, and bootstrap 95th percentile vs bootstrap mean and same for 5th percentile for both with scatterplots
twoway  (scatter d_real_wage_ratio_p95_fixednu d_real_wage_ratio_mean_fixednu , msymbol(Dh) msize(tiny) mcolor(blue)) ///
        (scatter d_real_wage_ratio_p5_fixednu d_real_wage_ratio_mean_fixednu , msymbol(Th) msize(tiny) mcolor(red)) ///
        (scatter wage_change_p95_bootstrap wage_change_mean_bootstrap, msymbol(Sh) msize(tiny) mcolor(black)) ///
        (scatter wage_change_p5_bootstrap wage_change_mean_bootstrap, msymbol(Oh) msize(tiny) mcolor(purple)) ///
        (scatter d_real_wage_ratio_p95_fixednu d_real_wage_ratio_mean_fixednu if d_real_wage_ratio_mean==. , msymbol(Dh) msize(large) mcolor(blue)) ///
        (scatter d_real_wage_ratio_p5_fixednu d_real_wage_ratio_mean_fixednu if d_real_wage_ratio_mean==. , msymbol(Th) msize(large) mcolor(red)) ///
        (scatter wage_change_p95_bootstrap wage_change_mean_bootstrap if d_real_wage_ratio_mean==., msymbol(Sh) msize(large) mcolor(black)) ///
        (scatter wage_change_p5_bootstrap wage_change_mean_bootstrap if d_real_wage_ratio_mean==., msymbol(Oh) msize(large) mcolor(purple)), ///
        graphregion(color(white))  ///
        legend(size(med) region(lstyle(none) lcolor(white)) order(5 6 7 8) label(5 "Idiosyncrasies 95th percentile") label(6 "Idiosyncrasies 5th percentile") label(7 "Parameter uncertainty 95th pctile") label(8 "Parameter uncertainty 5th pctile")) ///
        xtitle("Mean percent change in wage", size(medlarge)) ytitle("Percent change",size(medlarge))  ///
        ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/fixednu_puncertainty_scatter_wage.eps", replace

tempfile wage
save `wage'
import delimited using "../input/cont_emp_puncertainty_pctile.csv", clear
// sort by j
sort j
gen id = _n
keep id j emp_change_mean emp_change_p5 emp_change_p95
foreach var of varlist emp_change_* {
    rename `var' `var'_bootstrap
}
merge 1:1 id using `fixednu', assert(match) nogen
drop if j == `tract'
drop if emp_change_mean_bootstrap < -1000
drop if d_emp_mean_fixednu < -1000
// plot fixednu 95th percentile vs fixednu mean, and bootstrap 95th percentile vs bootstrap mean and same for 5th percentile for both with scatterplots
twoway  (scatter d_emp_p95_fixednu d_emp_mean_fixednu , msymbol(Dh) msize(tiny) mcolor(blue)) ///
        (scatter d_emp_p5_fixednu d_emp_mean_fixednu , msymbol(Th) msize(tiny) mcolor(red)) ///
        (scatter emp_change_p95_bootstrap emp_change_mean_bootstrap, msymbol(Sh) msize(tiny) mcolor(black)) ///
        (scatter emp_change_p5_bootstrap emp_change_mean_bootstrap, msymbol(Oh) msize(tiny) mcolor(purple)) ///
        (scatter d_emp_p95_fixednu d_emp_mean_fixednu if d_emp_mean==. , msymbol(Dh) msize(large) mcolor(blue)) ///
        (scatter d_emp_p5_fixednu d_emp_mean_fixednu if d_emp_mean==. , msymbol(Th) msize(large) mcolor(red)) ///
        (scatter emp_change_p95_bootstrap emp_change_mean_bootstrap if d_emp_mean==., msymbol(Sh) msize(large) mcolor(black)) ///
        (scatter emp_change_p5_bootstrap emp_change_mean_bootstrap if d_emp_mean==., msymbol(Oh) msize(large) mcolor(purple)), ///
        graphregion(color(white))  ///
        legend(size(med) region(lstyle(none) lcolor(white)) order(5 6 7 8) label(5 "Idiosyncracies 95th percentile") label(6 "Idiosyncracies 5th percentile") label(7 "Parameter uncertainty 95th pctile") label(8 "Parameter uncertainty 5th pctile")) ///
        xtitle("Mean change in the number of workers", size(medlarge)) ytitle("Change in workers",size(medlarge))  ///
        ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/fixednu_puncertainty_scatter_emp.eps", replace
