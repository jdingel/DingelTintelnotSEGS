clear all

set scheme s2color

graph set window fontface "Garamond"
graph set eps fontface "Times" 

local tract = "36081000700"

// prepare data
use "../input/nyc2010_lodes_wzero_wdelta.dta",clear
sum X_ij, d
local pop = `r(sum)'
tempfile LODES_df
save `LODES_df', replace 
keep j
sort j 
duplicates drop
gen id = _n
tempfile dest_tractID
save `dest_tractID', replace 

use `LODES_df', clear 
keep i 
sort i 
duplicates drop 
gen id = _n
tempfile origin_tractID
save `origin_tractID', replace

import delimited "../input/simulation_distribution_orig_sigma_`1'.csv",clear
merge 1:1 id using `origin_tractID', assert(match) nogen 
tempfile simulation_orig
save `simulation_orig'

gen winsor_d_real_rent_ratio_p95 = min(2000, d_real_rent_ratio_p95)
gen winsor_d_real_rent_ratio_p5 = max(-2000, d_real_rent_ratio_p5)
// Change in rents
twoway (scatter winsor_d_real_rent_ratio_p95 d_real_rent_ratio_mean, msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter winsor_d_real_rent_ratio_p5 d_real_rent_ratio_mean, msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter winsor_d_real_rent_ratio_p95 d_real_rent_ratio_mean if d_real_rent_ratio_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter winsor_d_real_rent_ratio_p5 d_real_rent_ratio_mean if d_real_rent_ratio_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean percent change in rent",size(medlarge)) ytitle("Percent change",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/temp.eps", replace
// rename output
shell mv "../output/temp.eps" "../output/scatter_gu_realr_simulation_fixednu_sumstats_diff_sigma_`1'.eps" // graph export is not compatible with decimal numbers in filenames

count if winsor_d_real_rent_ratio_p5 > 0
local realr_p5_pos = string(`r(N)')
file open myfile using "../output/report_gu_realr_fixednu_sigma_`1'.tex", write replace
file write myfile "`realr_p5_pos' out of 2160 origin tracts have a positive change in rents at the 5\textsuperscript{th} percentile."
file close myfile

// Change in the number of residents 
import delimited "../input/amazon_ctfl_tract_cbm_sigma_`1'_prob.csv", stringcols(1/2) clear
collapse (sum) prob*, by(i)
gen id = _n
merge m:1 id using `simulation_orig', assert(match) nogen

twoway (scatter d_res_p95 d_res_mean, msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter d_res_p5 d_res_mean, msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter d_res_p95 d_res_mean if d_res_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter d_res_p5 d_res_mean if d_res_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean change in the number of residents",size(medlarge)) ytitle("Change in residents",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/temp.eps", replace
// rename output
shell mv "../output/temp.eps" "../output/scatter_gu_res_simulation_fixednu_sumstats_diff_sigma_`1'.eps" // graph export is not compatible with decimal numbers in filenames

// Change in wages
import delimited "../input/simulation_distribution_dest_sigma_`1'.csv",clear
merge 1:1 id using `dest_tractID', assert(match) nogen 
tempfile simulation_dest
save `simulation_dest'

twoway (scatter d_real_wage_ratio_p95 d_real_wage_ratio_mean if j!="`tract'", msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter d_real_wage_ratio_p5 d_real_wage_ratio_mean if j!="`tract'", msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter d_real_wage_ratio_p95 d_real_wage_ratio_mean if j!="`tract'"& d_real_wage_ratio_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter d_real_wage_ratio_p5 d_real_wage_ratio_mean if j!="`tract'"& d_real_wage_ratio_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean percent change in wage", size(medlarge)) ytitle("Percent change",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/temp.eps", replace
shell mv "../output/temp.eps" "../output/scatter_gu_realw_simulation_fixednu_sumstats_diff_sigma_`1'.eps" // graph export is not compatible with decimal numbers in filenames

count if d_real_wage_ratio_p5 > 0
local realw_p5_pos = string(`r(N)')
file open myfile using "../output/report_gu_realw_fixednu_sigma_`1'.tex", write replace
file write myfile "`realw_p5_pos' out of 2143 destination tracts have a positive change in wages at the 5\textsuperscript{th} percentile."
file close myfile


// Change in the number of workers
import delimited "../input/amazon_ctfl_tract_cbm_sigma_`1'_prob.csv", stringcols(1/2) clear
collapse (sum) prob*, by(j)
gen id = _n
merge m:1 id using `simulation_dest', assert(match) nogen
count if d_emp_mean < -1000
local outlier_count = `r(N)'
summarize d_emp_mean, d
local outlier = string(abs(round(`r(min)'),1), "%5.0fc")

twoway (scatter d_emp_p95 d_emp_mean if j!="`tract'" & d_emp_mean>-1000, msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter d_emp_p5 d_emp_mean if j!= "`tract'" & d_emp_mean>-1000, msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter d_emp_p95 d_emp_mean if j!= "`tract'" & d_emp_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter d_emp_p5 d_emp_mean if j!= "`tract'" & d_emp_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean change in the number of workers", size(medlarge)) ytitle("Change in workers",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/temp.eps", replace
shell mv "../output/temp.eps" "../output/scatter_gu_emp_simulation_fixednu_sumstats_diff_sigma_`1'.eps" // graph export is not compatible with decimal numbers in filenames

if `outlier_count' == 1 {
	file open myfile using "../output/outlier_note_gu_emp_fixednu_sigma_`1'.tex", write replace
	file write myfile "one outlier with an employment decline of `outlier' is not depicted"
	file close myfile
} 
else {
	file open myfile using "../output/outlier_note_gu_emp_fixednu_sigma_`1'.tex", write replace
	file write myfile "`outlier_count' outliers with employment declines greater than 1,000 are not depicted"
	file close myfile
}

count if j!="`tract'"
local emp_tract_count = string(`r(N)')
count if d_emp_p5 < 0 & d_emp_p95 > 0 & j!="`tract'"
local emp_signif = string(`r(N)')
file open myfile using "../output/report_gu_emp_fixednu_sigma_`1'.tex", write replace
file write myfile "the 90\% confidence interval for the change in employment includes zero for `emp_signif' of the `emp_tract_count' non-Amazon workplaces."
file close myfile