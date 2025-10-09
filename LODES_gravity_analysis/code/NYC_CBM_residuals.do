//Look at baseline calibration for NYC 2010
//What are the big residuals?

clear all

use "../input/lodes_NYC_2010.dta",clear
rename (X_ij) (X_ij_2010)
tempfile lodes_NYC_2010
save `lodes_NYC_2010'

use "../input/NYC_dist_covariates.dta",clear
gen dist_log_ij = log(dist_ij)
label var dist_log_ij "Distance (log)"
assert dist_ij==0 if missing(dist_log_ij)==1
tempfile NYC_dist_covariates
save `NYC_dist_covariates'

use ../input/NYC_LODES_pooled.dta, clear
merge 1:1 i j using `lodes_NYC_2010', assert(master match) nogen
merge 1:1 i j using `NYC_dist_covariates', assert(using match) keep(match) nogen
merge 1:1 i j using ../input/NYC_delta_LODES2010.dta, keep(master match) nogen

recode X_ij_2010 .=0

ppmlhdfe X_ij_2010 log_delta, absorb(i j) d
predict X_ij_predicted_delta
gen residual_abs = abs(X_ij_2010 - X_ij_predicted_delta)
gen residual_percent_abs = 2*abs(X_ij_2010 - X_ij_predicted_delta)/(X_ij_2010 + X_ij_predicted_delta)
gsort -residual_abs
local orig = i[1]
local dest = j[1]
local predicted = string(X_ij_predicted_delta[1],"%6.0fc")
local observed = string(X_ij_2010[1],"%6.0fc")
qui summ X_ij_2010
assert `observed' == `r(max)'
assert "`orig'"=="36061019900" & "`dest'"=="36061020300"
assert `predicted' < 0.25*`observed'
display "The largest observation in the 2010 LODES data for New York City is `observed' commuters who live in `orig' and work in `dest'."
display "The largest observation in the 2010 LODES data for New York City is `observed' commuters who live between 110th and 114th Streets in Morningside Heights and work on the adjacent Columbia University campus."
file open myfile using "../output/NYC_outliers_Columbia_footnote.tex", write replace
file write myfile "the largest commuting flow in the 2010 LODES data for New York City is `observed' commuters who reside between 110\textsuperscript{th} and 114\textsuperscript{th} Streets in Morningside Heights and work at adjacent Columbia University. The specification that uses transit times predicts only `predicted' of the `observed' observed commuters, failing to capture the effect of the university's dual role as employer and landlord."
file close myfile