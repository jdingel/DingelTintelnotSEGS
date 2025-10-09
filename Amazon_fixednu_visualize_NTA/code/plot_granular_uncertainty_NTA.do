clear all

set scheme s2color

graph set window fontface "Garamond"
graph set eps fontface "Times" 

local treated_NTA = "QN31"      // Hunters Point-Sunnyside-West Maspeth

// prepare data
use "../input/NTA_commutingflows_2010.dta",clear
sum X_ij, d
local pop = `r(sum)'
tempfile LODES_df
save `LODES_df', replace 
keep j
sort j 
duplicates drop
gen id = _n
tempfile dest_NTA
save `dest_NTA', replace 

use `LODES_df', clear 
keep i 
sort i 
duplicates drop 
gen id = _n
tempfile origin_NTA
save `origin_NTA', replace

import delimited "../input/simulation_distribution_orig_NTA.csv",clear
merge 1:1 id using `origin_NTA', assert(match) nogen 
tempfile simulation_orig
save `simulation_orig'

gen winsor_d_real_rent_ratio_p95 = min(2000, d_real_rent_ratio_p95)
gen winsor_d_real_rent_ratio_p5 = max(-2000, d_real_rent_ratio_p5)

egen d_real_r_ratio_mean_city = mean(d_real_rent_ratio_mean)
sum d_real_r_ratio_mean_city

local mean_temp = r(mean)
local pct_real_r_change_city_mean = round(`mean_temp', 0.01)

count if winsor_d_real_rent_ratio_p5 > d_real_r_ratio_mean_city
local sig_r_change_num_p5 = string(`r(N)')
file open myfile using "../output/report_gu_NTA_sigchange_realr_p5_wrt_city_mean.tex", write replace
file write myfile "`sig_r_change_num_p5' out of 195 origin NTAs have a change in rents at the 5\textsuperscript{th} percentile larger than the citywise mean change (`pct_real_r_change_city_mean')."
file close myfile


count if winsor_d_real_rent_ratio_p95 < d_real_r_ratio_mean_city
local sig_r_change_num_p95 = string(`r(N)')
file open myfile using "../output/report_gu_NTA_sigchange_realr_p95_wrt_city_mean.tex", write replace
file write myfile "`sig_r_change_num_p95' out of 195 origin NTAs have a change in rents at the 95\textsuperscript{th} percentile smaller than the citywise mean change."
file close myfile


// Change in rents
twoway (scatter winsor_d_real_rent_ratio_p95 d_real_rent_ratio_mean, msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter winsor_d_real_rent_ratio_p5 d_real_rent_ratio_mean, msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter winsor_d_real_rent_ratio_p95 d_real_rent_ratio_mean if d_real_rent_ratio_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter winsor_d_real_rent_ratio_p5 d_real_rent_ratio_mean if d_real_rent_ratio_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean percent change in rent",size(medlarge)) ytitle("Percent change",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/scatter_gu_realr_simulation_fixednu_sumstats_diff_NTA.eps", replace

count if winsor_d_real_rent_ratio_p5 > 0
local realr_p5_pos = string(`r(N)')
file open myfile using "../output/report_gu_realr_fixednu_NTA.tex", write replace
file write myfile "`realr_p5_pos' out of 195 origin NTAs have a positive change in rents at the 5\textsuperscript{th} percentile."
file close myfile

// Change in the number of residents 
twoway (scatter d_res_p95 d_res_mean, msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter d_res_p5 d_res_mean, msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter d_res_p95 d_res_mean if d_res_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter d_res_p5 d_res_mean if d_res_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean change in the number of residents",size(medlarge)) ytitle("Change in residents",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/scatter_gu_res_simulation_fixednu_NTA.eps", replace

count 
local res_NTA_count = string(`r(N)')
count if inrange(0, d_res_p5, d_res_p95)
local res_signif = string(`r(N)')
file open myfile using "../output/report_gu_res_sigfchange_fixednu_NTA.tex", write replace
file write myfile "the 90\% confidence interval for the change in residents includes zero for `res_signif' of the `res_NTA_count' NTAs."
file close myfile

// Change in wages
import delimited "../input/simulation_distribution_dest_NTA.csv",clear
merge 1:1 id using `dest_NTA', assert(match) nogen 
tempfile simulation_dest
save `simulation_dest'

twoway (scatter d_real_wage_ratio_p95 d_real_wage_ratio_mean if j!="`treated_NTA'" & j!="SI99", msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter d_real_wage_ratio_p5 d_real_wage_ratio_mean if j!="`treated_NTA'" & j!="SI99", msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter d_real_wage_ratio_p95 d_real_wage_ratio_mean if j!="`treated_NTA'"& d_real_wage_ratio_mean==. & j!="SI99", msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter d_real_wage_ratio_p5 d_real_wage_ratio_mean if j!="`treated_NTA'"& d_real_wage_ratio_mean==. & j!="SI99", msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean percent change in wage", size(medlarge)) ytitle("Percent change",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/scatter_gu_realw_simulation_fixednu_sumstats_diff_NTA.eps", replace

count if d_real_wage_ratio_p5 > 0
local realw_p5_pos = string(`r(N)')
file open myfile using "../output/report_gu_realw_fixednu_NTA.tex", write replace
file write myfile "`realw_p5_pos' out of 194 destination NTAs have a positive change in wages at the 5\textsuperscript{th} percentile."
file close myfile

// Change in the number of workers
twoway (scatter d_emp_p95 d_emp_mean if j!="`treated_NTA'" & d_emp_mean>-1000, msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter d_emp_p5 d_emp_mean if j!= "`treated_NTA'" & d_emp_mean>-1000, msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter d_emp_p95 d_emp_mean if j!= "`treated_NTA'" & d_emp_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter d_emp_p5 d_emp_mean if j!= "`treated_NTA'" & d_emp_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean change in the number of workers", size(medlarge)) ytitle("Change in workers",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/scatter_gu_emp_simulation_fixednu_NTA.eps", replace

count if j!="`treated_NTA'"
local emp_NTA_count = string(`r(N)')
count if inrange(0, d_emp_p5, d_emp_p95) & j!="`treated_NTA'"
local emp_signif = string(`r(N)')
file open myfile using "../output/report_gu_emp_sigfchange_fixednu_NTA.tex", write replace
file write myfile "the 90\% confidence interval for the change in employment includes zero for `emp_signif' of the `emp_NTA_count' non-Amazon workplace NTAs."
file close myfile

// Change in the number of workers (treated NTA)
foreach num of numlist 5 95{
	summ d_emp_p`num' if j == "`treated_NTA'"
	local d_emp_p`num'_treatedNTA = string(round(`r(max)'))
	preserve
		clear
		set obs 1
		gen d_emp_p`num'_str = string(`d_emp_p`num'_treatedNTA', "%10.0fc")
		local d_emp_p`num'_str_NTA =  d_emp_p`num'_str
		file open myfile using "../output/AHQ2_d_emp_p`num'_treatedNTA.tex", write replace
		file write myfile "`d_emp_p`num'_str_NTA'"
		file close myfile
	restore
}