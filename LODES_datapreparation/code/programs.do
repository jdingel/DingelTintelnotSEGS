* aggregate block-level data to tract-level
cap program drop load_LODES_tracts
program define load_LODES_tracts

syntax, [keepifnumlist(numlist)] [saveas(string)] 

ren (h_geocode w_geocode) (geoid15_home geoid15_work)
tostring geoid15*, replace format(%17.0g)
ren s000 residentemployees
gen geoid11_home = substr(geoid15_home,1,11)
gen geoid11_work = substr(geoid15_work,1,11)
gen geoid5_home = substr(geoid15_home,1,5)
gen geoid5_work = substr(geoid15_work,1,5)
if "`keepifnumlist'"!="" foreach element of numlist `keepifnumlist' {
	local keepiflist = `"`keepiflist'"' + `""`element'""' + ", " //Construct a list of strings from the numlist
}
local keepiflist = substr(`"`keepiflist'"',1,length(`"`keepiflist'"')-2) //Drop the final unnecessary comma
if "`keepifnumlist'"!="" keep if inlist(geoid5_home,`keepiflist')==1 & inlist(geoid5_work,`keepiflist')==1
collapse (sum) residentemployees, by(geoid11_home geoid11_work)
rename (geoid11_home geoid11_work residentemployees) (i j X_ij)
label variable i "Tract of residence (11-digit FIPS)"
label variable j "Tract of workplace (11-digit FIPS)"
label variable X_ij "Number of commuters residing in i and working in j"

assert X_ij!=0  // These data contain no zeros

compress
if "`saveas'"!="" save "`saveas'", replace

end
