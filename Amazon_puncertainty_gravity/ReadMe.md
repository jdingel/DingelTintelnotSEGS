# Amazon p-uncertainty gravity
This task computes the gravity regression for each of the 100 variations of the baseline commuting shares matrix. 

## Output
* `nyc2010_dest_time_puncertainty_#.dta`: Destination tract fixed effects for commuting flows with google maps times as bilateral covariate
* `nyc2010_orig_time_puncertainty_#.dta`: Origin tract fixed effects for commuting flows with google maps times as bilateral covariate
* `nyc2010_time_elasticity_puncertainty_#.csv`: The commuting time elasticity in preperiod
* `nyc2010_lodes_wzeros_puncertainty_#.dta`: LODES NYC 2010 data with zero commuting flows.
* `nyc2010_lodes_wzeros_wdelta_puncertainty_#.dta`: LODES NYC 2010 data with zero commuting flows and commuting costs.


## Code
* `gravity.do`: Runs the gravity regression and outputs the destination and origin fixed effects and bilateral commuting predictions.

## Input
* `baseline_data_puncertainty_s#.csv`: Baseline commuting shares for parameter uncertainty scenario #.
* `clean_wage.do`: replicate ORS's method to calculate tract-level wage.
* `gravity_saveFE_time.do`: run gravity regression, with transit time specification.
* `data_before.do`: prepare relevant single-year data for the year before the shock, including
	- LODES commuting data;
	- commuting cost as a function of transit time;
	- gravity regression;
	- wage level.
* `merge_geocords.do`: calculate tract-pair level distance
* `nyc_delta.do`:
    - merge NYC tract-level transit time with commuting flows,
    - impute missing transit time based on distance.
* `2015_gaz_tracts_36.txt`: tract-level geographical coordinates in NY
* `NYC_tractpairs_DDMM.dta`: NYC tract-pair level transit time from Davis, Dingel, Monras, and Morales's replication package.
* `CB1000CZ1.txt`: 2010 tract-level NAICS employment data
* `ZIP_TRACT_122010.xlsx`: Zip-tract crosswalk