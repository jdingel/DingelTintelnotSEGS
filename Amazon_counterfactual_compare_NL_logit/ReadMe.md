# Amazon_counterfactual_compare_NL_logit

This task compares the counterfactual predictions of commuters to AHQ2 between the nested-logit CBM and the logit CBM.
The nested-logit CBM is calibrated with zeta = 0.25 and 0.75.
It also visualizes the change in residents for the nested-logit specification with zeta = 0.25.

## Outputs
* `ell_nested_comparison_plots_%.eps`: scatterplot that compares nested-logit outcomes (vertical axis) to logit outcomes (horizontal axis) of the change in the commuters to AHQ2. 

* `map_cont_change_res_nested.png`: map that visualizes the change in residents for the nested-logit specification (zeta = 0.25). It is comparable with `Amazon_counterfactual_visualzie/output/map_cont_reschange.png`.

## Inputs
* `amazon_ctfl_tract_cbm_ntaorigin_(zeta)_ell.csv`: The counterfactual equilibrium outcomes of commuting flows in the CBM with nested-logit idiosyncratic preference shocks. 

* `amazon_ctfl_tract_cbm_sigma_4.0_ell.csv`: The counterfactual equilibrium outcomes of commuting flows in the CBM with logit idiosyncratic preference shocks. 

* `nyc2010_lodes_wzero_wdelta.dta`: LODES NYC 2010 data with zero commuting flows and commuting costs.

* `map_res.do` `map.do` `geoid11_coords.dta` `geoid11_database.dta` `geoid11_maptile.ado`: Map templates and functions.

## Code for scatterplot
* `compare_ell_predict_nested.do`: creates a scatterplot that compares the nested-logit outcomes (vertical axis) to logit outcomes (horizontal axis) of the level change in commuters to AHQ2. 

## Code for map
* `plot_map_res_change.do`: creates a map of the change in residents for the nested-logit setting. 
