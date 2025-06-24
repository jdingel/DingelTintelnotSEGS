clear all

use ../input/nyc2010_lodes_wzero_wdelta.dta
bysort i (j): gen id_j = _n
bysort j (i): gen id_i = _n

qui summ id_i
assert r(max) == 2160
qui summ id_j
assert r(max) == 2143

gen treated = 0
replace treated = 1 if j == "36061005800"

drop i j impute
order id_j id_i 
export delimited "../temp/nyc2010_lodes_wzero_wdelta.csv", replace