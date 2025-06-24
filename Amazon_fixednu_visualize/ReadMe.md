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

* `scatter_gu_{emp/res}_simulation_fixednu_sigma_$(sigma).eps:`
plots the dispersion of the predicted quantities for a given value of sigma.

* `scatter_gu_real{r|w}_simulation_fixednu_sigma_$(sigma).eps`,`scatter_gu_real{r|w}_simulation_fixednu_sumstats_diff_sigma_$(sigma).eps:`
plots the granular uncertainty of the simulated prices with two different specifications for a given value of sigma.

* `(VARIABLE)_bydistbin_fixednu_sigma_$(sigma).tex`: Change in a variable by distance bins for a given value of sigma.
Variables include residents, employment, wages, and rents.

* `AHQ2_{rents|residents|wages|emp}_bydistbin_fixednu_sigma_$(sigma).eps`: Change (mean and 90% confidence interval) in predicted 
variables by distance bins for a given value of sigma.
