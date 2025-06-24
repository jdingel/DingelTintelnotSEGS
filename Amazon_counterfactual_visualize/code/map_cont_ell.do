clear all

graph set window fontface "Garamond"
graph set eps fontface "Times" 

do "../input/map_res.do"

local tract = 36081000700

// change in residents
import delimited "../input/amazon_ctfl_tract_cbm_sigma_4.0_ell.csv",clear
collapse (sum) x_i_after=x_ij_after x_i_before=x_ij_before, by(i)
gen change_res = x_i_after-x_i_before
rename i geoid11
tempfile df_res
save `df_res'

map_res, df_commute("../input/nyc2010_lodes_wzero_wdelta.dta") ///
			treatment_tract("`tract'") df_hat(`df_res') variable(change_res) ///
			res_output("../output/map_res2010.png") whetheroutput(0) ///
			pricechange_output("../output/map_cont_reschange.png") ///
			legend_pos(5) legend_format(%2.1f) max_category(8) fc(Oranges) ///
			county_list(inlist(county_id,"36005","36047","36061","36081","36085"))
