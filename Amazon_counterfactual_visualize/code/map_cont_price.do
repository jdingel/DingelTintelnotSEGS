clear all
graph set window fontface "Garamond"
graph set eps fontface "Times"
do "../input/map.do"

local tract=36081000700

import delimited "../input/amazon_ctfl_tract_cbm_sigma_4.0_rent.csv",clear
rename i geoid11
gen change_r = (hat_realr-1)*100
map, fc(Oranges) var(change_r) tract(`tract') format(%2.1f) treated_format(%2.1f) var_type(residents) output("../output/map_cont_change_realr.png")
