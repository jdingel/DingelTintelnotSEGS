* MZ:The code is copied from ORS replication package and made some changes to our event study setting 
* Goal: calculate wage upper bound 

* Wage Upper Bound

/******************************************************************************

Here we compute a weighted wage from ZIP Business Patterns. We do this because
we would like to determine the maximum wage in this data set and apply it as an
upper bound to the wage bins provided in the LODES data set. We do this for
the years 2014 and 2004. The maximum wage obtained in 2014 is used in the 
benchmark allocations, while the maximum wage obtained in 2004 is used when 
calculating the changes in amenities over time. (Note that the maximum wage in 
2004 is not corrected for inflation).

To calculate the weighted wage, we apply the midpoint value of the bins below
in cases where the data is censored. Next, we join the ZIP data with the HUD-
USPS Zip-to-Tract crosswalk to calculate values by census tracts. Ignoring 
observations that were classified as missing data, we reweight the proportion of
addresses. Next, we multiply these proportions by the employment and annual 
payroll data, and sum by census tract to arrive at employment and annual payrolls
for each census tract. Then, we divide payroll by employment to arrive at an
average wage.

For reference, in table 4 of the appendix, the summary statistics presented are
using data at the Zip Code level, not at the census tract level.

Data sets required:

ZIP Business Patterns 2014
HUD-USPS Zip-to-Tract crosswalk (4th quarter 2015)
 
Notes:

a 0 to 19 employees - 9.5
b 20 to 99 employees - 59.5
c 100 to 249 employees - 174.5
e 250 to 499 employees - 374.5
f 500 to 999 employees - 749.5
g 1,000 to 2,499 employees - 1749.5
h 2,500 to 4,999 employees - 3749.5
i 5,000 to 9,999 employees - 7499.5
j 10,000 to 24,999 employees - 17499.5
k 25,000 to 49,999 employees - 37499.5
l 50,000 to 99,999 employees - 74999.5
m 100,000 employees or more

******************************************************************************/

cap program drop clean_wage
cap program define clean_wage
syntax, county_list(string) zip_tract(string) zip_wage(string) lodes(string) [output(string)]

foreach element of numlist `county_list' {
	local keepiflist = `"`keepiflist'"' + `""`element'""' + ", " //Construct a list of strings from the numlist
}
local keepiflist = substr(`"`keepiflist'"',1,length(`"`keepiflist'"')-2) //Drop the final unnecessary comma

import excel `zip_tract', firstrow clear
tempfile zip_to_tract
save `zip_to_tract'

import delimited `zip_wage', delimiter("|") clear 
tostring zipcode, g(ZIP)

* Replace censored values with midpoints of associated bins.
replace emp = 9.5 if emp_f == "a"
replace emp = 59.5 if emp_f == "b"
replace emp = 174.5 if emp_f == "c"
replace emp = 374.5 if emp_f == "e"
replace emp = 749.5 if emp_f == "f"
replace emp = 1749.5 if emp_f == "g"
replace emp = 3749.5 if emp_f == "h"
replace emp = 7499.5 if emp_f == "i"
replace emp = 17499.5 if emp_f == "j"
replace emp = 37499.5 if emp_f == "k"
replace emp = 74999.5 if emp_f == "l"
replace emp = 100000 if emp_f == "m"
assert payqtr1_f == payqtr1_n_f if payqtr1_f=="D" | payqtr1_f=="S"
drop if payqtr1_f == "D" | payqtr1_f == "S" |  payann_f == "D" 

joinby ZIP using `zip_to_tract', _merge(_merge)
drop _merge
keep if inlist(substr(TRACT,1,5),`keepiflist')==1
egen NEW_RATIO = pc(BUS_RATIO), by(ZIP) prop
replace NEW_RATIO = 0 if BUS_RATIO==0
*	drop _merge
gen Annual_Payroll = payann * 1000
foreach var of varlist emp Annual_Payroll {
	gen `var'_share = `var' * NEW_RATIO
}
collapse (sum) emp_share Annual_Payroll_share, by(TRACT)
ren (emp_share Annual_Payroll_share) (Employees Annual_Payroll)
format Annual_Payroll %15.0f
gen Wj = Annual_Payroll / Employees
gen Wj_monthly = Wj / 12
egen maxWj_monthly = max(Wj_monthly)
sort TRACT
local wage_max = round(maxWj_monthly[1])
di `wage_max' 

import delimited `lodes', clear
ren (h_geocode w_geocode) (geoid15_home geoid15_work)
tostring geoid15*, replace format(%17.0g)
gen geoid11_home = substr(geoid15_home,1,11)
gen geoid11_work = substr(geoid15_work,1,11)
gen geoid5_home = substr(geoid15_home,1,5)
gen geoid5_work = substr(geoid15_work,1,5)
keep if inlist(geoid5_home,`keepiflist')==1 & inlist(geoid5_work,`keepiflist')==1
collapse (sum) s000 se01 se02 se03, by(geoid11_work)
gen Wj = ((((se01 * ((0 + 1250) / 2)) + (se02 * ((1251 + 3333) / 2)) + (se03 * ((3334 + `wage_max') / 2))) * 12) / (se01 + se02 + se03)) // With upper bound
keep geoid11_work Wj
label var geoid11_work "Tract of workplace (11-digit FIPS)"
label var Wj "Annual average payroll per employee in workplace tract"
compress
sort geoid11_work

if "`output'" != "" save_data `output', key(geoid11_work) replace log_replace
end
