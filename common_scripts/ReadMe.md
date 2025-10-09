# common scripts

This folder contains scripts used in multiple tasks.
This task cannot be run in isolation; it does not produce output on its own.

## Baseline: data cleaning
- `clean_wage.do`: replicate ORS's method to calculate tract-level wage.
- `convert_labor_b_to_dta.do` : converts approximated labor allocation matrices to dta format for approximated baseline data.
- `data_before.do` prepare relevant single-year data for the year before the shock, including
	- LODES commuting data;
	- commuting cost as a function of transit time;
	- gravity regression;
	- wage level.
- `gravity_saveFE_time.do`: run gravity regression, with transit time specification.
- `nyc_delta.do`
    - merge NYC tract-level transit time with commuting flows,
    - impute missing transit time based on distance.
- `process_lodes.do`: aggregate LODES raw data to tract level, fill in zero commuting flows.

## Counterfactual: computation
- `hat_P.jl`: calculates the change in price index based on A_hat, w_hat, and income share. Multiple dispatch is used to invoke a specific program.
- `employment_gap_fn.jl`: a julia function that evaluates the eha solver for a given set of parameters and returns the difference between its predicted employment increase for a single treated tract and a given employment target.
- `shock_tract.jl`: defines a function that applies a productivity shock to a single tract. Given a productivity vector $A$, it returns a new vector $\hat{A}$ in which only the specified treatment tract’s productivity is scaled by a given factor.
