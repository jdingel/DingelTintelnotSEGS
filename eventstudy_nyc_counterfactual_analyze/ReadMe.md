# eventstudy_nyc_counterfactual_analyze
This task computes the slope, intercept, and mean squared error (MSE) for the predicted vs actual changes of the commuting flows to the treated tracts or NTAs using predicted changes from the simultaneous shock computations.
This task is parallelizable.
There are 73 specifications corresponding to 73 CSV files. 

## Output
* `slope_int_MSE_all_(model).csv`: The slope, intercept, MSE, and tract ID for all tracts using the predictions of the model.
Model includes (1) covariates-based model (2) calibrated share model and (3) (ife, svd, nnmf)
* `slope_int_MSE_scatterplot_(model)_(nta_id).eps`: A scatterplot detailing the observed vs the predicted changes for a given model and treatment NTA. 
It also includes the slope, intercept, MSE, and $R^2$ for the regression of the observed changes on the predicted changes.

## Code
* `compute_stats.do`:
Computes observed (2010-2012) changes and a given model's predicted changes for commuting flows to the treated tract.
Computes the slope, intercept, and MSE between the predicted and observed changes. 

## Input
* `specification_list.csv`: List of all model specifications used to compute counterfactual outcomes.
* `nyc_20102012_spikes_list`: List of tracts that experienced employment booms in 2010-2012.
* `NTA_spikes_list_12.5pct.csv`: List of NTAs that experienced employment booms in 2010-2012.
* `nyc_NTA_2012_2010_observed_changes_origtodest.dta`: Vector of 2010-2012 change in commuter counts for NTA pairs.
* `nyc_2012_2010_observed_changes_dest.dta`: Vector of 2010-2012 change in commuter counts for tract pairs.
* `nyc_obs_(model-variation)_all.csv`:
Reports the observed (2010) and model-predicted pre- and post-shock commuting flows by tract pair for all 83 tracts, using a simultaneously computed model variation.
