// Purpose: Compute summary statistics for employment in the treated tract before and after shock

clear all
set scheme s2color
graph set eps fontface "Times"

local num_sim = 100 
assert inlist(`1',1.09,1.18) // Size of the productivity shock
local treated_tract = 1145
tempfile df
save `df', emptyok replace


// Load all simulations, sum employment count for the treated tract
foreach i of numlist 1/`num_sim' {
	* di `i'
	use "../input/DGP_iid_1145_treatedonly_0_2.488905_`1'_`i'.dta", clear
	collapse (sum) emp_before = x_ij_before emp_after = x_ij_after

	tempfile sim`i'_emp_changes
	save `sim`i'_emp_changes', replace

 	use `df', clear 
	append using `sim`i'_emp_changes'
	save `df', replace 
}

use `df', clear 
gen sim_num = _n
gen emp_changes = emp_after - emp_before

// Summarize employment levels and changes across 100 simulations
quietly summarize emp_changes, detail 
local emp_changes_min = floor(`r(min)' / 100) * 100
di `emp_changes_min'
twoway (hist emp_changes, lcolor(black) fcolor(none) start(`emp_changes_min') width(50) fraction), ///
	graphregion(color(white)) legend(off)  xlabel(#6) xtitle("Employment changes in the treated tract (iid Monte Carlo)")
graph export "../output/hist_montecarlo_iid_empchanges.eps", replace
// graph export is not compatible with decimal numbers in filenames
shell mv "../output/hist_montecarlo_iid_empchanges.eps" ///
	"../output/hist_montecarlo_iid_empchanges_`1'.eps"

quietly sum emp_changes, detail 
local emp_changes_sd_iid = string(`r(sd)', "%3.0f")
shell echo -n `emp_changes_sd_iid' > "../output/sd_montecarlo_iid_empchanges_`1'.tex"

estpost tabstat emp_before emp_after emp_changes, listwise statistics(min p25 p50 p75 max mean sd) columns(statistics)
esttab using "../output/sumstats_montecarlo_iid_empchanges_`1'.tex", replace ///
	cells("min(fmt(%9.2fc %9.2fc %9.2fc %9.2fc)) p25 p50 p75 max mean sd") ///
	nostar unstack nonumber compress nomtitle nonote gap label booktabs f
