# Amazon_fixednu_visualize_nested

This task visualizes granular uncertainty for the predicted prices and quantities 
in the AHQ2's simulation with the individual's idiosyncratic preference shocks fixed
for the nested-logit specification.

## remark:
* Due to the computational burden, we only implement the fixed nu simulation with zeta = 0.25.
Visualizations are all based on the zeta = 0.25 specification. 

## code:
* `plot_granular_uncertainty_nested.do` creates scatterplots that are analogous to Figure 8.
It is based on `Amazon_fixednu_visualize/code/plot_granular_uncertainty.do`

## output:
* `scatter_gu_%.eps` are scatterplots that depict the change in quantities and percentage change in real prices.
* `report_gu_%.tex` are reports that count the number of significant change under 90 percent confidence interval.
* `AHQ2_%.tex` records the 5th and 95th percentile for the change in employment in the AHQ2 treated tract.

## input:
* `simulation_distribution_%.csv` are summary statistics of the fixed-$\nu$ simuations. 
They are outputs from the task `Amazon_fixednu_analyze_nested`.
* `nyc2010_lodes_wzero_wdelta.dta` is LODES NYC 2010 data with zero commuting flows and commuting costs.
