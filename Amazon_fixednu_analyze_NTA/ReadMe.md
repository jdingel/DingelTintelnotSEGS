# Amazon_fixednu_analyze_NTA

This tasks computes summary statistics for the AHQ2 fixed-nu simulations with Neighborhood Tabulation Areas (NTAs) as the geographic units.

## code:
* `simulation_sumstats_NTA.jl`: computes summary statistics of the simulated quantities and real prices across 100 simulations.


## output:
* `simulation_distribution_{orig|dest}_NTA.csv`: 
stores summary statistics (mean, p5, p95) of the simulated number of residents and workers as well as the rents and wages for the origin and the destination NTAs.

* `wage_change_all_sim_NTA.csv`:
stores 100 simulated wages for 194 workplace NTAs.


## input:
* `simulation_fixednu_NTA_s$(simulation).jld2`: stores the real wages and rents as well as the number of residents and workers before and after the shock.