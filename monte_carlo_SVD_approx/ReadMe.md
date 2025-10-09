# monte_carlo_SVD_approx

This task computes the transformed rank-restricted SVD approximation of the Monte Carlo simulated data 
across different pre-defined ranks.

It generates a total of 2100 zipped CSV files, resulting from 100 simulations across 21 ranks.

## Output
* `DGP_approx_$(Lambda)_$(pop)_$(shock)_$(event)_(rank).csv.zip`: approximated labor allocation 

## Code
* `apply_SVD_to_simulated_data.jl`: takes pre-shock realized draws from Monte Carlo simulations and 
produces transformed low-rank approximation across different ranks. 
This is saved as a .zip file to save on storage requirements.

## input
* `DGP_$(Lambda)_$(pop)_$(shock)_$(event).csv`: before and after the productivity increase simulated by iid Monte Carlo.
