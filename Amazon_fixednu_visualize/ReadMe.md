# Amazon_fixednu_visualize

This exercise visualizes granular uncertainty for the predicted prices and quantities 
in the Amazon HQ2's simulation with the individuals' idiosyncratic term fixed.
Note: Mapping script `plot_gu_map.do` needs to be run in a Stata GUI client.

## Folder Structure

`code/`:

* `plot_granular_uncertainty.do`: plots dispersion of the predicted quantities and real prices

* `plot_gu_map.do`: visualizes the simulated changes in the real prices on the map

* `table_figure_simulation_bydistbin_dest.do`, `table_figure_simulation_bydistbin_orig.do`: creates a set of figures and tables that report the change in the predicted quantities by distance bins

`output/`:

* `map_gu_real{r|w}change_fixednu_sigma_$(sigma).png`, `map_gu_real{r|w}change_fixednu_mean_change_sigma_$(sigma).png`: 
visualizes the simulated changes in real prices on the NYC map with two different specifications for a given value of sigma.

* `report_gu_real{r|w}_fixednu_sigma_$(sigma).tex`: 
reports the number of origin/destination tracts whose change in price is positive within 90% confidence interval for a given value of sigma.

* `scatter_gu_{emp/res}_simulation_fixednu_sumstats_diff_sigma_$(sigma).eps:`
plots the dispersion of the predicted quantities for a given value of sigma.

* `scatter_gu_real{r|w}_simulation_fixednu_sumstats_diff_sigma_$(sigma).eps:`
plots the granular uncertainty of the simulated prices with two different specifications for a given value of sigma.

* `AHQ2_(VARIABLE)_bydistbin_fixednu_sigma_$(sigma).tex`: Change in variables by distance bins for a given value of sigma.
Variables include residents_rents and employment_wages.

* `AHQ2_{rents|residents|wages|emp}_bydistbin_fixednu_sigma_$(sigma).eps`: Change (mean and 90% confidence interval) in predicted variables by distance bins for a given value of sigma.

* `outlier_note_gu_emp_fixednu_sigma_$(sigma).tex`: outlier cases with employment declines greater than 1,000.

* `report_gu_emp_fixednu_sigma_$(sigma).tex`: reports the number of non-Amazon workplaces whose 90% confidence interval for the change in employment includes zero.

`input/`:

* `simulation_bydistbin_fixednu_{orig|dest}_sigma_$(sigma).csv`: aggregates the simulated changes in rents, residents, wages, and employment by distance bins for a given value of sigma.

* `simulation_distribution_{orig|dest}_sigma_$(sigma).csv`: stores summary statistics (mean, p5, p95) of the simulated number of residents and workers as well as the rents and wages for the origin and the destination tracts for a given value of sigma.

* `nyc2010_lodes_wzero_wdelta.dta`: LODES NYC 2010 data with zero commuting flows and commuting costs.

* `amazon_ctfl_tract_cbm_sigma_$(sigma)_prob.csv`: counterfactual flow probabilities for the CBM.

* `amazon_ctfl_tract_cbm_sigma_$(sigma)_{wage|ell}.csv`: counterfactual predictions of wages and commuting flows for the CBM. 

* `map.do` `geoid11_coords.dta` `geoid11_database.dta` `geoid11_maptile.ado`: map templates and functions.
