// visualize new results under new specification (\lambda as preference shifter)

clear all

graph set window fontface "Garamond"
graph set eps fontface "Times" 

do "../input/map_res.do"
do "../input/map.do"
do "map_cutoff.do"

local tract=36081000700

// text output
use "../input/nyc2010_lodes_wzero_wdelta.dta",clear
keep if j=="`tract'"
count if X_ij==0
local frac_zero = string(`r(N)'*100/_N,"%2.1f")
shell echo `frac_zero'\\% of residential tracts have zero residents employed at that workplace tract.% > ../output/text_frac_zero_work_at_treated.tex


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

// employment in 2010
use "../input/nyc2010_lodes_wzero_wdelta.dta",clear
sum X_ij,d
local pop = `r(sum)'
collapse (sum) X_ij, by(j)
destring j, replace 
clonevar geoid11=j
map, fc(Oranges) var(X_ij) tract(`tract') format(%10.0fc) treated_format(%10.0fc) ///
	var_type(workers) output("../output/map_emp2010.png")

// change in number of workers
import delimited "../input/amazon_ctfl_tract_csp_sigma_4.0_ell.csv",clear
collapse (sum) emp_after=x_ij_after emp_before=x_ij_before, by(j)
gen change_emp_cs = emp_before-emp_after
rename j geoid11
map, fc(Oranges) var(change_emp_cs) tract(`tract') format(%10.1fc) treated_format(%10.0fc) ///
	var_type(workers) output("../output/map_empchange_cs.png")


// rent change
import delimited "../input/amazon_ctfl_tract_csp_sigma_4.0_rent.csv",clear
gen pct_change_realr = (hat_realr-1)*100
rename i geoid11
map, var(pct_change_realr) tract(`tract') format(%2.1f) treated_format(%2.1f) var_type(residents) fc(Oranges) output("../output/map_cs_hat_realr.png")

// rent change using cutoffs
local percentile_list 49.3 74.3 87.3 93.5 96.4 98.0 98.7
map_cutoff, var(pct_change_realr) tract(`tract') treated_format("%4.2f") ///
	var_type(residents) pct_list(`percentile_list') ///
	output("../output/map_cs_hat_realr_cutoff.png") fc(Oranges)

centile pct_change_realr if geoid11!=`tract', c(90 100)
local rent_p90 = string(`r(c_1)',"%2.1f")
local rent_p100 = string(`r(c_2)',"%2.1f")
shell echo The calibrated-shares procedure predicts rent increases of `rent_p90'\\% to `rent_p100'\\% for the top decile of tracts% > ../output/text_Amazon_cs_rent_topdecile.tex
// count the number of census tracts with rent increases of more than 5%
count if pct_change_realr>5
shell echo "It suggests that in `r(N)' census tracts, real rents would increase by at least 5\%." > ../output/text_Amazon_cs_rent_5pct.tex
count if pct_change_realr>4
shell echo "It suggests that in `r(N)' census tracts, real rents would increase by at least 4\%." > ../output/text_Amazon_cs_rent_4pct.tex

// wage change
import delimited "../input/amazon_ctfl_tract_csp_sigma_4.0_wage.csv",clear
gen pct_change_realw = (hat_realw-1)*100
rename j geoid11
map, var(pct_change_realw) tract(`tract') format(%4.3f) treated_format(%4.3f) var_type(workers) fc(Oranges) output("../output/map_cs_hat_realw.png")

// wage change using cutoffs
map_cutoff, var(pct_change_realw) tract(`tract') treated_format("%4.2f") ///
	var_type(residents) pct_list(`percentile_list') ///
	output("../output/map_cs_hat_realw_cutoff.png") fc(Oranges)

	

