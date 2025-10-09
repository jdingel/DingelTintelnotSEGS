clear all

assert inlist("`1'","","countypair","pumapair","ntapair")
local pairtype = "`1'"
local geounit = subinstr("`1'","pair","",1)

// programs
do "gravity_nests_saveFE_time.do"

* Import NTA and county codes
import excel using "../input/nyc2010census_tabulation_equiv.xlsx", clear cellrange(A4) firstrow
rename (NeighborhoodTabulationAreaNT G Borough CensusBureauFIPSCountyC PUMA) (NTA_code NTA_name county_name county_code puma_code)
drop if NTA_name=="Name" | NTA_code=="Code"

gen tract = "36" + county_code + CensusTract
encode NTA_code, generate(NTA_id)
encode puma_code, generate(puma_id)
encode county_code, generate(county_id)
keep tract NTA_id county_id puma_id

label var tract "Tract (11-digit FIPS)"

save_data "../output/nyc2010_census_tabulation.dta", key(tract) replace log_replace

destring tract, replace
tempfile location_codes
save `location_codes'


* Import data on commuting counts
use "../input/nyc2010_lodes_wzero_wdelta.dta",clear
destring i j, replace

* Merge NTA codes to the commuting data and create NTA_pair
clonevar tract = i
merge m:1 tract using `location_codes', keep(master match)
rename NTA_id nta_id_origin
rename puma_id puma_id_origin
rename county_id county_id_origin
drop _merge tract

clonevar tract = j
merge m:1 tract using `location_codes', keep(master match)
rename NTA_id nta_id_destination
rename puma_id puma_id_destination
rename county_id county_id_destination
drop _merge tract

tempfile tf
save `tf'

//Estimate model with `geounit' pair nests
if "`geounit'"!="" {
	use `tf', clear
	gen z_o = `geounit'_id_origin
	gen z_d = `geounit'_id_destination
	label var z_o "Origin `geounit'"
	label var z_d "Destination `geounit'"
	gravity_nests_saveFE_time, nest_type("`pairtype'")
}
