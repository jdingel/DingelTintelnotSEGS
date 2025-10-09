clear all

set scheme s2color

// summarize MSE
graph set window fontface "Garamond"
graph set eps fontface "Times"

import delimited using "../output/MSE_MAE_values_NTA.txt", clear
confirm var tract criterion csp cbm cbm_deltainf
rename (tract criterion csp cbm cbm_deltainf) (tract criterion cs cont cont_infzero)
replace criterion = trim(criterion)
keep if criterion=="MSE"
qui sum cont, detail
local median_MSE_cbm = string(`r(p50)',"%3.2f")
file open median_MSE_cbm using "../output/median_MSE_cbm_NTA_aggregated.txt", write replace
file write median_MSE_cbm "`median_MSE_cbm'"
file close median_MSE_cbm
qui sum cs, detail
local median_MSE_cs = string(`r(p50)',"%3.2f")
file open median_MSE_cs using "../output/median_MSE_csp_NTA_aggregated.txt", write replace
file write median_MSE_cs "`median_MSE_cs'"
file close median_MSE_cs
gen MSE_cont_cs = cont / cs
sum MSE_cont_cs, detail 
local MSE_cont_cs_start = floor(`r(min)' * 10) / 10
twoway (hist MSE_cont_cs, lcolor(black) fcolor(none) start(`MSE_cont_cs_start') width(0.10) fraction), graphregion(color(white)) xlabel(#9, labsize(large)) ylabel(,labsize(large)) ytitle(,size(medlarge)) xtitle("Covariates-based MSE / Calibrated-shares MSE", size(large)) ytitle(,size(large)) legend(off)
graph export "../output/MSE_histogram_cont_cs_NTA.eps", replace

// summarize slope 
import delimited using "../output/slopes_intercepts_NTA.txt", clear
confirm var tract coefficient csp cbm cbm_deltainf
duplicates drop
rename (tract coefficient csp cbm cbm_deltainf) (tract coefficient cs cont cont_infzero)
replace coefficient = trim(coefficient)
replace coefficient = subinstr(coefficient,"Predicted change","slope",1)
replace coefficient = subinstr(coefficient,"Constant","intercept",1)
tostring tract, replace format("%17.0f")

qui sum cont if coefficient=="slope",d
local median_g = `r(p50)'
qui sum cs if coefficient=="slope", d
local median_cs = `r(p50)'

twoway 	(kdensity cont if coefficient=="slope", xline(`median_g',lcolor(blue) lwidth(vthin)) lcol(blue) ) ///
		(kdensity cs if coefficient=="slope", xline(`median_cs',lcolor(red) lwidth(vthin)) lcol(red)) ///
		, graphregion(color(white)) legend(region(lstyle(none)) label(1 "Covariates-based")  label(2 "Calibrated-shares") ) ///
		legend(pos(11) ring(0) col(1) size(medium) region(fcolor(none))) ///
		ytitle("Density",size(vlarge)) xlabel(, labsize(large)) ylabel(0(0.5)2,gmax labsize(large)) xtitle("") xsize(`fig_size')
graph export "../output/density_slope_NTA_cont_cs.eps", replace

twoway 	(kdensity cont if coefficient=="slope", xline(`median_g',lcolor(blue) lwidth(vthin)) lcol(blue) ) ///
		(kdensity cs if coefficient=="slope", xline(`median_cs',lcolor(red) lwidth(vthin)) lcol(red)) ///
		, graphregion(color(white)) legend(region(lstyle(none)) label(1 "Covariates-based")  label(2 "Calibrated-shares") ) ///
		legend(pos(11) ring(0) col(1) size(medium) region(fcolor(none))) ///
		xtitle("Slope",size(vlarge)) ytitle("Density",size(vlarge)) xlabel(, labsize(large)) ylabel(0(0.5)2,gmax labsize(large)) xsize(`fig_size')
graph export "../output/density_slope_NTA_cont_cs_slides.eps", replace

// summarize slope
twoway 	(kdensity cont if coefficient=="intercept", lcol(blue) lpattern(dash)) ///
		(kdensity cs if coefficient=="intercept", lcol(red) lpattern(dash)) ///
		, graphregion(color(white)) legend(region(lstyle(none)) label(1 "Covariates-based") label(2 "Calibrated-shares")) ///
		legend(pos(11) ring(0) col(1) size(medium) region(fcolor(none))) ///
		ytitle("Density",size(vlarge)) xlabel(, labsize(large)) ylabel(,gmax labsize(large))  xtitle("") xsize(`fig_size')
graph export "../output/density_intercept_NTA_cont_cs.eps", replace
