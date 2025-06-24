# NYC baseline calibrate

This task calibrates the model primitives per model specifications.

## Output
* `primitives_nyc2010_%`: stores the economic primitives ($\epsilon$, $\alpha$, $\eta$, $\zeta$, $\sigma$, $T$, $A$, $\tilde{r}$, $\tilde{w}$, $\bar{\delta}$, $\lambda$, population) of specification %.
It also includes vectors of `origin_FIPS` and `destination_FIPS`.
Note that 
* the order of `origin_FIPS` corresponds to the orderings of $T$ and $\tilde{r}$.
* the order of `destination_FIPS` corresponds to the orderings of $A$ and $\tilde{w}$.

## Code
* `calibrate_function.jl`: solves $A$ and $T$ given origin and destination fixed effects, $\epsilon$, $\alpha$, $\eta$, $\zeta$, $\sigma$, $T$, $A$, $\tilde{r}$, $\tilde{w}$, $\bar{\delta}$, $\lambda$, `nests`, and population.
* `calibrate_main.jl`: loads the inputs and calibrates the primitives using `calibrate_function.jl`.
* `calibrate_nested.jl`: loads the inputs and calibrates the primitives using `calibrate_function.jl` for the nested-logit specifications.