clear all

assert inrange(`1',2005,2014) & `1'==int(`1') //Integer-valued year

* reside and work in WI
import delimited "../input/wi_od_main_JT01_`1'.csv", clear
tempfile wi_both
save `wi_both'
* reside in WI, work in other state
import delimited "../input/wi_od_aux_JT01_`1'.csv", clear
append using `wi_both'
tempfile wi_both_hWI
save `wi_both_hWI'
* reside in MN, work in other state
import delimited "../input/mn_od_aux_JT01_`1'.csv", clear
append using `wi_both_hWI'
tempfile wi_both_hWI_hMN
save `wi_both_hWI_hMN'
* reside and work in MN
import delimited "../input/mn_od_main_JT01_`1'.csv", clear
append using `wi_both_hWI_hMN'

ren (h_geocode w_geocode) (geoid15_home geoid15_work)
tostring geoid15*, replace format(%17.0g)
ren s000 residentemployees
gen geoid11_home = substr(geoid15_home,1,11)
gen geoid11_work = substr(geoid15_work,1,11)
gen geoid5_home = substr(geoid15_home,1,5)
gen geoid5_work = substr(geoid15_work,1,5)

keep if (inlist(geoid5_home,"27053","27123","27003","27163","27139","27171","27019","27141") | inlist(geoid5_home,"27025","27059","27095","27143","27037","27079","55109","55093")) & (inlist(geoid5_work,"27053","27123","27003","27163","27139","27171","27019","27141") | inlist(geoid5_work,"27025","27059","27095","27143","27037","27079","55109","55093"))

collapse (sum) residentemployees, by(geoid11_home geoid11_work)
rename (geoid11_home geoid11_work residentemployees) (i j X_ij)
label var i "Tract of residence (11-digit FIPS)"
label var j "Tract of workplace (11-digit FIPS)"
label var X_ij "Number of commuters residing in i and working in j"
compress
assert X_ij!=0  // These data contain no zeros
save "../output/lodes_MSP_`1'.dta", replace
