# nyc_baseline_data_NTA
Estimates the gravity model, including fixed effects, for the NYC event study using NTA-level data.

## Output
* `nyc_NTA_2010_bilat_predicted_time.dta`: 
NTA level bilateral predicted commuting flows from gravity model. 
* `nyc_NTA_2010_dest_FE.dta`: NTA-level destination tract fixed effect for 2010
* `nyc_NTA_2010_orig_FE.dta`: NTA-level origination tract fixed effect for 2010
* `nyc_NTA_2010_lodes_wzero_wdelta.dta`: Commuting flow and cost data for 2010
* `nyc_NTA_2010_time_elasticity.csv`: Time elasticity implied by gravity model

## Code
* `NTA_gravity_regression.do`: Script for preparing aggregated delta and commuting flow data and computing the gravity model.

## Input
* `gravity_saveFE_time.do`: 
Program for running the gravity regression and saving the fixed effects.
* `NTA_delta_arithmetic.dta`: NTA-level commuting cost data for 2010 and 2012 that was aggregated using an arithmetic mean and replacing the infinite deltas with 10,000.
* `NTA_commutingflows_2010.dta`: NTA-level average commuting flows for 2010

