clear all

import excel using "../input/nyc2010census_tabulation_equiv.xlsx", clear cellrange(A4) firstrow
rename (NeighborhoodTabulationAreaNT G) (NTA_code NTA_name)
drop if NTA_name=="Name"|NTA_code=="Code"
gen tract = "36" + CensusBureauFIPSCountyC + CensusTract
label var tract "Tract (11-digit FIPS)"
save_data "../output/nyc_tract_NTA_crosswalk.dta", key(tract) replace log_replace
