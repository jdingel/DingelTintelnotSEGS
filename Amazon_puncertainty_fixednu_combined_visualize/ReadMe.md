# Amazon p-uncertainty Fixednu Combined Visualize
This task takes the counterfactual predictions of rents, wages, employment, and residents from the 100 parameter uncertainty and fixed-$\nu$ scenarios and creates a set of scatterplots that show the variation between the 5th and 95th percentile prediction for each tract in each of the four outcomes.

## Output
* `fixednu_puncertainty_scatter_$(var).eps`: Scatterplot of 5th and 95th percentile predictions for each tract for outcome var for both the fixed-$\nu$ and bootstrapped (puncertainty) simulations.
There are two "types" of variables, "orig" and "dest". 
"Orig" includes rents and residents. 
"Dest" includes wages and employment.

## Code
* `fixednu_puncertainty_combined_scatter_exhibit_$(type).do`: Produces the scatterplots above for the given type.

## Input
* `cont_(var)_puncertainty_#.csv`: The AHQ2 counterfactual predictions for the parameter uncertainty scenario #. 
This output contains results for employment, rents, wages, and residents.
* `simulation_distribution_{orig|dest}_sigma_$(sigma).csv`: 
stores summary statistics (mean, p5, p95) of the simulated number of residents and workers as well as the rents and wages for the origin and the destination tracts for a given value of sigma.