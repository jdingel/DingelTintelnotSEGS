# nyc_NTA_aggregate_baseline_wages
    This task aggregates the baseline wages from the tract level to the NTA level by taking the employment-weighted average.

## Output
* `NTA_avg_wages_2010.dta`: NTA-level wage data for 2010. 
## Code
* `aggregate_NTA_wages.do`: 
Takes in the NTA crosswalk and census-tract wages and employment and aggregates them to the NTA level by taking the employment-weighted average wage. 

## Input
* `nyc_tract_NTA_crosswalk.dta`: NTA classification for each census tract in NYC.
* `nyc_2010_wage.dta`: Employment data for each census tract in NYC from 2002 to 2017
* `nyc2010_lodes_wzero_wdelta.dta`: commuting flows in NYC 2010, with zero commuting flows.
