# nyc baseline calibrate exhibits
This task compares the price beliefs of the nested-logit specification to those of the baseline specification.

## output
* `compare_wage_$(nest).png`, `compare_rent_$(nest).png`, `compare_productivity_$(nest).png`, `compare_landendowment_$(nest).png`:
are scatterplots that compare nested-logit outcomes (vertical axis) to logit outcomes (horizontal axis).

## code 
* `compare_prices.jl`: compares the price beliefs of the nested-logit specification to those of the baseline specification.

## input
* `primitives_nyc2010_%`: stores the economic primitives ($\epsilon$, $\alpha$, $\eta$, $\zeta$, $\sigma$, $T$, $A$, $\tilde{r}$, $\tilde{w}$, $\bar{\delta}$, $\lambda$, population) of specification %.