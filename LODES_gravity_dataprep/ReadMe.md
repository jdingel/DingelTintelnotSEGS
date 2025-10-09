# LODES gravity dataprep

This task prepares LODES data for use in gravity regressions.


## Output
- `(location)_(year)_times_imputed.tex`: the fraction of tract pairs with missing commute times.
- `(location)_delta_LODES(year).dta`: prepare delta as a function of transit time (impute version) and merge with commuting data.
- `(location)_dist_covariates.dta`: tract-pair level distance.
- `(location)_LODES_pooled.dta`: pooled commuting data.

## Input
- `2015_gaz_tracts_(state_FIPS).txt`: tract-level geographical coordinates.
- `lodes_(location)_(year).dta`: LODES tract-level commuting data.
- `nyc_delta.do`
	- prepare delta as a function of transit time for NYC,
	- impute missing commuting time based on distance.
- `NYC_tractpairs_DDMM.dta`: NYC tract-pair level transit time from Davis, Dingel, Monras, and Morales's replication package.
- `Kij_GoogleTime.xlsx` `Tract_Classification.xlsx`: DetroitUA tract-pair level transit time from Owens, Rossi-Hansberg, and Sarte's repliaction package.

## Code
- `programs.do`
	- `pool_LODES_years`: prepare pooled data,
	- `merge_geocoords` : calculate tract-pair level distance.
- `NYC_calls.do` `DetroitUA_calls.do`
	- prepare delta as a function of transit time and merge with commuting data,
	- prepare distance as covariate,
	- prepare pooled data.
- `detroit_delta_impute.do`
	- prepare delta as a function of transit time for Detroit UA,
	- impute missing commuting time based on distance.