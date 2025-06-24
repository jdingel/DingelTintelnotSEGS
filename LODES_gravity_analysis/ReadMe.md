# LODES gravity analysis

This task conducts gravity analysis based on LODES data.

It takes about ten minutes to run the entire task.

## Output

- `NYC2010_gravity_time_impute_simple.tex`: compare commuting elasticity estimates (MLE and OLS only, NYC 2010) using transit time.

## Input
- `2015_gaz_tracts(counties)_(state_FIPS).txt`: tract(county)-level geographical coordinates for certain states.
- `(location)_delta_LODES(year).dta`: LODES commuting data together with delta as a function of transit time.

## Code
- `compare_gravity_estimators_time_impute_simple.do`: compare commuting elasticity estimates (MLE and OLS only) using transit time.
