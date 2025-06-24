# LODES commuting analysis

This task provides summary statistics about LODES commuting data. 

It takes under one minute to run the entire task.
	
## Output
- `NYC_2010_number_tracts.tex`: Count number of residential tracts in LODES data
- `histogram_NYC_2010_positive_w_shares.eps`: Histogram of positive commuting flows between pairs of tracts.

## Input
- `2015_gaz_tracts(counties)_(state_FIPS).txt`: tract/county-level geographical coordinates from Census.
- `lodes_(location)_(year)`: LODES commuting data.

## Code
- `tractpair_histograms.do`: 
	- plot histograms for commuting flows between tract pairs, for positive commuting flows only and for all commuting flows including zeros;
	- calculate the zero prevalence.
