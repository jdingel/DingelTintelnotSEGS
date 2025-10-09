clear all

set scheme s2color
graph set window fontface "Garamond"
graph set eps fontface "Times" 
import delimited using "../input/slope_int_MSE_all_csp_sigma_`1'.csv", clear
gen slope_1 = slope
gen int_1 = int
gen mse_1 = mse
keep j slope_1 int_1 mse_1
tempfile temp
save `temp'

import delimited using "../input/slope_int_MSE_all_csp_sigma_`2'.csv", clear
gen slope_2 = slope
gen int_2 = int
gen mse_2 = mse
keep j slope_2 int_2 mse_2
merge 1:1 j using `temp', assert(using match) nogen

twoway (scatter slope_1 slope_2, mcolor(black)) ///
		(lfit slope_1 slope_1, color(red) lpattern(dash)), ///
		graphregion(color(white)) xlabel(,labsize(*1.5)) ylabel(,labsize(*1.5)) xtitle("Slope coefficient for calibrated-shares predictions when sigma = `2'") ytitle("Slope coefficient for CSP predictions when sigma = `1'") ///
		legend(lab(1 "Slope") lab(2 "45 Degree Line"))
graph export "../output/slope_`1'_`2'_comparison_scatterplot.eps", replace as(eps)

twoway (scatter int_1 int_2, mcolor(black)) ///
		(lfit int_1 int_1, color(red) lpattern(dash)), ///
		graphregion(color(white)) xlabel(,labsize(*1.5)) ylabel(,labsize(*1.5)) xtitle("Intercept for calibrated-shares predictions when sigma = `2'") ytitle("Intercept for CSP predictions when sigma = `1'") ///
		legend(lab(1 "Intercept") lab(2 "45 Degree Line"))
graph export "../output/int_`1'_`2'_comparison_scatterplot.eps", replace as(eps)

twoway (scatter mse_1 mse_2, mcolor(black)) ///
		(lfit mse_1 mse_1, color(red) lpattern(dash)), ///
		graphregion(color(white)) xlabel(,labsize(*1.5)) ylabel(,labsize(*1.5)) xtitle("MSE for calibrated-shares predictions when sigma = `2'") ytitle("MSE for CSP predictions when sigma = `1'") ///
		legend(lab(1 "MSE") lab(2 "45 Degree Line"))
graph export "../output/mse_`1'_`2'_comparison_scatterplot.eps", replace as(eps)