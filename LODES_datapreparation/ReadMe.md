# LODES datapreparation
This task aggregates block-level LODES commuting data to tracts. 

- New York City (labeled as NYC in the output)
	- Bronx County, Kings County, New York County, Queens County, Richmond County 

It takes about 5 minutes to run the entire task.

## Output
- `lodes_(location)_(year).dta` tract-level data.

## Input
- `2015_gaz_tracts_(state_FIPS).txt`: tract-level geographical coordinates.
- `(state_abbreviation)_od_main_JT01_(year).csv`: raw LODES commuting data, for jobs with both workplace and residence in the state.
- `(state_abbreviation)_od_aux_JT01_(year).csv`: raw LODES commuting data,  for jobs with the workplace in the state and the residence outside of the state. 

## Code
- `(location)_(geo_unit).do`: aggregate LODES data to (geo_unit) level, for (location).
- `programs.do`: `load_LODES_tracts`: aggregate block-level LODES data to tract-level.
