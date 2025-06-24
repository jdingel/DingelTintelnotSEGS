clear all

local rank = `1'
assert inrange(`rank', 1, 3)

import delimited elasticity using "../input/nyc2010_time_elasticity_ife_`rank'.csv"
local epsilon = abs(elasticity)

import delimited i j log_lambda using "../input/nyc2010_ife_ij_ife_`rank'.csv", stringcols(1 2) clear
assert _N ==  4628880 // check the number of observations

gen lambda = exp(-log_lambda/`epsilon') // similar to `rentbelief = coalesce.(exp.(-FE_i./(ε*α)),Inf)' in `calibrate_main.jl'
label variable i "Tract of residence (11-digit FIPS)"
label variable j "Tract of workplace (11-digit FIPS)"
label variable lambda "bilateral commuting disutility"
keep j i lambda
save_data "../output/nyc2010_lambda_ife_`rank'.dta", key(j i) replace log_replace
