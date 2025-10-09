# Amazon_fixednu_analyze_nested

This task performs two jobs for the nested-logit specification. It
(i) creates summary statistics for the fixed-$\nu$ simulations, and
(ii) validates the simulation results by comparing the simulated commuting shares 
(before and after the shock) to the corresponding shares in the continuum model.

## remark:
* Due to the computational burden, we only implement the fixed nu simulation with zeta = 0.25.
The following code and exhibits are all based on the zeta = 0.25 specification. 

## code
* `simulation_sumstats_nested.jl`: creates summary statistics for the fixed-$\nu$ simulations.
It is analogous to `Amazon_fixednu_analyze/code/simulation_sumstats.jl`.


## input
* `simulation_fixednu_0.25_$(simulation)_nested.jld2`: simulated prices and quantities.


## output
* `simulation_distribution_{orig|dest}_nested.csv`: summary statistics (e.g., mean, p5, p95, std) of simulated prices and quantities.