clear all

set scheme s2color

graph set window fontface "Garamond"
graph set eps fontface "Times" 

local tract = "36081000700"

// prepare data
use "../input/nyc2010_lodes_wzero_wdelta.dta",clear
keep j
sort j 
duplicates drop
gen id = _n
tempfile dest_tractID
save `dest_tractID', replace 

// import origin prices and quantities
import delimited "../input/simulation_distribution_orig_nested.csv", stringcol(1)  clear

gen winsor_d_real_rent_ratio_p95 = min(2000, d_real_rent_ratio_p95)
gen winsor_d_real_rent_ratio_p5 = max(-2000, d_real_rent_ratio_p5)

egen d_real_r_ratio_mean_city = mean(d_real_rent_ratio_mean)
sum d_real_r_ratio_mean_city
local pct_real_r_change_city_mean = r(mean)

count if winsor_d_real_rent_ratio_p5 > d_real_r_ratio_mean_city
local sig_r_change_num_p5 = string(`r(N)')
file open myfile using "../output/report_gu_sigchange_realr_p5_wrt_city_mean.tex", write replace
file write myfile "`sig_r_change_num_p5' out of 2160 origin tracts have a change in real rents at the 5\textsuperscript{th} percentile larger than the citywise mean change (`pct_real_r_change_city_mean')."
file close myfile

count if winsor_d_real_rent_ratio_p95 < d_real_r_ratio_mean_city
local sig_r_change_num_p95 = string(`r(N)')
file open myfile using "../output/report_gu_sigchange_realr_p95_wrt_city_mean.tex", write replace
file write myfile "`sig_r_change_num_p95' out of 2160 origin tracts have a change in real rents at the 95\textsuperscript{th} percentile smaller than the citywise mean change (`pct_real_r_change_city_mean')."
file close myfile


// Percentage change in real rents
twoway (scatter winsor_d_real_rent_ratio_p95 d_real_rent_ratio_mean, msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter winsor_d_real_rent_ratio_p5 d_real_rent_ratio_mean, msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter winsor_d_real_rent_ratio_p95 d_real_rent_ratio_mean if d_real_rent_ratio_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter winsor_d_real_rent_ratio_p5 d_real_rent_ratio_mean if d_real_rent_ratio_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean percent change in rent",size(medlarge)) ytitle("Percent change",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/scatter_gu_realr_simulation_fixednu_sumstats_diff_nested.eps", replace

count if winsor_d_real_rent_ratio_p5 > 0
local realr_p5_pos = string(`r(N)')
file open myfile using "../output/report_gu_realr_fixednu_nested.tex", write replace
file write myfile "`realr_p5_pos' out of 2160 origin tracts have a positive change in real rents at the 5\textsuperscript{th} percentile."
file close myfile


// Change in the number of residents 
twoway (scatter d_res_p95 d_res_mean, msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter d_res_p5 d_res_mean, msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter d_res_p95 d_res_mean if d_res_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter d_res_p5 d_res_mean if d_res_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean change in the number of residents",size(medlarge)) ytitle("Change in residents",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/scatter_gu_res_simulation_fixednu_nested.eps", replace

count if inrange(0, d_res_p5, d_res_p95)
local res_signif = string(`r(N)')
file open myfile using "../output/report_gu_res_sigfchange_fixednu_nested.tex", write replace
file write myfile "the 90\% confidence interval for the change in residents includes zero for `res_signif' of the 2160 tracts."
file close myfile


// import destination prices and quantities
import delimited "../input/simulation_distribution_dest_nested.csv", clear
merge 1:1 id using `dest_tractID', assert(match) nogen

// Percentge change in real wages
twoway (scatter d_real_wage_ratio_p95 d_real_wage_ratio_mean if j!="`tract'", msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter d_real_wage_ratio_p5 d_real_wage_ratio_mean if j!="`tract'", msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter d_real_wage_ratio_p95 d_real_wage_ratio_mean if j!="`tract'"& d_real_wage_ratio_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter d_real_wage_ratio_p5 d_real_wage_ratio_mean if j!="`tract'"& d_real_wage_ratio_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean percent change in wage", size(medlarge)) ytitle("Percent change",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/scatter_gu_realw_simulation_fixednu_sumstats_diff_nested.eps", replace

count if d_real_wage_ratio_p5 > 0
local realw_p5_pos = string(`r(N)')
file open myfile using "../output/report_gu_realw_fixednu_nested.tex", write replace
file write myfile "`realw_p5_pos' out of 2143 destination tracts have a positive change in real wages at the 5\textsuperscript{th} percentile."
file close myfile


// Change in the number of workers
twoway (scatter d_emp_p95 d_emp_mean if j!="`tract'" & d_emp_mean>-1000, msymbol(Dh) msize(tiny) mcolor(blue)) ///
		(scatter d_emp_p5 d_emp_mean if j!= "`tract'" & d_emp_mean>-1000, msymbol(Th) msize(tiny) mcolor(red)) ///
		(scatter d_emp_p95 d_emp_mean if j!= "`tract'" & d_emp_mean==., msymbol(Dh) msize(large) mcolor(blue)) ///
		(scatter d_emp_p5 d_emp_mean if j!= "`tract'" & d_emp_mean==., msymbol(Th) msize(large) mcolor(red)) ///
		, graphregion(color(white)) legend(size(medlarge) order(3 4) lab(3 "95th percentile") lab(4 "5th percentile")) ///
		xtitle("Mean change in the number of workers", size(medlarge)) ytitle("Change in workers",size(medlarge)) ///
		ylabel(,labsize(medlarge) gmax) xlabel(,labsize(medlarge))
graph export "../output/scatter_gu_emp_simulation_fixednu_nested.eps", replace

count if j!="`tract'"
local emp_tract_count = string(`r(N)')

count if inrange(0, d_emp_p5, d_emp_p95) & j != "`tract'"
local emp_signif = string(`r(N)')
count
file open myfile using "../output/report_gu_emp_sigfchange_fixednu_nested.tex", write replace
file write myfile "the 90\% confidence interval for the change in employment includes zero for `emp_signif' of the `emp_tract_count' non-Amazon tracts."
file close myfile

// Change in the number of workers (treated tracts)
foreach num of numlist 5 95{
	summ d_emp_p`num' if j == "`tract'"
	local d_emp_p`num'_treated_nested = string(round(`r(max)'), "%10.0fc")
	file open myfile using "../output/AHQ2_d_emp_p`num'_treated_nested.tex", write replace
	file write myfile "`d_emp_p`num'_treated_nested'"
	file close myfile
}