clear all
graph set window fontface "Garamond"
graph set eps fontface "Times" 
do "../input/map_res.do"
do "../input/map.do"
do "../input/map_cutoff.do"
local tract=36081000700
assert mod(`1',1)==0 & inrange(`1',1,2143)
import delimited "../input/amazon_ctfl_tract_svd_`1'_ell.csv", clear
collapse (sum) x_i_approx = x_ij_before x_i_after =x_ij_after, by(i)
rename i geoid11
gen change_res = x_i_after - x_i_approx
tempfile df_svd
save `df_svd'

map_res, df_commute("../temp/nyc_2010_levels_tracttotract_approx_svd_`1'.dta") ///
			treatment_tract("`tract'") df_hat(`df_svd') variable(change_res) ///
			res_output("../output/map_res2010_svd`1'.png") ///
			pricechange_output("../output/map_reschange_svd`1'.png") ///
			legend_pos(5) legend_format(%4.2f) max_category(7) fc(Oranges) ///
			county_list(inlist(county_id,"36005","36047","36061","36081","36085")) 
use `df_svd', clear
local res_cutoff 49.3 74.3 87.3 93.5 96.4 98.0 98.7
map_cutoff, var(change_res) tract("`tract'") treated_format("%2.1f") ///
	var_type(residents) pct_list(`res_cutoff') ///
	output("../output/map_svd`1'_reschange_cutoff.png") fc(Oranges) 

// change in number of workers
import delimited "../input/amazon_ctfl_tract_svd_`1'_ell.csv", clear
collapse (sum) x_j_after=x_ij_after x_j_before=x_ij_before, by(j)
gen change_emp_svd = x_j_before-x_j_after
rename j geoid11
map, fc(Oranges) var(change_emp_svd) tract(`tract') format(%10.1fc) treated_format(%10.0fc) ///
	var_type(workers) output("../output/map_empchange_svd`1'.png")
// rent change
import delimited "../input/amazon_ctfl_tract_svd_`1'_rent.csv",clear
gen pct_change_realr = (hat_realr-1)*100
rename i geoid11
map, var(pct_change_realr) tract(`tract') format(%2.1f) treated_format(%2.1f) var_type(residents) fc(Oranges) output("../output/map_svd`1'_hat_realr.png")
// rent change using cutoffs
local percentile_list 49.3 74.3 87.3 93.5 96.4 98.0 98.7
map_cutoff, var(pct_change_realr) tract(`tract') treated_format("%4.2f") ///
	var_type(residents) pct_list(`percentile_list') ///
	output("../output/map_svd`1'_hat_realr_cutoff.png") fc(Oranges)
centile pct_change_realr if geoid11!=`tract', c(90 100)
local rent_p90 = string(`r(c_1)',"%2.1f")
local rent_p100 = string(`r(c_2)',"%2.1f")
shell echo The SVD model predicts rent increases of `rent_p90'\\% to `rent_p100'\\% for the top decile of tracts% > ../output/text_Amazon_svd`1'_rent_topdecile.tex
// wage change
import delimited "../input/amazon_ctfl_tract_svd_`1'_wage.csv",clear
gen pct_change_realw = (hat_realw-1)*100
rename j geoid11
map, var(pct_change_realw) tract(`tract') format(%4.3f) treated_format(%4.3f) var_type(workers) fc(Oranges) output("../output/map_svd`1'_hat_realw.png")
// wage change using cutoffs
map_cutoff, var(pct_change_realw) tract(`tract') treated_format("%4.2f") ///
	var_type(residents) pct_list(`percentile_list') ///
	output("../output/map_svd`1'_hat_realw_cutoff.png") fc(Oranges)