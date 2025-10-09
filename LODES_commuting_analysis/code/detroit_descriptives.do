clear all
set more off

// employment statistics in 2014
do "programs_descriptives.do"

use "../input/lodes_DetroitUA_2014.dta", clear
shareofcommuters, output_share1("../output/DetroitUA_2014_share1.tex") output_share5("../output/DetroitUA_2014_share5.tex") output_share5_slides("../output/DetroitUA_2014_share5_slides.tex") geoname("Detroit")
use "../input/lodes_DetroitUA_2014.dta", clear
employmentconcentration, output_texfile(../output/DetroitUA_2014_mediantract_employees.tex) geoname("Detroit")

// compare employment statistics in 2013 and 2014
use "../input/lodes_DetroitUA_2013.dta", clear
fillin i j 
rename X_ij X_ij_2013
recode X_ij_2013 .=0 if _fillin == 1
drop _fillin
tempfile df_2013
save `df_2013'

use "../input/lodes_DetroitUA_2014.dta", clear
fillin i j
rename X_ij X_ij_2014
recode X_ij_2014 .=0 if _fillin == 1
drop _fillin

merge 1:1 i j using `df_2013', nogen

// generate an indicator equal to 1 if someone in the tract commutes to ANY origin/destination.
bys i: egen anyresident_2013 = max(inrange(X_ij_2013,1,.)==1)
bys i: egen anyresident_2014 = max(inrange(X_ij_2014,1,.)==1)
bys j: egen anyemp_2013 = max(inrange(X_ij_2013,1,.)==1)
bys j: egen anyemp_2014 = max(inrange(X_ij_2014,1,.)==1)
gen anyresident = anyresident_2013 * anyresident_2014
drop anyresident_*
gen anyemp = anyemp_2013 * anyemp_2014
drop anyemp_*

tempfile df_20132014
save `df_20132014'

gen byte X_ij_2013_nonzero = (X_ij_2013!=0)  
gen byte X_ij_2014_nonzero = (X_ij_2014!=0)

count if X_ij_2013_nonzero == 0 & X_ij_2014_nonzero!=0
local zero_to_positive = string(floor(`r(N)'/10000)*10000,"%10.0fc")
shell echo `zero_to_positive'% > ../output/DetroitUA_2013zero_2014pos.tex


