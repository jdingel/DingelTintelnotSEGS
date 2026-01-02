clear all

import delimited "../input/nyc2010_time_elasticity.csv",clear
local epsilon = abs(v1[1])
di `epsilon'

use "../input/nyc2010_lodes_wzero_wdelta.dta",clear
sum X_ij,d
local pop=`r(sum)'

foreach s of numlist 1/10 {

	foreach i of numlist 1/100 {
 		import delimited "../temp/expost_individuals_choices_s`s'_b`i'.csv",clear
 		if `i'==1 tempfile df`s'
 		if `i'!=1 append using `df`s''
 		save `df`s'', replace
	}
	keep if inrange(_n, 1, `pop')==1
	gen util_gain = exp(max_expost_utility/`epsilon')/exp(chosen_expost_utility/`epsilon')-1
	assert inrange(util_gain,0,.)==1
	assert expost_optimal_choice!=chosen_choice if util_gain>0 

	// calculate fraction of movers
	count if util_gain>0
	local frac`s'=`r(N)'/`pop'

	// calculate unconditional distribution of utility gain, p95 - p99.
	sum util_gain,d
	local p95 = `r(p95)'
	sort util_gain
	foreach i of numlist 96/99{
		local index = round(`pop'*`i'/100)
		local p`i' = util_gain[`index']
	}

	// calculate conditional distribution of utility gain, mean & median, (conditional on moving).
	sum util_gain if util_gain>0,d
	local move_mean = `r(mean)'
	local move_median = `r(p50)'

	mat s`s' = (`frac`s'',`p95',`p96',`p97',`p98',`p99', `move_mean', `move_median')
}

mat output = s1\s2\s3\s4\s5\s6\s7\s8\s9\s10
mata: st_matrix("output_mean",colsum(st_matrix("output"))/10)
mat output = output\output_mean

frmttable using "../output/expost_results.tex", statmat(output) ///
	rtitle("1"\"2"\"3"\"4"\"5"\"6"\"7"\"8"\"9"\"10"\"mean") ///
	sd(4) tex frag nocenter replace

local frac_move = round(output[11,1]*100)
local frac_nomove = 100 - `frac_move'
local move_util_median = string(output[11,8]*100,"%2.1f")
assert `move_util_median'<1
file open outputfile using "../output/text_expost_regret.tex", write replace
file write outputfile "`frac_nomove'\% of individuals would not want to change their residence-workplace choice. For the `frac_move'\% who would want to switch, the median ex post regret $\chi_i$ is equal to `move_util_median'\%.%"
file close outputfile

file open outputfile using "../output/text_intro_expost_regret.tex", write replace
file write outputfile "`frac_nomove'\% of individuals would not change their residence-workplace choice if given the opportunity.%"
file close outputfile

file open outputfile using "../output/text_expost_regret_slides.tex", write replace
file write outputfile "Conditional on wanting to switch, median ex-post regret $ \chi_i $ is `move_util_median'\%."
file close outputfile