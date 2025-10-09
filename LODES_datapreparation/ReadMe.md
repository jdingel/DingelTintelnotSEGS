# LODES datapreparation
This task aggregates block-level LODES commuting data to tracts. 

- New York City (labeled as NYC in the output)
	- Bronx County, Kings County, New York County, Queens County, Richmond County 


## Output
- `lodes_(location)_(year).dta` tract-level data.

## Input
- `2015_gaz_tracts_(state_FIPS).txt`: tract-level geographical coordinates.
- `(state_abbreviation)_od_main_JT01_(year).csv`: raw LODES commuting data, for jobs with both workplace and residence in the state.
- `(state_abbreviation)_od_aux_JT01_(year).csv`: raw LODES commuting data, for jobs with the workplace in the state and the residence outside of the state. 
* `NYC_tractpairs_DDMM.dta`: NYC tract-pair level transit time from Davis, Dingel, Monras, and Morales's replication package.

## Code
- `(location)_tract.do`: aggregate LODES data to tract level, for (location).
- `programs.do`: `load_LODES_tracts`: aggregate block-level LODES data to tract-level.
