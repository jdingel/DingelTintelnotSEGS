// count the number of resident-employees and the number of tract pairs

clear all

use "../input/lodes_`1'_`2'.dta",clear
sum X_ij,d
local pop = string(`r(sum)'/1000000,"%2.1f")
fillin i j
replace X_ij =0 if _fillin==1
local pair = string(_N/1000000,"%2.1f")

shell echo -n has about `pop' million resident-employees and `pair' million tract pairs% > ../output/text_count_pop_pair_`1'_`2'.tex

