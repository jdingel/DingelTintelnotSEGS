clear all

set scheme s2color
graph set window fontface "Garamond"
graph set eps fontface "Times"

import delimited using "`1'", clear 
drop if j != 36081000700
gen predicted_ell_change_comp = x_ij_after - x_ij_before
keep i predicted_ell_change_comp
tempfile temp
save `temp'
import delimited using "`2'", clear
drop if j != 36081000700
gen predicted_ell_change_main = x_ij_after - x_ij_before
keep i predicted_ell_change_main
merge 1:1 i using `temp', assert(master match) nogen

regress predicted_ell_change_comp predicted_ell_change_main
local r2: display %5.4f e(r2)
local slope: display %5.4f _b[predicted_ell_change_main]
local intercept: display %5.4f _b[_cons]
local model_type = strupper(subinstr("`3'", "_", " ", .))

egen mean_sq_diff = mean((predicted_ell_change_comp - predicted_ell_change_main)^2)
local mse: display %5.4f mean_sq_diff

twoway (scatter predicted_ell_change_comp predicted_ell_change_main) (lfit predicted_ell_change_comp predicted_ell_change_main) ///
, legend(off) graphregion(color(white)) aspectratio(1) ytitle("Predicted change in commuters (`model_type')") xtitle("Predicted change in commuters (CBM)") ///
note("R-squared = `r2'; Slope = `slope'; Intercept = `intercept'; MSE = `mse'")
graph export "`4'", replace as(eps)