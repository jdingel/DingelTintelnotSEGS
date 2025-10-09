clear all

set scheme s2color
graph set window fontface "Garamond"
graph set eps fontface "Times"

local treated_tract = "36081000700"
assert inrange(`1', 0.25, 0.75)

// import ell from the nested logit continuum model
import delimited using "../input/amazon_ctfl_tract_cbm_ntaorigin_`1'_ell.csv", stringcol(1) clear 
drop if j != "`treated_tract'"
gen ell_change_nested = x_ij_after - x_ij_before
keep i ell_change_nested
tempfile nested_logit
save `nested_logit'


// import ell from the plain-vanilla logit continuum model
import delimited using "../input/amazon_ctfl_tract_cbm_sigma_4.0_ell.csv", stringcol(1) clear
drop if j != "`treated_tract'"
gen ell_change_logit = x_ij_after - x_ij_before
keep i ell_change_logit
merge 1:1 i using `nested_logit', assert(master match) nogen


// compute stats for model fitness
regress ell_change_nested ell_change_logit
local r2: display %5.4f e(r2)
local slope: display %5.4f _b[ell_change_logit]
local intercept: display %5.4f _b[_cons]

egen mean_sq_diff = mean((ell_change_nested - ell_change_logit)^2)
local mse: display %5.4f mean_sq_diff

summ ell_change_nested
local ell_change_min = r(min)
local ell_change_max = r(max)

twoway (scatter ell_change_nested  ell_change_logit) ///
        (function y = x, range(`ell_change_min' `ell_change_max')) ///
        , legend(off) graphregion(color(white)) aspectratio(1) ytitle("Predicted change in commuters (NL, {&zeta} = `1')") xtitle("Predicted change in commuters (CBM)") ///
        note("R-squared = `r2'; Slope = `slope'; Intercept = `intercept'; MSE = `mse'")

graph export "../output/ell_nested_comparison_plots_`1'.eps", replace as(eps)