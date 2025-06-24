// visualize new results under new specification (\lambda as preference shifter)

clear all

graph set window fontface "Garamond"
graph set eps fontface "Times" 

do "../input/map_res.do"
do "../input/map.do"

local tract=36081000700

// change in number of residents
import delimited "../input/amazon_ctfl_tract_csp_sigma_4.0_ell.csv",clear
gen work_treated = x_ij_before if j==`tract'
collapse (sum) res_before=x_ij_before res_after=x_ij_after (firstnm) work_treated, by(i)
gen change_res = res_after-res_before
rename (i res_before) (geoid11 X_ij) 

tempfile df_cs
save `df_cs'

map_res, df_commute("../input/nyc2010_lodes_wzero_wdelta.dta") ///
			treatment_tract("`tract'") df_hat(`df_cs') variable(change_res) ///
			res_output("../output/map_res2010.png") ///
			pricechange_output("../output/map_cs_changeres.png") ///
			legend_pos(5) legend_format(%2.1f) max_category(8) fc(Oranges) ///
			county_list(inlist(county_id,"36005","36047","36061","36081","36085"))


// rent change
import delimited "../input/amazon_ctfl_tract_csp_sigma_4.0_rent.csv",clear
gen pct_change_realr = (hat_realr-1)*100
rename i geoid11
map, var(pct_change_realr) tract(`tract') format(%2.1f) treated_format(%2.1f) var_type(residents) fc(Oranges) output("../output/map_cs_hat_realr.png")
	

