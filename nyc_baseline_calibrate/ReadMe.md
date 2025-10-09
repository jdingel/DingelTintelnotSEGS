# NYC baseline calibrate

This task calibrates the model primitives per model specifications.

## Output
* `primitives_nyc2010_%.jld2`: stores the economic primitives ($\epsilon$, $\alpha$, $\eta$, $\zeta$, $\sigma$, $T$, $A$, $\tilde{r}$, $\tilde{w}$, $\bar{\delta}$, $\lambda$, population) of specification `%`.
It also includes vectors of `origin_FIPS` and `destination_FIPS`.
Note that 
* the order of `origin_FIPS` corresponds to the orderings of $T$ and $\tilde{r}$.
* the order of `destination_FIPS` corresponds to the orderings of $A$ and $\tilde{w}$.

## Code
* `calibrate_function.jl`: solves $A$ and $T$ given origin and destination fixed effects, $\epsilon$, $\alpha$, $\eta$, $\zeta$, $\sigma$, $T$, $A$, $\tilde{r}$, $\tilde{w}$, $\bar{\delta}$, $\lambda$, `nests`, and population.
* `calibrate_main.jl`: loads the inputs and calibrates the primitives using `calibrate_function.jl`.
* `calibrate_nested.jl`: loads the inputs and calibrates the primitives using `calibrate_function.jl` for the nested-logit specifications.

## Input
* `nyc_pool_2008_2010_lodes_wzero_wdelta.dta`, `nyc_pool_2008_2010_orig_time.dta`, `nyc_pool_2008_2010_dest_time.dta`, `nyc_pool_2008_2010_time_elasticity.csv`: LODES NYC 2008 and 2010 data.
* `nyc2010_orig_dist.dta`, `nyc2010_dest_dist.dta`: Origination/destination tract fixed effects for commuting flows with google maps times predicted from distance as bilateral covariate.
* `nyc2010_lodes_wzero_wdelta_dist.dta`: LODES data from stub with zero commuting flows and distance-predicted commuting costs.
* `nyc2010_time_elasticity_dist.csv`: commuting time elasticity in preperiod.
* `nyc_NTA_2010_orig_FE.dta`,`nyc_NTA_2010_dest_FE.dta`: NTA-level origination/destination tract fixed effect for 2010.
* `nyc2010_orig_time_ife_%.dta`, `nyc2010_dest_time_ife_%.dta`: additive fixed effects estimates from the IFE procedure.
* `nyc_NTA_2010_lodes_wzero_wdelta.dta`: LODES NYC 2010 data at the NTA level (including zeros).
* `nyc_NTA_2010_time_elasticity.csv`: time elasticity implied by gravity model.
* `nyc2008_time_elasticity.csv`: commuting time elasticity in 2008.
* `nyc2010_time_elasticity_ife_%.csv`: commuting elasticity estimates from the IFE procedure.
* `nyc2010_lambda_ife_%.dta`: calibrated bilateral disutilities between residence and workplace tract pairs.
* `nyc2010_census_tabulation.dta`: census tract-NTA crosswalk.
