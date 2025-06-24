# LODES gravity dataprep

This task prepares LODES data for use in gravity regressions.

It takes ten minutes to run the entire task.

## Output
- `(location)_(year)_times_imputed.tex`: the fraction of tract pairs with missing commute times.
- `(location)_delta_LODES(year).dta`: prepare delta as a function of transit time (impute version) and merge with commuting data.

## Input
- `2015_gaz_tracts_(state_FIPS).txt`: tract-level geographical coordinates.
- `lodes_(location)_(year).dta`: LODES tract-level commuting data.
- `nyc_delta.do`
	- prepare delta as a function of transit time for NYC,
	- impute missing commuting time based on distance.
- `NYC_tractpairs_DDMM.dta`: NYC tract-pair level transit time from Davis, Dingel, Monras, and Morales's replication package.

## Code
- `programs.do`
	- `pool_LODES_years`: prepare pooled data,
	- `merge_geocoords` : calculate tract-pair level distance.
- `NYC_calls.do` 
	- prepare delta as a function of transit time and merge with commuting data,
