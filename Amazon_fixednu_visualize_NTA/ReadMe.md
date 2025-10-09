# Amazon_fixednu_visualize_NTA

This task visualizes granular uncertainty for the predicted prices and quantities in the Amazon HQ2's simulation with the individual's idiosyncratic term fixed, using Neighborhood Tabulation Areas (NTAs) as the geographic units.


## code
* `plot_granular_uncertainty_NTA.do`: plots dispersion of the predicted quantities and real prices and reports the number of NTAs having significant changes.

## input
* `simulation_distribution_{orig|dest}_NTA.csv`: stores summary statistics (mean, p5, p95) of the simulated number of residents and workers as well as the rents and wages for the origin and the destination NTAs.
* `NTA_commutingflows_2010.dta`: NTA-level commuting flow data for 2010.

## output
* `report_gu_real{r|w}_fixednu_NTA.tex`: 
reports the number of origin/destination NTA whose change in price is positive within 90% confidence interval.
* `report_gu_{emp|res}_sigfchange_fixednu_NTA.tex`: 
reports the number of origin/destination NTA whose change in quantities is insignificant under 90% CI.
* `scatter_gu_{emp|res}_simulation_fixednu_NTA.eps`:
plots the dispersion of the predicted quantities for NTAs.
* `scatter_gu_real{r|w}_simulation_fixednu_sumstats_diff_NTA.eps:`
plots the dispersion of the predicted prices for NTAs.
* `AHQ2_d_emp_p{5|95}_treatedNTA.tex`: 
reports the 5th to 95th percentile change in employment for treated NTA.
* `report_gu_NTA_sigchange_realr_p{5|95}_wrt_city_mean.tex`: 
reports the number of origin NTAs who have a change in rents at the 5th percentile larger or 95th percentile smaller than the citywise mean change.