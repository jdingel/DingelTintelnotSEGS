# nyc baseline data (non-negative matrix factorization)

This task prepares baseline data for event studies in New York City using approximation via non-negative matrix factorization.
Specifically, we apply the following procedure to the 2010 LODES commuting data:
 - compute a low-rank approximation using NNMF, and
 - rescale entries so that the total sum matches the observed population.

## Output
* `nyc_2010_levels_tracttotract_nnmf_$(RANK).dta.zip`: Non-negative matrix factored vector of approximated 2010 commuter count levels for tract pairs.
* `zeros_share_nnmf_$(rank).txt`: records the proportion of the approximated matrix entries which are exactly zero.

## Code
* `labor_approximation_nnmf.jl`:
This script takes in the raw LODES data with commute costs, and computes the non-negative matrix factorization approximation of input rank.
It saves the approximated matrix in the long format (together with unmodified commute costs) to .csv.

## Input
* `nyc2010_lodes_wzero_wdelta.dta`: raw LODES data for 2010, including commuting costs.
* `convert_labor_b_to_dta.do` : converts the approximated labor allocation matrix to Stata format

## Temp
* `labor_b_approx_nnmf_$(rank).csv`: approximated LODES data, prior to being zipped for final output.
