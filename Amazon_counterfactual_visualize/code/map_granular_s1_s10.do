clear all

graph set window fontface "Garamond"
graph set eps fontface "Times"

do "../input/map_res.do"
do "../input/map.do"
do "map_cutoff.do"

local tract = 36081000700

// Origin
import delimited "../input/amazon_ctfl_tract_cbm_sigma_4.0_ell.csv",clear
collapse (sum) x_i_after=x_ij_after x_i_before=x_ij_before, by(i)
gen change_res_c = x_i_after-x_i_before
rename i geoid11
sort geoid11
gen id = _n
tempfile cont_res
save `cont_res'

import delimited "../input/simulation_orig.csv",clear
gen id=_n
merge 1:1 id using `cont_res', assert(match) keepusing(geoid11 change_res_c) nogen
tempfile df_orig
save `df_orig'

centile realr_change10 if geoid11!=`tract', c(90 100)
local rent_p90 = string(`r(c_1)',"%2.1f")
local rent_p100 = string(`r(c_2)',"%2.1f")
shell echo "the covariates-based model predicts more modest increases of `rent_p90'\\% to `rent_p100'\\% for the top decile of affected tracts%" > ../output/text_Amazon_CBM_rent_topdecile.tex
