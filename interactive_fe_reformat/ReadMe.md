# eventstudy_interactive_fe_reformat
This task reformats the interactive fixed effects baseline commuting shares data into a format that is more easily used by eventstudy counterfactual evaluation pipeline. 

## Output
* `nyc_2010_levels_tracttotract_approx_ife_$(rank).dta.zip`: approximated LODES data using the IFE procedure, reformatted for the eventstudy counterfactual evaluation pipeline.
* `nyc2010_(orig|dest)_time_ife_$(rank).dta`: additive fixed effects estimates from the IFE procedure, reformatted for the eventstudy counterfactual evaluation pipeline.
* `nyc2010_lambda_ife_$(rank).dta`: bilateral commuting disutility calibrated from the IFE estimates.

## Code
* `reformat_ife_data.do`: This script takes in the IFE approximated LODES data and reformats it for the eventstudy counterfactual evaluation pipeline.
* `reformat_fe_%.do`: This script takes in the IFE additive fixed effects estimate and reformats it for the eventstudy counterfactual evaluation pipeline.
* `calibrate_lambda.do`: This script takes in the IFE estimate and calibrates the bilateral disutility $\lambda_{kn}$.

## Input
* `labor_b_approx_ife_%.csv.zip`: approximated LODES data using the IFE procedure.
* `nyc2010_time_elasticity_ife_%.csv`: commuting elasticity estimates from the IFE procedure.
* `nyc2010_(orig|dest)_time_ife_%.csv`: additive fixed effects estimates from the IFE procedure.
* `nyc2010_ife_ij_ife_%.csv`: full factor structure, computed as the tract-pair-specific product of the IFE estimates.
