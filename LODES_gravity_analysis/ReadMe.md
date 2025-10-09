# LODES gravity analysis

This task conducts gravity analysis based on LODES data.


## Output
### Gravity regression: commuting cost
- For the following outputs, δ is constructed as a function of transit time. Observations with missing transit time are imputed based on distance:
    - `(location)_(year)_gravity_time_impute.tex`: compare commuting elasticity estimates. 
    - `scatter_destFE_(location)_(year)_impute.eps`: visualize destination fixed effects from gravity regressions.
    - `NYC2010_gravity_time_impute_simple.tex`: compare commuting elasticity estimates (MLE and OLS only) for NYC 2010.

- `NYC_outliers_Columbia_footnote.tex`: a case where simplest covariates-based model predicts largest flow poorly.

### Out-of-sample prediction
- `gravity_outofsample_(location).tex`: comparison between gravity-based (distance/transit time) predictions and predictions based on observed commuting flow.

## Input
- `2015_gaz_tracts_(state_FIPS).txt`: tract-level geographical coordinates.
- `(location)_delta_LODES(year).dta`: LODES commuting data together with delta as a function of transit time.
- `(location)_dist_covariates.dta`: tract-pair level distance.
- `(location)_LODES_pooled`: pooled commuting data.
- `lodes_(location)_(year)`: LODES commuting data.

## Code
### Gravity regression: commuting cost
- `compare_gravity_estimators_time_impute.do`: compare commuting elasticity estimates using commuting cost (δ) as a function of transit time, with imputation based on distance for missing observations.
- `compare_gravity_estimators_time_impute_simple.do`: compare commuting elasticity estimates (MLE and OLS only) using using commuting cost (δ) as a function of transit time, with imputation based on distance for missing observations.
- `NYC_CBM_residuals.do`: find the case where the simplest covariates-based model model predicts badly.

### Out-of-sample prediction
- `gravity_outofsample_dist_time.do`: comparison between gravity-based (distance/transit time) predictions and predictions based on observed commuting flow.
