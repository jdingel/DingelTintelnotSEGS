# eventstudy nyc counterfactual compute simultaneous
This task computes the counterfactual equilibrium when 83 productivity increases are imposed simultaneously for a variety of model variations.

## Output
* `nyc_obs_(model-variation)_all.csv`: The predicted 2012 commuting flows from the given model variation.

* Model-Variations
    * `cbm_sigma_4.0`: Vanilla CBM
    * `csp_sigma_4.0`: Vanilla CSP model 
    * `cbm_sigma_(value)`: CBM with a given elasticity of substitution ($\sigma$).
    * `csp_sigma_(value)`: CSP model with a given elasticity of substitution ($\sigma$). 
    * `cbm_eta_(value)`: CBM with an agglomeration elasticity of ($\eta$).
    * `csp_eta_(value)`: CSP model with an agglomeration elasticity of ($\eta$). 
    * `cbm_deltainf`: CBM with no extensive margin 
    * `cbm_pool_2008_2010`: CBM that uses a 2008-2010 three year pooled dataset to calibrate the model
    * `csp_pool_2008_2010`: CSP model that uses a 2008-2010 three year pooled dataset to calibrate the model.
    * `cbm_dist`: CBM with a distance-predicted commuting cost matrix.
    * `cbm_nta`: CBM calibrated using 2010 NTA-aggregated baseline data.
    * `csp_nta`: CSP model calibrated using 2010 NTA-aggregated baseline data.
    * `svd_(R)`: Model calibrated using a rank `(R)` SVD approximation of the 2010 baseline data.
    * `nnmf_(R)`: Model calibrated using a rank `(R)` non-negative matrix-factored approximation of the 2010 baseline data.
   * `ife_(R)`: Model calibrated using a rank R interactive fixed effect (IFE) model to capture unobserved spatial linkages.
    * `cbm_ntaorigin_(ζ)`: Nested-logit CBM with the origin NTA as the outer nest.
    * `csp_ntaorigin_(ζ)`: Nested-logit CSP model with the origin NTA as the outer nest.
    * `cbm_workplace_(ζ)`: Nested-logit CBM with the workplace as the outer nest.
    * `csp_workplace_(ζ)`: Nested-logit CSP model with the workplace as the outer nest.
    * `cbm_residence_(ζ)`: Nested-logit CBM with the residence as the outer nest.
    * `csp_residence_(ζ)`: Nested-logit CSP model with the residence as the outer nest.

## Code
* `compute_counterfactual_eqlm.jl`: 
Takes in all 83 shocks and computes the counterfactual equilibrium.
* `compute_counterfactual_eqlm_cbm_deltainf.do`:
Computes the counterfactual equilibrium for the CBM with no extensive margin.

## Input
* `eha_solver.jl`: Exact hat algebra solver.
* `model_%.jld2`: Packed models consist of { $\alpha, \epsilon, \sigma, \eta, \zeta$, nests, $\ell$ -share,  $y$ -share}.
* `nyc2010_lodes_wzero_wdelta.dta`: LODES NYC 2010 data (including zeros).
* `nyc_pool_2008_2010_lodes_wzero_wdelta.dta`: LODES NYC 2008 and 2010 data (including zeros).
* `nyc_NTA_2010_lodes_wzero_wdelta.dta`: LODES NYC 2010 data at the NTA level (including zeros).
* `simultaneous_shock_%.jld2`: Productivity shock vector for the given model variation that matches the 2010-2012 observed employment change. 
