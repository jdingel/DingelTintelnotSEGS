cap program drop map
cap program define map
syntax, var(string) tract(numlist) format(string) treated_format(string) ///
		var_type(string) output(string) fc(string)

sum `var' if geoid11==`tract'
local treated_emp_str = string(`r(mean)',"`treated_format'")

sum `var' if geoid11!=`tract',d
foreach i of numlist 10 25 50 75 90 {
	local `var'_p`i' = `r(p`i')'
	local `var'_p`i'_str = string(``var'_p`i'',"`format'")

}
local `var'_max = `r(max)'+1
local `var'_max_str = string(`r(max)',"`format'")
local `var'_min_str = string(`r(min)',"`format'")

gen map_`var' = `var'
sum map_`var',d
replace map_`var' = `r(max)'+10 if geoid11==`tract'

tempfile df_plot
save `df_plot' 

keep if geoid == `tract'
quietly merge 1:1 geoid11 using "../input/geoid11_database.dta", ///
	keep(match master) nogen
quietly merge 1:m _ID using "../input/geoid11_coords.dta", ///
	keep(match master) nogen
save "../temp/treated_tract_df.dta", replace

use `df_plot'
maptile map_`var', geo(geoid11) geofolder("../input/") ///
	fc(`fc') res(0.3) ///
	cutv(``var'_p10' ``var'_p25' ``var'_p50' ``var'_p75' ``var'_p90') ///
	spopt(polygon(data("../temp/treated_tract_df.dta") fcolor(black) ///
				legenda(on) leglabel("Treatment tract, `treated_emp_str'"))) ///
	twopt(legend(size(small) ///
		lab(1 "No `var_type' in 2010") ///
		lab(2 "min (``var'_min_str') - p10 (``var'_p10_str')") ///
		lab(3 "p10 - p25 (``var'_p25_str')") ///
		lab(4 "p25 - p50 (``var'_p50_str')") ///
		lab(5 "p50 - p75 (``var'_p75_str')") ///
		lab(6 "p75 - p90 (``var'_p90_str')") ///
		lab(7 "p90 - max (``var'_max_str')"))) ///
	savegraph(`output') replace

shell rm ../temp/treated_tract_df.dta

end
