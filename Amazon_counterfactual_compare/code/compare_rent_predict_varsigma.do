clear all

set scheme s2color
graph set window fontface "Garamond"
graph set eps fontface "Times"

import delimited using "../input/amazon_ctfl_tract_`3'_sigma_`1'_rent.csv"
gen predicted_rent_change_comp = (hat_realr - 1) * 100
keep i predicted_rent_change_comp
tempfile temp
save `temp'
clear 

import delimited using "../input/amazon_ctfl_tract_`3'_sigma_`2'_rent.csv"
gen predicted_rent_change_main = (hat_realr - 1) * 100
keep i predicted_rent_change_main
merge 1:1 i using `temp', assert(master match) nogen

if "`4'" == "notreat" {
    drop if i == 36081000700
}

regress predicted_rent_change_comp predicted_rent_change_main
local r2: display %5.4f e(r2)
local slope: display %5.4f _b[predicted_rent_change_main]
local intercept: display %5.4f _b[_cons]
local model_type : display strupper("`3'")

egen mean_sq_diff = mean((predicted_rent_change_main - predicted_rent_change_comp)^2)
local mse: display %5.4f mean_sq_diff

twoway (scatter predicted_rent_change_comp predicted_rent_change_main) (lfit predicted_rent_change_comp predicted_rent_change_main) ///
, legend(off) graphregion(color(white)) aspectratio(1) ///
ytitle("Predicted percentage change in rent (`model_type'), {&sigma}= `1'") xtitle("Predicted percentage change in rent (`model_type'), {&sigma} = `2'") ///
note("R-squared = `r2'; Slope = `slope'; Intercept = `intercept'; MSE = `mse'")
graph export "`5'", replace as(eps)