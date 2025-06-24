# Amazon_fixednu_analyze

This exercise computes summary statistics of the Amazon HQ2's simulation with the individual's idiosyncratic term 
fixed.


## Folder Structure

`code/`:

* `simulation_sumstats.jl`: computes summary statistics of the simulated quantities and real prices across 100 simulations.

`temp/`: 

* `emp_b_avg_ratio_d_realw_sigma_$(sigma).csv`: vector of tract-simulation pair real wages and the ratio of initial employment to its average

`output/`:

* `simulation_distribution_{orig.csv|dest}_sigma_$(sigma).csv`: 
stores summary statistics (mean, p5, p95) of the simulated number of residents and workers as well as the rents and wages
for the origin and the destination tracts for a given value of sigma.

* `AHQ2_d_emp_{p5, p95}_sigma_$(sigma).tex`: the 5th and 95th percentiles of employment change in the Amazon workplace tract for a given value of sigma. 

* `AHQ2_neg_d_{rents, wages}_sigma_$(sigma).tex`: summary statistics of negative real prices and their associated labor allocation for a given value of sigma.

* `scatters_wage_emp_{549, 1980}_sigma_$(sigma).eps`: scatter plots of changes in real wages against the initial labor employment for two tracts for a given value of sigma.
