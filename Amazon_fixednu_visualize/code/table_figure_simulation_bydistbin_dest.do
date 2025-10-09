clear all

set scheme s2color
assert inlist("`1'", "1.1", "4.0", "Inf", "inf")
import delimited using "../input/simulation_bydistbin_fixednu_dest_`1'.csv", clear

gen employment_change = emp_a_mean - emp_b_mean
gen wages_percent_change = 100 * (real_wa_mean/real_wb_mean - 1)

summarize wages_percent_change
local avg_wages_percent_change = r(mean)
summarize employment_change
local avg_emp_change = r(mean)

collapse (firstnm) dist_ij_maximum dist_ij_minimum (mean) employment_change wages_percent_change ///
	(p5) employment_change_p5 = employment_change wages_percent_change_p5 = wages_percent_change ///
	(p95) employment_change_p95 = employment_change wages_percent_change_p95 = wages_percent_change ///
	, by(ventile_id)

graph twoway ///
    (scatter employment_change dist_ij_minimum, mcol(black) msize(small) yline(`avg_emp_change', lcolor(red) lpattern(dash))) ///
    (rcap employment_change_p5 employment_change_p95 dist_ij_minimum, lcolor(black)), ///
    legend(off) graphregion(color(white)) aspectratio(1) ///
    ytitle("Change in employment") xtitle("Distance from Amazon HQ2 tract (by ventile)")
graph export "../output/AHQ2_emp_bydistbin_fixednu_sigma_`1'.eps", replace as(eps)

graph twoway ///
    (scatter wages_percent_change dist_ij_minimum, mcol(black) msize(small) yline(`avg_wages_percent_change', lcolor(red) lpattern(dash))) ///
    (rcap wages_percent_change_p5 wages_percent_change_p95 dist_ij_minimum, lcolor(black)), ///
    legend(off) graphregion(color(white)) aspectratio(1) ///
    ytitle("Change in wages (%)") xtitle("Distance from Amazon HQ2 tract (by ventile)")
graph export "../output/AHQ2_wages_bydistbin_fixednu_sigma_`1'.eps", replace as(eps)

tostring dist_ij_m* employment_change* wages_percent_change*, replace format("%4.1f") force

gen ventile_descrip = "[" + dist_ij_minimum + ", " + dist_ij_maximum + "]"

listtex ventile_id ventile_descrip employment_change employment_change_p5 employment_change_p95 wages_percent_change wages_percent_change_p5 wages_percent_change_p95 ///
	using "../output/AHQ2_employment_wages_bydistbin_fixednu_sigma_`1'.tex", replace rstyle(tabular) ///
	head("\begin{tabular}{rcrrrrrr} \toprule" "& & \multicolumn{3}{c}{Change in employment} & \multicolumn{3}{c}{$\%$ change in wages} \\ \cmidrule(r){3-5} \cmidrule(l){6-8}" "Ventile & Distance & Mean & p5 & p95 & Mean & p5 & p95 \\" "\midrule") ///
	foot("\bottomrule\end{tabular}")