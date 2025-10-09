# ACS commuting analysis

This task analyzes county-to-county commuting flows reported in American Community Survey (ACS) data. 

## Output
All output are based on distance data from NBER.

- `ACS_(year_range)_dist_within120km.dta`: ACS commuting flows data after cleaning.
-  `descriptive_stats.tex`: report statistics on the number of zero pairs, and the percentage of MOE greater than commuting flows conditional on postive flows.
- `ACS(year_range)_asymmetriczeros_120km.tex`: report the fraction of X\_ij==0 when X_ji!=0 for county pairs within 120km.
- `ACS(year_range)_zeros_120km_slides.tex`: report the zero prevalence among county pairs.
- `20062010_20112015_tabulatezeros_frequency/pct.tex`: the 2x2 table of zero and non-zero flows for 2006-2010 county pairs vs 2011-2015 county pairs.
- `ACS_frac_zero_to_pos.tex`: the fraction of county pairs reporting zero commuters in the 2006--2010 ACS that reported a positive number of commuters in the following five-year interval.
- `ACS_frac_pos_to_zero.tex`: the fraction of county pairs reporting a positive number of commuters that had zero commuters in the following five-year interval.
- `ACS_frac_samebin_7190.tex`: the fraction of county pairs reporting to have 71--90 commuters in 2006--2011 that  appeared in the same bin in the following five-year interval.
- `ACS_frac_lessthan100.tex`: the fraction of non-zero county pairs that report fewer than 100 commuters.
- `heatmap_transition_matrix.eps`: a transition matrix for pairs of counties within 120 kilometers of each other by reported number of commuters in two editions of the ACS.
- `hist_ACS_arbitrary_bin.eps`: a histogram showing the distribution of cross-county commuting flows (2006–2010), used to justify the binning thresholds in the transition matrix.
- `heatmap_integer_0_100.eps`: a heatmap showing the transition probabilities for low-volume cross-county commuter flows (≤100 commuters) between 2006–2010 and 2011–2015.
- `counties_are_granular.tex`: a descriptive summary of cross-county commuting patterns based on 2006–2010 ACS data, highlighting an uneven distribution of commuter flows between US counties.

## Code
- `clean_stats_(distance version).do`: clean ACS data based on `clean_stats_programs_(distance version).do`. 
- `descriptive_stats.do`: Output statistics based on `descriptive_stats_programs.do`. Programs include:
	- descriptive_stats:
		- In what fraction of observations with positive commuting flows does the margin of error exceed the value of the flow?
		- Compute the number of zeros.
	- asymmetriczeros: count the fraction of X\_ij==0 when X_ji!=0.
	- zero_prev: count the zero prevalence among county pairs.
	- zero_persist: produce the 2x2 table of zero and non-zero flows for 2006-2010 county pairs vs 2011-2015 county pairs
- `counties_are_granular.do`: summarizes and visualizes key statistics on cross-county commuting flows in 2006–2010, demonstrating their highly skewed distribution and cumulative concentration patterns.
- `persistence.do`: acquires the number of US country-pairs whose reported number of commuters is less than 100 and heatplots the transition matrix.


## Input
- Commuting data
	- `ACS_(year)_commuting.xlsx`: ACS commuting data for 2006-2010, 2009-2013, 2011-2015.
- Distance data
	- `sf12010countydistance100miles.csv`: county distance that are within 100 miles from NBER.
	- We've regressed log\_dist\_coordinate on log\_dist_distance and R^2=1.0000. So the minor distinction between two datasets doesn't matter. We therefore adopt the distance data from NBER for cleaner code.
