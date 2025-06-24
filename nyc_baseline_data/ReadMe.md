# eventstudy nyc baseline data

This task prepares baseline data for event studies in New York City, including information on wage, labor allocation, transit time, and statistics obtained from gravity regression.

## Output
* `nyc2012_lodes_wzeros.dta`: LODES NYC 2012 data with zero commuting flows.
* `(stub)_dest_time.dta`: Destination tract fixed effects for commuting flows with google maps times as bilateral covariate
* `(stub)_orig_time.dta`: Origination tract fixed effects for commuting flows with google maps times as bilateral covariate
* `(stub)_time_elasticity.csv`: The commuting time elasticity in preperiod
* `(stub)_lodes_wzeros.dta`: LODES data from stub with zero commuting flows.
* `(stub)_lodes_wzeros_wdelta.dta`: LODES data from stub with zero commuting flows and commuting costs.
* `nyc_delta_bar.jld2`: The time commuting cost matrix.

## Code
* `convert_delta_bar_to_jld.jl`: This script converts the `wdelta.dta` file's values for delta bar into a K×N $\bar{\delta}$ matrix and saves it as a `.jld2` file.

## Input
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
* `process_lodes.do`: aggregate LODES raw data to tract level, fill in zero commuting flows.
* `programs_lodes.do`: program to aggregate block-level LODES data to tract-level, and aggregate tract-level data to place-level.
* `2015_gaz_tracts_36.txt`: tract-level geographical coordinates in NY
* `CB0800CZ1.txt`: 2008 tract-level NAICS employment data
* `CB0900CZ1.txt`: 2009 tract-level NAICS employment data
* `CB1000CZ1.txt`: 2010 tract-level NAICS employment data
* `ny_od_main_JT01_(year).csv`: Origin-Destination employment statistics for new york for all primary jobs.
* `NYC_tractpairs_DDMM.dta`: NYC tract-pair level transit time from Davis, Dingel, Monras, and Morales's replication package.
* `ZIP_TRACT_122010.xlsx`: Zip-tract crosswalk



It takes about half an hour to run the entire task.