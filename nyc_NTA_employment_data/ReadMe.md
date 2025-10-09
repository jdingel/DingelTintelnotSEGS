# nyc_NTA_employment_data

This task aggregates tract-level employment, residents, commuting flows, and commuting costs to the level of Neighborhood Tabulation Area (NTAs).

## Output
* `NTA_employment.dta`: NTA-level employment data for 2010 and 2012.
* `NTA_delta_arithmetic.dta`: NTA-level commuting cost data for 2010 and 2012 that was aggregated using an arithmetic mean and replacing the infinite deltas with 10,000.
* `NTA_delta_harmonic.dta`: NTA-level commuting cost data for 2010 and 2012 that was aggregated using a harmonic mean and replacing the infinite deltas with 10,000.
* `NTA_delta_weighted.dta`: NTA-level commuting cost data for 2010 and 2012 that was aggregated using a mean weighted by destination employment and replacing the infinite deltas with 10,000.
* `NTA_commutingflows_{year}.dta`: NTA-level commuting flow data for a given year
* `NTA_residents_{year}.dta`: NTA-level commuting flow data for a given year
* `NTA_residents_hist_{year}.eps`: A histogram of the number of residents in each NTA for a given year.
* `NTA_residents_list_{year}.tex`: A list of the NTAs with the lowest number of residents for a given year.
## Code
* `aggregate_NTA_employment.do`: 
Takes in the NTA crosswalk and tract employment and aggregates tract-level employment to the NTA level by summing the number of employees.
* `aggregate_NTA_commuting_flows_residents.do`: 
Uses NTA-crosswalk and tract-level commuting flows to aggregate commuting flows and residents to the NTA level.
* `aggregate_NTA_delta_arithmetic.do`: 
Takes in tract-level delta data and NTA compositions and outputs a NTA-level delta matrix using the arithmetic mean commute times of the tracts in each NTA.
* `aggregate_NTA_delta_harmonic.do`: 
Takes in tract-level delta data and NTA compositions and outputs a NTA-level delta matrix using the harmonic mean commute times of the tracts in each NTA.

## Input
* `nyc_tract_NTA_crosswalk.dta`: NTA classification for each census tract in NYC.
* `nyc2010_lodes_wzero_wdelta.dta`: LODES NYC 2010 data with zero commuting flows.
* `nyc2012_lodes_wzeros.dta`: LODES NYC 2012 data with zero commuting flows.

