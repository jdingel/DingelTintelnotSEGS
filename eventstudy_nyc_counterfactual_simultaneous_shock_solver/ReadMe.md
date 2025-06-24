# eventstudy nyc counterfactual simultaneous shock solver
This task finds a set of shocks that, when applied simultaneously, generate the observed employment increase from 2010 to 2012 across 83 workplace tracts.
The task can be parallelized once the files `../temp/simultaneous_shock_cbm.jld2` and `../temp/simultaneous_shock_csp.jld2` are generated.
Most scripts finish within 30 minutes, while the most time-consuming ones, such as `cbm_sigma_1.1` and `csp_sigma_1.1`, take approximately 50 minutes.

## Output
* `simultaneous_shock_(model-variation).jld2`: Reports the productivity shock vector for the given model variation that matches the 2010-2012 observed employment change. 
There are 73 specifications corresponding to 72 `.jld2` files. 
The CBM-no-extensive-margin specification shares the same shock as the plain vanilla CBM.

## Code
* `guess_shocks.jl`: Provides numerical guess for the shocks that generate the observed changes in employment.
* `find_shocks_%.jl`: 
Uses `shock_solver_loop` to find the shocks that generate the observed changes in employment.
* `simultaneous_shock_solver.jl`: 
Creates an outer loop that updates the productivity shocks.
Given a set of productivity shocks, the inner loop uses the EHA solver (`eha_solver.jl`) to compute the counterfactual employment.
* `data_prep_functions.jl`: Functions to load and prepare the data (i.e., baseline employment, observed employment differences (in ratio), observed employment differences (in levels), and a list of treatment locations for the simultaneous shock solver.

## Input
* `eha_solver.jl`: Exact hat algebra solver.
* `model_(model-variation).jld2`: A tuple of {`model_class`, $\alpha, \epsilon, \sigma, \eta, \zeta$, `nests`, $\ell$ -share,  $y$ -share}.
* `nyc2010_lodes_wzeros_wdelta.dta`: LODES NYC 2010 data (including zeros).
* `nyc_2012_2010_observed_changes_dest_tract.dta`: Vector of change in employment from 2010 to 2012 by workplace tract.
* `nyc_20102012_spikes_list.txt`: List of tracts that experienced employment booms in 2010-2012.
