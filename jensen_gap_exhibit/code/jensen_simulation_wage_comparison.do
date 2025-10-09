clear all

set scheme s2color

import delimited using "../temp/jensen_simulation_compiled_w_sigma_`1'.csv", clear varnames(1)

keep if real_w_mean != 0
if "`1'" == "1.1"{ //remove insane scale on 1.1 observations
    replace real_w_cont = real_w_cont/10e54
    replace real_w_mean = real_w_mean/10e54
    local x_axis_title = "CBM real wages (in 10e54)"
    local y_axis_title = "Mean of finite simulations' real wages (in 10e54)"
}
else{
    local x_axis_title = "CBM real wages"
    local y_axis_title = "Mean real wages across 10,000 simulations"
}
summarize
//regress real_w_cont on real_w_mean
regress real_w_mean real_w_cont
local r2: display %5.4f e(r2)
local slope: display %5.4f _b[real_w_cont]
local intercept: display %5.4f _b[_cons]

//create scatterplot of real_w_cont vs real_w_mean 
twoway (scatter real_w_mean real_w_cont, mcolor(black)) ///
        (lfit real_w_mean real_w_cont, color(red) lpattern(dash)), ///
		graphregion(color(white))  aspectratio(1)  xlabel(#4,labsize(*1.25) format(%5.1f)) ylabel(#4,labsize(*1.25) format(%5.1f)) xtitle("`x_axis_title'") ytitle("`y_axis_title'") ///
		legend(lab(1 "Wages") lab(2 "Line of best fit")) ///
		note("R-squared = `r2'; Slope = `slope'; Intercept = `intercept'")
graph export "../output/jensen_wage_comparison_sigma_`1'.eps", replace as(eps)

// create relevant print statements
gen dev_CCRE_wage_mean = abs(real_w_mean-real_w_cont)*100/real_w_cont
sum dev_CCRE_wage_mean,d
local wage_p50 = string(`r(p50)',"%3.2f")
local wage_p95 = string(`r(p95)',"%3.2f")
shell echo `wage_p50'% > "../output/dev_CCRE_wage_p50_sigma_`1'.tex"
shell echo `wage_p95'% > "../output/dev_CCRE_wage_p95_sigma_`1'.tex"