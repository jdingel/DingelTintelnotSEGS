# Jensen Gap Exhibit
    This task plots the mean of the 100,000 simulations against the CBM's outcomes to get a sense of the Jensen gap. 

## Output
* `jensen_$(var)_comparison_sigma_$(sigma).eps`: Depicts a scatterplot of the mean of all simulations with finite individuals against the CBM's predictions for a given sigma.
* `dev_CCRE_$(var)_p%_sigma_$(sigma).tex`: Reports the %th percentile tract's absolute percent deviation of mean realized value from the continuum-case rational expectation for a given variable and a given sigma.
* `wage_deviation_density.eps`: Depicts the absolute percentage-point deviation of the mean realized wage from the continuum-case rational expectation of the wage.
* `wage_deviation_density_winsorized.eps`: Depicts the absolute percentage-point deviation of the mean realized wage from the continuum-case rational expectation of the wage. Deviations larger than five percentage points are winsorized to five.

## Code
* `compile_jensen.jl`: Compiles all simulations for a given sigma into two files: one for rents, one for wages. 
* `jensen_simulation_$(var)_comparison.do`: Produces the scatterplot for a given sigma and variable.
* `jensen_simulation_wage_density.do`: Plots the absolute percentage-point deviation of the mean realized wage from the continuum-case rational expectation of the wage across the 2,143 workplace tracts.

## Input
* `cbm_(rent|wage)_sigma_$(sigma).csv`: The counterfactual rent/wage predictions for the continuum model with varying values of sigma.
* `jensen_simulation_sigma_$(sigma)_simulation_$(sim).jld2`: The output of the sim-th round of 1,000 simulations for a given sigma.
Contains 1,000 vectors of wages, rents, residents, and employments.

