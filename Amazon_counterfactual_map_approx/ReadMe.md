# Amazon counterfactual map approx

This task visualizes output from `Amazon_counterfactual_compute_approx`, using maps.
To achieve the format used in the paper, this code needs to be ran in the stata client.

Note:
The `map_res.do` file rounds the baseline data to the nearest integer.

## Output
* `text_Amazon_{svd16|ife1}_rent_topdecile.tex`: mean real rent changes at the top decile predicted by the SVD rank 16 model or the IFE rank 1 model.
* `map_res2010_{svd16|ife1}.png`: map of the number of residents in 2010 for the SVD rank 16 model or the IFE rank 1 model.
* `map_reschange_svd16.png`: map of changes in the number of residents predicted by the SVD rank 16 model.
* `map_{svd16|ife1}_reschange_cutoff.png`: map of changes in the number of residents predicted by the SVD rank 16 model or the IFE rank 1 model using percentiles the same as `Amazon_counterfactual_visualize/output/map_cont_reschange.png`.
* `map_empchange_{svd16|ife1}.png`: map of changes in the number of workers predicted by the SVD rank 16 model or the IFE rank 1 model.
* `map_{svd16|ife1}_hat_realr(w).png`: map of changes in real rent (wage) predicted by the SVD rank 16 model or the IFE rank 1 model.
* `map_{svd16|ife1}_hat_realr(w)_cutoff.png`: map of changes in real rent (wage) predicted by the SVD rank 16 model or the IFE rank 1 model using percentiles the same as `Amazon_counterfactual_visualize/output/map_cont_reschange.png`.

## Input
* `run.sbatch`: a batch script to Slurm.
* `map_res.do` `map.do` `map_cutoff.do` `geoid11_coords.dta` `geoid11_database.dta` `geoid11_maptile.ado`: map templates and functions.
* `amazon_ctfl_tract_{svd_16|ife_1}_(variable).csv`: counterfactual results for the SVD rank 16 model or the IFE rank 1 model and a given variable. 
Variables include "ell" which are commuting flows, "rent" which are rents, and "wage" which are wages.
* `nyc_2010_levels_tracttotract_approx_{svd_16|ife_1}.dta.zip`: LODES data from nyc in 2010 with zero commuting flows and commuting costs after applying the SVD rank 16 model or the IFE rank 1 model.

## Code
* `map_svd.do`
	* plot maps of price changes and quantity changes predicted by the SVD,
	* plot map of the number of residents working at the treatment tract in the SVD baseline data.

* `map_ife.do`
	* plot maps of price changes and quantity changes predicted by the SVD,
	* plot map of the number of residents working at the treatment tract in the ife1 baseline data.
