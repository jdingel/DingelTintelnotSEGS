clear all

set scheme s2color

import delimited using "../temp/jensen_simulation_compiled_r_sigma_`1'.csv", clear varnames(1)
gen row_id = _n

if "`1'" == "1.1"{ //remove insane scale on 1.1 observations
    replace real_r_cont = real_r_cont/10e54
    replace real_r_mean = real_r_mean/10e54
    local x_axis_title = "CBM real rents (in 10e54)"
    local y_axis_title = "Mean of finite simulations' real rents (in 10e54)"
} 
else {
    local x_axis_title = "CBM real rents"
    local y_axis_title = "Mean of finite simulations' real rents"
}
//regress real_r_cont on real_r_mean
regress real_r_mean real_r_cont
local r2: display %5.4f e(r2)
local slope: display %5.4f _b[real_r_cont]
local intercept: display %5.4f _b[_cons]

gen error_sq = (real_r_mean - real_r_cont)^2
summarize error_sq
local mse_num = sum(error_sq)/`r(N)'
local mse: display %5.4f `mse_num'

//create scatterplot of real_r_cont vs real_r_mean 
twoway (scatter real_r_mean real_r_cont, mcolor(black)) ///
        (lfit real_r_mean real_r_cont, color(red) lpattern(dash)), ///
		graphregion(color(white)) xlabel(,labsize(*1.25)) ylabel(,labsize(*1.25)) xtitle("`x_axis_title'") ytitle("`y_axis_title'") ///
		legend(lab(1 "Rents") lab(2 "Line of best fit")) ///
		note("R-squared = `r2'; Slope = `slope'; Intercept = `intercept'; MSE = `mse'")
graph export "../output/jensen_rent_comparison_sigma_`1'.eps", replace as(eps)

// create relevant print statements
gen dev_CCRE_rent_mean = abs(real_r_mean-real_r_cont)*100/real_r_cont
sum dev_CCRE_rent_mean,d
local rent_p50 = string(`r(p50)',"%3.2f")
local rent_p95 = string(`r(p95)',"%3.2f")
shell echo `rent_p50'% > "../output/dev_CCRE_rent_p50_sigma_`1'.tex"
shell echo `rent_p95'% > "../output/dev_CCRE_rent_p95_sigma_`1'.tex"