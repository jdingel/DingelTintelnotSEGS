# eventstudy nyc counterfactual compute simultaneous
This task computes the counterfactual equilibrium when 83 productivity increases are imposed simultaneously for a variety of model variations.
This task takes less than two minutes per specification.

## Output
* `nyc_obs_`model variation`_all.csv`: The predicted 2012 commuting flows from the given model variation.

* Model-Variations
    * `cbm_sigma_4.0`: Vanilla CBM model
    * `csp_sigma_4.0`: Vanilla CSP model 
    * `cbm_sigma_(value)`: CBM model with a given elasticity of substitution ($\sigma$).
    * `csp_sigma_(value)`: CSP model with a given elasticity of substitution ($\sigma$). 
    * `cbm_deltainf`: CBM model with no extensive margin 
    * `svd_(R)`: Model calibrated using a rank `(R)` SVD approximation of the 2010 baseline data.
    * `nnmf_(R)`: Model calibrated using a rank `(R)` non-negative matrix-factored approximation of the 2010 baseline data.
   * `ife_(R)`: Model calibrated using a rank R interactive fixed effect (IFE) model to capture unobserved spatial linkages.
    * `cbm_ntaorigin_(ζ)`: Nested-logit CBM model with the origin NTA as the outer nest.
    * `csp_ntaorigin_(ζ)`: Nested-logit CSP model with the origin NTA as the outer nest.
    * `cbm_workplace_(ζ)`: Nested-logit CBM model with the workplace as the outer nest.
    * `csp_workplace_(ζ)`: Nested-logit CSP model with the workplace as the outer nest.

## Code
* `compute_counterfactual_eqlm.jl`: 
Takes in all 83 shocks and computes the counterfactual equilibrium.

## Input
* `eha_solver.jl`: Exact hat algebra solver.
* `model_%.jld2`: Packed models consist of { $\alpha, \epsilon, \sigma, \eta, \zeta$, nests, $\ell$ -share,  $y$ -share}.
* `nyc2010_lodes_wzeros_wdelta.dta`: LODES NYC 2010 data (including zeros).
* `simultaneous_shock_%.jld2`: Productivity shock vector for the given model variation that matches the 2010-2012 observed employment change. 