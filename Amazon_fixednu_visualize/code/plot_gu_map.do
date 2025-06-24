clear all

set scheme s2color
graph set window fontface "Garamond"
graph set eps fontface "Times"
do "../input/map.do"

local tract = 36081000700
assert inlist("`1'", "1.1", "4.0", "Inf", "inf")
// Origin
import delimited "../input/amazon_ctfl_tract_cbm_sigma_`1'_ell.csv",clear
collapse (sum) x_i_after=x_ij_after x_i_before=x_ij_before, by(i)
gen change_res_c = x_i_after-x_i_before
rename i geoid11
sort geoid11
gen id = _n
tempfile cont_res
save `cont_res'

import delimited "../input/simulation_distribution_orig_sigma_`1'.csv",clear
merge 1:1 id using `cont_res', assert(match) keepusing(geoid11 change_res_c) nogen
tempfile df_orig
save `df_orig'

// change in rent
map, var(d_real_rent_ratio_mean) tract(`tract') format("%2.1f") treated_format("%2.1f") ///
	var_type(residents) output("../output/temp.png") fc(Oranges)
shell mv "../output/temp.png" "../output/map_gu_realrchange_fixednu_sigma_`1'.png"
gen real_rent_mean_change = (real_ra_mean / real_rb_mean - 1) * 100 
map, var(real_rent_mean_change) tract(`tract') format("%2.1f") treated_format("%2.1f") ///
	var_type(residents) output("../output/temp.png") fc(Oranges)
// 
shell mv "../output/temp.png" "../output/map_gu_realrchange_fixednu_mean_change_sigma_`1'.png"
// graph export is not compatible with decimal numbers in filenames
// Destination
if "`1'" != "Inf" {

import delimited "../input/amazon_ctfl_tract_cbm_sigma_`1'_wage.csv",clear
gen change_realw_c = (hat_realw-1) * 100
rename j geoid11
sort geoid11
gen id = _n
tempfile cont_wage
save `cont_wage'


import delimited "../input/simulation_distribution_dest_sigma_`1'.csv",clear
merge 1:1 id using `cont_wage', assert(match) keepusing(geoid11 change_realw_c) nogen
// change in wage
map, var(d_real_wage_ratio_mean) tract(`tract') format("%4.3f") treated_format("%4.2f") ///
	var_type(workers) output("../output/temp.png") fc(Oranges)
shell mv "../output/temp.png" "../output/map_gu_realwchange_fixednu_sigma_`1'.png"
gen real_wage_mean_change = (real_wa_mean / real_wb_mean - 1) * 100 
map, var(real_wage_mean_change) tract(`tract') format("%2.1f") treated_format("%2.1f") ///
	var_type(workers) output("../output/temp.png") fc(Oranges)
shell mv "../output/temp.png" "../output/map_gu_realwchange_fixednu_mean_change_sigma_`1'.png"
} // graph export is not compatible with decimal numbers in filenames

if "`1'" == "Inf" display "No reason to map wages that do not change"
