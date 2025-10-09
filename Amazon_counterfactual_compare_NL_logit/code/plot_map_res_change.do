clear all

graph set window fontface "Garamond"
graph set eps fontface "Times" 

do "../input/map_res.do"
cap mkdir "../temp"

local tract = 36081000700

// change in residents

// Nested-logit
import delimited "../input/amazon_ctfl_tract_cbm_ntaorigin_0.25_ell.csv", clear
collapse (sum) res_after=x_ij_after res_before=x_ij_before, by(i)
gen res_change_nested = res_after - res_before
rename i geoid11
keep geoid11 res_change_nested

tempfile df_nested
save `df_nested'

map_res, df_commute("../input/nyc2010_lodes_wzero_wdelta.dta") ///
			treatment_tract("`tract'") df_hat(`df_nested') variable(res_change_nested) ///
			res_output("../output/no_output.png") ///
			whetheroutput("NO 2010 OUTPUTS") ///
			pricechange_output("../output/map_cont_change_res_nested.png") ///
			legend_pos(5) legend_format(%2.1f) max_category(8) fc(Oranges) ///
			county_list(inlist(county_id,"36005","36047","36061","36081","36085")) 
