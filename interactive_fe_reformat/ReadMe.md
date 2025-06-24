# eventstudy_interactive_fe_reformat
This task reformats the interactive fixed effects baseline commuting shares data into a format that is more easily used by eventstudy counterfactual evaluation pipeline. 

## Output
* `nyc_2010_levels_tracttotract_approx_ife_1.dta.zip`: approximated LODES data using the IFE procedure, reformatted for the eventstudy counterfactual evaluation pipeline.
## Code
* `reformat_ife_data.do`: This script takes in the IFE approximated LODES data and reformats it for the eventstudy counterfactual evaluation pipeline.
* `reformat_fe_%.do`: This script takes in the IFE additive fixed effects estimate and reformats it for the eventstudy counterfactual evaluation pipeline.
* `calibrate_lambda.do`: This script takes in the IFE interactive fixed effects estimate and calibrates the bilateral disutility $\lambda_{kn}$.

## Input
* `labor_b_approx_ife_1.csv.zip`: approximated LODES data using the IFE procedure.

This task takes approximately 10 second to run.