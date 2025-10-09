# Amazon counterfactual visualize

This task visualizes output from `Amazon_counterfactual_compute`, plotting maps of statistics predicted by different models (covariates-based model, calibrated-shares procedure).

Notes
* To keep the border style of the census tract and the legend fonts consistent with the paper, it is recommended to run Stata map-plotting scripts from the GUI window rather than the terminal and save the outputs as PNG files.

## Output
* `map_cont_res(emp)change.png`: map of changes in the number of residents (workers employed) predicted by the covariates-based model.
* `map_cont_change_realr(w).png`: map of changes in real rent (wage) predicted by the covariates-based model.
* `map_res2010.png`: map of the number of residents working at the treatment tract.
* `map_emp2010.png`: map of the tract-level employment.
* `map_empchange_cs.png`: map of changes in the number of workers predicted by the calibrated-share procedure.
* `map_cs_changeres.png`: map of changes in the number of residents predicted by the calibrated-share procedure.
* `map_cs_hat_realr(w).png`: map of changes in real rent (wage) predicted by the calibrated-share procedure.
* `map_cs_hat_realr(w)_cutoff.png`: map of changes in real rent (wage) predicted by the calibrated-share procedure using percentiles the same as `map_cont_reschange.png`.
* `text_Amazon_cs_rent_XXpct.tex`: the number of tracts with rent increases greater than XX% predicted by the calibrated-shares procedure.
* `text_Amazon_CBM_rent_topdecile.tex`: mean real rent changes at the top decile predicted by the finite model, based on 100,000 simulations.

## Input
* `map_res.do` `map.do` `geoid11_coords.dta` `geoid11_database.dta` `geoid11_maptile.ado`: map templates and functions.
* `nyc2010_lodes_wzero_wdelta.dta`: commuting flows in NYC 2010, with zero commuting flows.
* `amazon_ctfl_tract_csp_sigma_4.0_{rent,wage,ell}.csv`: statistics produced under the calibrated-shares procedure.
* `amazon_ctfl_tract_cbm_sigma_4.0_{rent,wage,ell}.csv`: statistics produced under the covariates-based model.
* `simulation_orig(dest).csv`: mean change in quantities and prices based on 10,000 simulations and 100,000 simulations.

## Code
* `map_cont_ell(price).do`: plot maps of quantity (price) changes predicted by the covariates-based model.
* `map_cs.do`
	* plot maps of price changes and quantity changes predicted by the calibrated-shares procedure,
	* plot map of the number of residents working at the treatment tract in the observed data.
* `map_cutoff.do`: plot maps of price changes predicted by the finite model and the calibrated-shares procedure by allowing a flexible percentile of the variable as function argument.
* `map_granular_s1_s10.do`: plot maps of price changes and quantity changes predicted by the finite model, based on 10,000 simulations and 100,000 simulations.