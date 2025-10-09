//Purpose: Compute summary statistics for employment in the treated tract before and after shock

set scheme s2color
clear all

assert inlist(`1', 1.09, 1.18) // Magnitude of productivity shock

local num_sim = 100 
local treated_tract = 1145
tempfile df
save `df', emptyok replace

//Load all simulations, sum employment count for treated tract
foreach i of numlist 1/`num_sim'{
	import delimited "../input/DGP_`1'_`i'_fixednu.csv", clear
	keep if id_j == `treated_tract'
	collapse (sum) emp_before = x_ij_before emp_after = x_ij_after
	
	tempfile sim`i'_emp_changes
	save `sim`i'_emp_changes', replace

 	use `df', clear 
	append using `sim`i'_emp_changes'
	save `df', replace 
}

//Summarize employment levels and changes across 100 simulations
use `df', clear 
gen sim_num = _n
gen emp_changes = emp_after - emp_before 

quietly summarize emp_changes, detail 
local emp_changes_min = floor(`r(min)' / 100) * 100
di `emp_changes_min'
twoway (hist emp_changes, lcolor(black) fcolor(none) start(`emp_changes_min') width(50) fraction), ///
	graphregion(color(white)) legend(off)  xlabel(#6)  xtitle("Employment changes in the treated tract (fixed nu Monte Carlo)")
// graph export is not compatible with decimal numbers in filenames
graph export "../output/hist_montecarlo_fixednu_empchanges.eps", replace
shell mv "../output/hist_montecarlo_fixednu_empchanges.eps" ///
	"../output/hist_montecarlo_fixednu_empchanges_`1'.eps"

quietly sum emp_changes, detail 
local emp_changes_sd_fixednu = string(`r(sd)', "%3.0f")
shell echo -n `emp_changes_sd_fixednu' > "../output/sd_montecarlo_fixednu_emp_changes_`1'.tex"

estpost tabstat emp_before emp_after emp_changes, listwise statistics(min p25 p50 p75 max mean sd) columns(statistics)
esttab using "../output/sumstats_montecarlo_fixednu_empchanges_`1'.tex", replace ///
	cells("min(fmt(%9.2fc %9.2fc %9.2fc %9.2fc)) p25 p50 p75 max mean sd") ///
	nostar unstack nonumber compress nomtitle nonote gap label booktabs f
