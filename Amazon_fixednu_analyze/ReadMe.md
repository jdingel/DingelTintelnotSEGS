# Amazon_fixednu_analyze

This exercise computes summary statistics of the Amazon HQ2's simulation with the individual's idiosyncratic term fixed.


## Folder Structure

`code/`:

* `simulation_sumstats.jl`: computes summary statistics of the simulated quantities and real prices across 100 simulations.

`output/`:

* `simulation_distribution_{orig|dest}_sigma_$(sigma).csv`: 
stores summary statistics (mean, p5, p95) of the simulated number of residents and workers as well as the rents and wages for the origin and the destination tracts for a given value of sigma.

* `AHQ2_d_emp_{p5, p95}_sigma_$(sigma).tex`: the 5th and 95th percentiles of employment change in the Amazon workplace tract for a given value of sigma. 

`input/`:

* `simulation_fixednu_$(sigma)_$(simulation).jld2`: stores the real wages and rents as well as the number of residents and workers before and after the shock.
