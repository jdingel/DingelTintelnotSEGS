clear all

set scheme s2color

import delimited using "../temp/jensen_simulation_compiled_w_sigma_1.1.csv", clear varnames(1)
gen row_id = _n
rename real_w_mean real_w_mean_1
rename real_w_cont real_w_cont_1
tempfile temp
save `temp'

import delimited using "../temp/jensen_simulation_compiled_w_sigma_4.0.csv", clear
gen row_id = _n
rename real_w_mean real_w_mean_4
rename real_w_cont real_w_cont_4

merge 1:1 row_id using `temp', assert(match) nogen

gen dev_CCRE_wage_mean_1 = abs(real_w_mean_1-real_w_cont_1)*100/real_w_cont_1
gen dev_CCRE_wage_mean_4 = abs(real_w_mean_4-real_w_cont_4)*100/real_w_cont_4
//create density plot of wage deviations 
twoway (kdensity dev_CCRE_wage_mean_1, lcolor(black) lpattern(solid)) ///
       (kdensity dev_CCRE_wage_mean_4, lcolor(black) lpattern(dash)) ///
        ,  graphregion(color(white)) xtitle("Percent deviation from continuum real wages") ytitle("Density") legend(region(lstyle(none)) region(fcolor(none)) label(1 "{&sigma} = 1.1") label(2 "{&sigma} = 4.0"))
graph export "../output/wage_deviation_density.eps", replace

// create dev_CCRE_wage_mean_cutoff variable where all values above 5 are set to 5
gen dev_CCRE_wage_mean_1_cutoff = dev_CCRE_wage_mean_1
replace dev_CCRE_wage_mean_1_cutoff = 5 if dev_CCRE_wage_mean_1_cutoff > 5
gen dev_CCRE_wage_mean_4_cutoff = dev_CCRE_wage_mean_4
replace dev_CCRE_wage_mean_4_cutoff = 5 if dev_CCRE_wage_mean_4_cutoff > 5
// create density plot of wage deviations
twoway (kdensity dev_CCRE_wage_mean_1_cutoff, lcolor(black) lpattern(solid)) ///
       (kdensity dev_CCRE_wage_mean_4_cutoff, lcolor(black) lpattern(dash)) ///
        , graphregion(color(white)) xtitle("Percent deviation from continuum real wages") ytitle("Density") legend(region(lstyle(none)) region(fcolor(none)) label(1 "{&sigma} = 1.1") label(2 "{&sigma} = 4.0"))
graph export "../output/wage_deviation_density_winsorized.eps", replace