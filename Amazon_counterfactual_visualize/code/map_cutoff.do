cap program drop map_cutoff
cap program define map_cutoff
syntax, var(string) tract(numlist) treated_format(string) ///
	var_type(string) pct_list(numlist) output(string) fc(string)

gsort `var'

tempfile orig_df
save `orig_df'

// Save dataframe that contain information on the treated tract
keep if geoid == `tract'
sum `var'
local treated_mean_`var' = string(`r(mean)', "`treated_format'")
local treated_max_`var' = string(`r(max)', "`treated_format'")

tempfile treated_tract_df
save `treated_tract_df'

use `orig_df'
// Calculate the percentiles for each observation
bysort `var': egen count_`var' = count(`var') if geoid != `tract'
drop if missing(count_`var')
gen cum_count_`var' = count_`var'[1]
replace cum_count_`var' = count_`var'[_n] + cum_count_`var'[_n-1] if _n > 1
gen pct_`var' = cum_count_`var' * 100 / cum_count_`var'[_N]

// Obtain sum stats for non-treated tracts
sum `var'
local min_`var' = r(min)
local max_`var' = r(max)

// Find the corresponding values for percentiles in `pct_list' and generate labels
local list_`var' = ""
local i 0 // Used to store the length of `pct_list'

foreach pct in `pct_list' {
	local i = `i' + 1

	local p`i' = string(`pct', "`treated_format'")
	local pp`i' = "p`p`i''"

	qui count if pct_`var' < `pct'
	local val`i' = `var'[`r(N)']
	local list_`var' = "`list_`var''" + " " + "`val`i''"
}

local legend_list = ""
foreach ind of numlist 1/`i' {
	local ind_right = `ind' + 1

	if (`ind' == 1) {
		local min_`var' = string(`min_`var'', "`treated_format'")
		local val`ind' = round(`val`ind'', 0.1)
		local val`ind' = string(`val`ind'', "`treated_format'")
		local temp_legend = "lab(`ind_right' min (`min_`var'') - " + ///
							"`pp`ind''" + " (`val`ind''))"
	} 
	else {
		local ind_left = `ind' - 1
		local val`ind_left' = string(`val`ind_left'', "`treated_format'")
		local val`ind' = string(`val`ind'', "`treated_format'")
		local temp_legend = "lab(`ind_right' "+ "`pp`ind_left''" + ///
							" - " +  "`pp`ind''" + " (`val`ind''))"
	}
	local legend_list = "`legend_list'" + " " + "`temp_legend'"

	if (`ind' == `i' ) {
		local ind_right = `ind' + 2
		local val`ind' = string(`val`ind'', "`treated_format'")
		local max_`var' = string(`max_`var'', "`treated_format'")
		local temp_legend_max = "lab(`ind_right' " +  "`pp`ind''" + ///
							" - max" + " (`max_`var''))"
		local legend_list = "`legend_list'" + " " + "`temp_legend_max'"
	} 
}

cap drop map_`var'
gen map_`var' = `var'
append using `treated_tract_df'
sum map_`var', d 
// Highlight treated tract
replace map_`var' = `treated_max_`var'' + 10 if geoid11 == `tract'

local i_tract = `i' + 3

tempfile df_plot
save `df_plot'


keep if geoid == `tract'
keep if geoid == `tract'
quietly merge 1:1 geoid11 using "../input/geoid11_database.dta", ///
	keep(match master) nogen
quietly merge 1:m _ID using "../input/geoid11_coords.dta", ///
	keep(match master) nogen
save "../temp/treated_tract_df.dta", replace

use `df_plot'
maptile map_`var', geo(geoid11) geofolder("../input/") ///
	fc(Oranges) res(0.3) ///
	cutv(`"`list_`var''"') ///
	spopt(polygon(data("../temp/treated_tract_df.dta") fcolor(black) ///
				legenda(on) leglabel("Treatment tract, `treated_mean_`var''"))) ///
	twopt(legend(size(small) ///
		lab(1 "No `var_type' in 2010") ///
		`legend_list' )) ///
	savegraph(`output') replace 

rm ../temp/treated_tract_df.dta

end

