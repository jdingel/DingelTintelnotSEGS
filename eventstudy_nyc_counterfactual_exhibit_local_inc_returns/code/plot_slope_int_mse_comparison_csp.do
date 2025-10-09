clear all

set scheme s2color
graph set window fontface "Garamond"
graph set eps fontface "Times" 
import delimited using "../input/slope_int_MSE_all_csp_sigma_4.0.csv", clear
gen slope_csp = slope
gen int_csp = int
gen mse_csp = mse
keep j slope_csp int_csp mse_csp
tempfile temp
save `temp'

import delimited using "../input/slope_int_MSE_all_csp_eta_`1'.csv", clear
gen slope_linc = slope
gen int_linc = int
gen mse_linc = mse
keep j slope_linc int_linc mse_linc
merge 1:1 j using `temp', assert(using match) nogen

twoway (scatter slope_linc slope_csp, mcolor(black)) ///
		(lfit slope_csp slope_csp, color(red) lpattern(dash)), ///
		graphregion(color(white)) xlabel(,labsize(*1.5)) ylabel(,labsize(*1.5)) ///
            ytitle("Slope coef. for CSP predictions when {&eta} = `1'") ///
            xtitle("Slope coef. for CSP predictions when {&eta} = 0") ///
		legend(lab(1 "Slope") lab(2 "45 Degree Line"))
graph export "../output/slope_eta_`1'_csp_comparison_scatterplot.eps", replace as(eps)

reg slope_csp slope_linc
outreg2 using "../output/slope_eta_`1'_csp_comparison_regression.txt", replace

twoway (scatter int_linc int_csp, mcolor(black)) ///
		(lfit int_csp int_csp, color(red) lpattern(dash)), ///
		graphregion(color(white)) xlabel(,labsize(*1.5)) ylabel(,labsize(*1.5)) ///
            ytitle("Intercept for CSP predictions when {&eta} = `1'") ///
            xtitle("Intercept for CSP predictions when {&eta} = 0") ///
		legend(lab(1 "Intercept") lab(2 "45 Degree Line"))
graph export "../output/int_eta_`1'_csp_comparison_scatterplot.eps", replace as(eps)

twoway (scatter mse_linc mse_csp, mcolor(black)) ///
		(lfit mse_csp mse_csp, color(red) lpattern(dash)), ///
		graphregion(color(white)) xlabel(,labsize(*1.5)) ylabel(,labsize(*1.5)) ///
        ytitle("MSE for CSP predictions when {&eta} = `1'") ///
        xtitle("MSE for CSP predictions when {&eta} = 0") ///
		legend(lab(1 "MSE") lab(2 "45 Degree Line"))
graph export "../output/mse_eta_`1'_csp_comparison_scatterplot.eps", replace as(eps)