# Amazon counterfactual visualize

This task visualizes output from `Amazon_counterfactual_compute`, plotting maps of statistics predicted by different models (covariates-based model, calibrated-shares procedure).

It takes less than 1 minute to run the entire task.

Notes
* To keep the border style of the census tract and the legend fonts consistent with the paper, it is recommended to run Stata map-plotting scripts from the GUI window rather than the terminal and save the outputs as PNG files.

## Output
* `map_cont_reschange.png`: changes in the number of residents predicted by the covariates-based model.
* `map_cont_change_realr.png`: changes in real rent predicted by the covariates-based model.
* `map_res2010.png`: map of the number of residents working at the treatment tract.
* `map_cs_changeres.png`: map of changes in the number of residents predicted by the calibrated-share procedure.
* `map_cs_hat_realr.png`: map of changes in real rent predicted by the calibrated-share procedure.

## Input
* `map_res.do` `map.do` `geoid11_coords.dta` `geoid11_database.dta` `geoid11_maptile.ado`: map templates and functions.
* `nyc2010_lodes_wzero_wdelta.dta`: commuting flows in NYC 2010, with zero commuting flows.
* `amazon_ctfl_tract_csp_sigma_4.0_{rent,wage,ell}.csv`: statistics produced under the calibrated-shares procedure.
* `amazon_ctfl_tract_cbm_sigma_4.0_{rent,wage,prob,ell}.csv`: statistics produced under the covariates-based model.

## Code
* `map_cont_ell(price).do`: plot maps of quantity (price) changes predicted by the covariates-based model.
* `map_cs.do`
	* plot maps of price changes and quantity changes predicted by the calibrated-shares procedure,
	* plot map of the number of residents working at the treatment tract in the observed data.

