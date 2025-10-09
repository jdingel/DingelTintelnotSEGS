# nyc baseline data nests
This task estimates the gravity model for the nested-logit specifications.

## output
* `nyc2010_time_elasticity_$(nest_type).csv`: commuting time elasticity
* `zeta_$(nest_type).csv`: nested-logit parameter
* `orig_time_$(nest_type).dta`: origin fixed effects
* `dest_time_$(nest_type).dta`: destination fixed effects
* `census_tabulation.dta`: census tract-NTA crosswalk

## code
* `gravity_nests_saveFE_time.do`: program for running the gravity regression and saving the fixed effects.
* `estimate_FE_time.do`: Script for preparing the tract-NTA crosswalk delta and estimating the gravity model.

## input
`nyc2010census_tabulation_equiv.xlsx`: tract-to-NTA crosswalk in Excel format
`nyc2010_lodes_wzero_wdelta.dta`: commuting flows in NYC 2010, with zero commuting flows.