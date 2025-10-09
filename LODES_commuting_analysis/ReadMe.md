# LODES commuting analysis

This task provides summary statistics about LODES commuting data. 

	
## Output
- `(location)_(year)_asymmetriczeros.tex`: calculate the fraction of X_ij==0 when X_ji!=0.
- `(location)_(year)_asymmetriczeros_robust.tex`: calculate the fraction of X_ij==0 when X_ji!=0 and total employment in k and n differs by 10% or less.
- `(location)_(year)_share%(_slides).tex`: the fraction of commuters that have % or fewer commuters in their cell of the commuting matrix.
- `(location)_2013_2014_tabulatezerosfreq.tex`: presents the consistency of pair-level zeros between 2013 and 2014, by frequency.
- `(location)_2013_2014_tabulatezerospct.tex`: presents the consistency of pair-level zeros between 2013 and 2014, by fraction.
- `(location)_2013_2014_zeropersistence.tex`: the fraction of tract pairs with positive flow in 2013 were zeros in 2014.
- `(location)_2013_2014_transition_matrix.tex`: presents the transition matrix for commuting flows of 0, 1, ..., 5+ between 2013 and 2014.
- `(location)_2013_2014_bothzeros.tex`: the fraction of pairs that had zero commuters in both 2013 and 2014.
- `histogram_(location)_(year)_positive(_w_shares).eps`: histogram that reports the number of tract pairs with positive commuting flows.
- `histogram_(location)_(year)_withzeros.eps`: histogram on all commuting flows including zeros.
- `histogram_(location)_(year).eps`: combine `histogram_*_positive.eps` and `histogram_*_withzeros.eps`.
- `histogram_(location)_(year)_topcode.tex`: the 99th percentile number of commuters for a given year and location.
- `(location)_(year)_zeros_prev.tex`: report the number of tract pairs, pairs with zero commuting flows, and pairs with positive commuting flows.
- `(location)_(year)_zeros_prev_slide.tex`: calculate the prevalence of zeros among tract pairs.
- `(location)_(year)_number_tracts.tex`: the number of residential tracts in LODES data.
- `text_count_pop_pair_(location)_(year).tex`: the numbers of resident-employees and tract pairs.
- `(location)_(year)_mediantract_employees.tex`: the statement about median employment tract in a given location.
- `DetroitUA_2013zero_2014pos.tex`: the number of tract tract pairs that had zero commuters in 2013 had at least one commuter in 2014.
- `NYC_2014_count_cells_and_ppl.tex`: reports the numbers of cells, people and average commuters per cell in the commuting matrix.

## Input
- `lodes_(location)_(year).dta`: LODES commuting data.

## Code
- `asymmetriczeros.do`: count the fraction of X_ij==0 when X_ji!=0 in 2014.
- `count_pop_pair.do`: count the number of resident-employees and the number of tract pairs.
- `detroit_descriptives.do`: calculate the number of workers in median tract in terms of employment, and the number of residential tracts, for DetroitUA.
- `merge_geocoords.do`: calculate tract-pair level distance.
- `MSP_descriptives.do`: use functions in  `programs_descriptives.do` to produce summary statistics for the commuting matrix in MSP.
- `NYC.do`: use functions in  `programs_descriptives.do` to produce summary statistics for the commuting matrix in NYC.
- `programs_descriptives.do`: define functions to produce summary statistics on the structure and sparsity of commuting matrices, including the number of matrix cells, total commuters, small-cell shares, and the degree of employment concentration across locations.
- `tractpair_histograms.do`: 
	- plot histograms for commuting flows between tract pairs, for positive commuting flows only and for all commuting flows including zeros;
	- calculate the zero prevalence.
- `tractpair_histograms_w_shares.do`: plot histograms that report the number of tract pairs with positive commuting flows.
- `transitionmatrix.do`:
	- crosstab indicators for zero/positive commuting flows in 2013 and 2014;
	- calculate the transition matrix.
