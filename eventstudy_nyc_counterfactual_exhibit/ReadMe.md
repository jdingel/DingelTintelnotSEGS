# eventstudy nyc counterfactual exhibit
This task plots the results for the slope, intercept, and MSE ratios of eventstudy_nyc_counterfactual_analyze into a set of figures used in the paper. 
This task currently creates simultaneous productivity shock figures and .tex file counterparts to those produced in `eventstudy_nyc_counterfactual_analyze`. 

## Output
* `'model 1'_vs_'model 2'_histogram_exhibit.eps`: 
Displays a histogram of the ratio of model 1 to model 2's MSE for all treatment locations. 
* `'model 1'_vs_'model 2'_kdensity_exhibit`: 
Displays a kdensity plot of model 1's and model 2's slopes and intercepts from regressing their predicted changes on the observed changes for all treatment locations. 

## Models
* `cbm_sigma_4.0`: 
The covariates-based model with the simultaneously computed productivity shocks that was calibrated using 2010 baseline data.
* `csp_sigma_4.0`: 
The calibrated shares procedure with the simultaneously computed productivity shocks that was calibrated using 2010 baseline data.
* `cbm_deltainf`:
The covariates-based model with simultaneously computed productivity shocks that was calibrated using 2010 baseline data and no extensive margin.
* `svd_(R)`:
Model calibrated using a rank R SVD approximation of the 2010 baseline data.

## Input
* `slope_int_MSE_all_(model).csv`: 
The slope, intercept, MSE, and tract ID for all tracts under the specified model.

## Code
* `plotting_functions.do`:
Creates helper functions `kdensitymaker`, `slope_kdensitymaker`,
`int_kdensitymaker`, `stub_to_title`, `optimal_kdensity_bounds`
given two sets of slopes and intercepts, figure text, and an output filename.
* `mse_histogram_exhibitor.do`: 
Loads and processes a pair of MSEs before using the program in histogrammaker.do to develop a histogram plot. 
* `slope_int_kdensity_exhibitor.do`: 
Creates a kdensity plot comparing the slopes and intercepts of two models from regressing the models' respective predicted changes on the observed changes.

This task takes about 1 minute to run. 
Do not parallelize, otherwise you may get duplicate text in your .tex output files. 