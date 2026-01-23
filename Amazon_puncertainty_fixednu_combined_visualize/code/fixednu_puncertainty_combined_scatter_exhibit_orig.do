clear all

set scheme s2color

graph set window fontface "Garamond"
graph set eps fontface "Times" 

import delimited using "../input/simulation_distribution_orig_sigma_4.0.csv", clear
keep id d_res_p95 d_res_p5 d_res_mean d_real_rent_ratio_p95 d_real_rent_ratio_p5 d_real_rent_ratio_mean
// add _fixednu to end of all variable names
foreach var of varlist d_* {
    rename `var' `var'_fixednu
}
tempfile fixednu
save `fixednu'

import delimited using "../input/cont_rent_puncertainty_pctile.csv", clear
gen id = _n
keep id i rent_change_mean rent_change_p5 rent_change_p95
foreach var of varlist rent_change_* {
    rename `var' `var'_bootstrap
}
merge 1:1 id using `fixednu', assert(match) nogen
// plot fixednu 95th percentile vs fixednu mean, and bootstrap 95th percentile vs bootstrap mean and same for 5th percentile for both with scatterplots
twoway  (scatter d_real_rent_ratio_p95_fixednu d_real_rent_ratio_mean_fixednu , msymbol(Dh) msize(tiny) mcolor(blue)) ///
        (scatter d_real_rent_ratio_p5_fixednu d_real_rent_ratio_mean_fixednu , msymbol(Th) msize(tiny) mcolor(red)) ///
        (scatter rent_change_p95_bootstrap rent_change_mean_bootstrap, msymbol(Sh) msize(tiny) mcolor(black)) ///
        (scatter rent_change_p5_bootstrap rent_change_mean_bootstrap, msymbol(Oh) msize(tiny) mcolor(purple)) ///
        (scatter d_real_rent_ratio_p95_fixednu d_real_rent_ratio_mean_fixednu if d_real_rent_ratio_mean==. , msymbol(Dh) msize(large) mcolor(blue)) ///
        (scatter d_real_rent_ratio_p5_fixednu d_real_rent_ratio_mean_fixednu if d_real_rent_ratio_mean==. , msymbol(Th) msize(large) mcolor(red)) ///
        (scatter rent_change_p95_bootstrap rent_change_mean_bootstrap if d_real_rent_ratio_mean==., msymbol(Sh) msize(large) mcolor(black)) ///
        (scatter rent_change_p5_bootstrap rent_change_mean_bootstrap if d_real_rent_ratio_mean==., msymbol(Oh) msize(large) mcolor(purple)), ///
        graphregion(color(white))  ///
        legend(size(med) region(lstyle(none) lcolor(white)) order(5 6 7 8) label(5 "Idiosyncrasies 95th percentile") label(6 "Idiosyncrasies 5th percentile") label(7 "Parameter uncertainty 95th pctile") label(8 "Parameter uncertainty 5th pctile")) ///
        xtitle("Mean percent change in rent", size(medlarge)) ytitle("Percent change",size(medlarge))  ///
        ylabel(,labsize(medlarge) gmax) xlabel(, format(%3.1f) labsize(medlarge))
graph export "../output/fixednu_puncertainty_scatter_rent.eps", replace

tempfile rent
save `rent'
import delimited using "../input/cont_res_puncertainty_pctile.csv", clear
sort i
gen id = _n
keep id i res_change_mean res_change_p5 res_change_p95
foreach var of varlist res_change_* {
    rename `var' `var'_bootstrap
}
merge 1:1 id using `fixednu', assert(match) nogen
// plot fixednu 95th percentile vs fixednu mean, and bootstrap 95th percentile vs bootstrap mean and same for 5th percentile for both with scatterplots
twoway  (scatter d_res_p95_fixednu d_res_mean_fixednu , msymbol(Dh) msize(tiny) mcolor(blue)) ///
        (scatter d_res_p5_fixednu d_res_mean_fixednu , msymbol(Th) msize(tiny) mcolor(red)) ///
        (scatter res_change_p95_bootstrap res_change_mean_bootstrap, msymbol(Sh) msize(tiny) mcolor(black)) ///
        (scatter res_change_p5_bootstrap res_change_mean_bootstrap, msymbol(Oh) msize(tiny) mcolor(purple)) ///
        (scatter d_res_p95_fixednu d_res_mean_fixednu if d_res_mean==. , msymbol(Dh) msize(large) mcolor(blue)) ///
        (scatter d_res_p5_fixednu d_res_mean_fixednu if d_res_mean==. , msymbol(Th) msize(large) mcolor(red)) ///
        (scatter res_change_p95_bootstrap res_change_mean_bootstrap if d_res_mean==., msymbol(Sh) msize(large) mcolor(black)) ///
        (scatter res_change_p5_bootstrap res_change_mean_bootstrap if d_res_mean==., msymbol(Oh) msize(large) mcolor(purple)), ///
        graphregion(color(white))  ///
        legend(size(med) region(lstyle(none) lcolor(white)) order(5 6 7 8) label(5 "Idiosyncrasies 95th percentile") label(6 "Idiosyncrasies 5th percentile") label(7 "Parameter uncertainty 95th pctile") label(8 "Parameter uncertainty 5th pctile")) ///
        xtitle("Mean change in the number of residents", size(medlarge)) ytitle("Change in residents",size(medlarge))  ///
        ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/fixednu_puncertainty_scatter_res.eps", replace
