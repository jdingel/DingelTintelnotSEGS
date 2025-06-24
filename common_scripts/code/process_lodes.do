clear all

local county_list = "36005,36047,36061,36081,36085" //New York City

do "../input/programs_LODES.do"
local year = `1'
assert inrange(`year',2004,2016)
import delimited "../input/ny_od_main_JT01_`year'.csv", clear
load_LODES_tracts, keepifnumlist(`county_list')
fillin i j
recode X_ij .=0
drop _fillin
save_data "../output/nyc`year'_lodes_wzeros.dta", key(i j) replace log_replace
