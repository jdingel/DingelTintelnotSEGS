clear all

set scheme s2color
graph set window fontface "Garamond"
graph set eps fontface "Times"

// loading CSP_changes
import delimited using `1', clear
gen model = "CSP"

keep i model hat_realr
tempfile temporary
save `temporary'

// loading CBM changes
import delimited using `2', clear
gen model = "CBM"
keep i model hat_realr
merge 1:1 model i using `temporary', assert(master using) nogen
tostring i, replace format("%11.0f")
tempfile temporary2
save `temporary2'

// loading distances
use `3', clear
keep i dist_ij
merge 1:m i using `temporary2', assert(master match) nogen
keep if i != "36081000700"

// Pick graph titles and distance measurement based off of third argument, log if 1
if "`4'" == "dist_log_ij" {
    replace dist_ij = log(dist_ij)
    local x_axis_label = "Log kilometers to AHQ2"
}
else {
    local x_axis_label = "Kilometers to AHQ2"
}
gen realr_pct = (hat_realr-1) * 100
regress realr_pct dist_ij if model == "CBM"
local r2_cbm: display %5.4f e(r2)
local slope_cbm: display %5.4f _b[dist_ij]
local intercept_cbm: display %5.4f _b[_cons]
local se_cbm: display %5.4f _se[dist_ij]
regress realr_pct dist_ij if model == "CSP"
local r2_csp: display %5.4f e(r2)
local slope_csp: display %5.4f _b[dist_ij]
local intercept_csp: display %5.4f _b[_cons]
local se_csp: display %5.4f _se[dist_ij]
if "`4'" == "dist_log_ij" {
    file open cbm_grad using "../output/AHQ2_rent_gradient_log_cbm.tex", write replace
    file write cbm_grad "`slope_cbm'"
    file close cbm_grad

    file open csp_grad using "../output/AHQ2_rent_gradient_log_csp.tex", write replace
    file write csp_grad "`slope_csp'"
    file close csp_grad
}

graph twoway (lpolyci realr_pct dist_ij if model == "CBM", lcol(red) ciplot(rline) alpattern(dot)) /// 
    (lpolyci realr_pct dist_ij if model == "CSP", lcol(blue) ciplot(rline) alpattern(dot)) ///
    (lfit realr_pct dist_ij if model == "CBM", lcol(red) lpattern(dash)) /// 
    (lfit realr_pct dist_ij if model == "CSP", lcol(blue) lpattern(dash)) ///
    , name(feasible, replace) graphregion(color(white)) ///
    ytitle("Change in Rents (%)") xtitle(`x_axis_label') ///
    legend(label(2 "Covariates-based model") label(4 "Calibrated-shares procedure")) ///
    legend(label(5 "Covariates-based model") label(6 "Calibrated-shares procedure")) ///
    note("CBM OLS R-squared = `r2_cbm'; CBM OLS coefficient = `slope_cbm'; CBM OLS intercept = `intercept_cbm'" "CSP OLS R-squared = `r2_csp'; CSP OLS slope = `slope_csp'; CSP OLS intercept = `intercept_csp'" "treated tract removed")
graph export `6', replace

if "`5'" == "NO_OLS" { //replace with no OLS variant if 5th argument is NO_OLS
    graph twoway (lpolyci realr_pct dist_ij if model == "CBM", lcol(red) ciplot(rline) alpattern(dot)) /// 
    (lpolyci realr_pct dist_ij if model == "CSP", lcol(blue) ciplot(rline) alpattern(dot)) ///
    , name(feasible, replace) graphregion(color(white)) ///
    ytitle("Change in Rents (%)") xtitle(`x_axis_label') ///
    legend(label(2 "Covariates-based model") label(4 "Calibrated-shares procedure")) ///
    legend(label(5 "Covariates-based model") label(6 "Calibrated-shares procedure"))
graph export `6', replace
}