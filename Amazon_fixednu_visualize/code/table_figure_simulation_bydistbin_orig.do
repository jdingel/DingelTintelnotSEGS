clear all

set scheme s2color
assert inlist("`1'", "1.1", "4.0", "Inf", "inf")
import delimited using "../input/simulation_bydistbin_fixednu_orig_`1'.csv", clear

gen residents_change = res_a_mean - res_b_mean
gen rents_percent_change = 100 * (real_ra_mean/real_rb_mean - 1)

summarize rents_percent_change
local avg_rents_percent_change = r(mean)

collapse (firstnm) dist_ij_maximum dist_ij_minimum (mean) residents_change rents_percent_change ///
	(p5) residents_change_p5 = residents_change rents_percent_change_p5 = rents_percent_change ///
	(p95) residents_change_p95 = residents_change rents_percent_change_p95 = rents_percent_change ///
	, by(ventile_id)

graph twoway ///
    (scatter residents_change dist_ij_minimum, mcol(black) msize(small) yline(0, lcolor(red) lpattern(dash))) ///
    (rcap residents_change_p5 residents_change_p95 dist_ij_minimum, lcolor(black)), ///
    legend(off) graphregion(color(white)) aspectratio(1) ///
    ytitle("Change in residents") xtitle("Distance from Amazon HQ2 tract (by ventile)")
graph export "../output/AHQ2_residents_bydistbin_fixednu_sigma_`1'.eps", replace as(eps)

graph twoway ///
    (scatter rents_percent_change dist_ij_minimum, mcol(black) msize(small) yline(`avg_rents_percent_change', lcolor(red) lpattern(dash))) ///
    (rcap rents_percent_change_p5 rents_percent_change_p95 dist_ij_minimum, lcolor(black)), ///
    legend(off) graphregion(color(white)) aspectratio(1) ///
    ytitle("Change in rents (%)") xtitle("Distance from Amazon HQ2 tract (by ventile)")
graph export "../output/AHQ2_rents_bydistbin_fixednu_sigma_`1'.eps", replace as(eps)

tostring dist_ij_m* residents_change* rents_percent_change*, replace format("%4.1f") force

gen ventile_descrip = "[" + dist_ij_minimum + ", " + dist_ij_maximum + "]"

listtex ventile_id ventile_descrip residents_change residents_change_p5 residents_change_p95 rents_percent_change rents_percent_change_p5 rents_percent_change_p95 ///
	using "../output/AHQ2_residents_rents_bydistbin_fixednu_sigma_`1'.tex", replace rstyle(tabular) ///
	head("\begin{tabular}{rcrrrrrr} \toprule" "& & \multicolumn{3}{c}{Change in residents} & \multicolumn{3}{c}{$\%$ change in rents} \\ \cmidrule(r){3-5} \cmidrule(l){6-8}" "Ventile & Distance & Mean & p5 & p95 & Mean & p5 & p95 \\" "\midrule") ///
	foot("\bottomrule\end{tabular}")