# monte_carlo_iid_dgp
This task simulates labor allocations from a multinomial distribution characterized by the labor share of continuum models for the pre-period and the post-period with a productivity shock imposed on the Tiffany tract.

The "iid" in the title reflects the assumption that
the idiosyncratic logit shocks are i.i.d. draws from T1EV distribution before and after the shock.

This is a very computationally expensive task that needs to be run on a high-performance computing cluster.


## output
* `DGP_$(Λ)_$(headcount)_$(A_shock)_$(sim).csv`: labor allocation before and after the productivity increase.
where `$(Λ)` $= 0, 0.1, 0.25, 0.5, 1$.
`$(headcount)` $= 2.488905, 5, 12.5, 25, 50, 125, 250, 2560$.
`$(A_shock)` $= 1.09$.
`$(sim)` $= 1,2,..,100$.
Note that labor allocations are not integers when 2,488,905 is not a divisor of `headcount`.
* `nyc2010_lodes_wzero_wdelta.csv`: commuting flows in NYC 2010 (including zeros) and integer-valued location indices starting from 1.

## code
* `data_prep.do`: converts 11-digit FIPS into a list of indices starting from 1.
* `DGP.jl`: simulates labor allocations from a multinomial distribution characterized by the labor share of the continuum models.
Given a parameterized continuum model (the NYC 2010 baseline),
`DGP.jl` takes four arguments:
- the standard deviation of the unobserved component of commuting costs (Λ)
- the number of individuals in the economy (`headcount`)
- the size of the productivity shock (`A_shock`)
- a random seed (simulation number)

## input
* `nyc2010_time_elasticity.csv`: baseline NYC 2010 data.
* `nyc2010_lodes_wzero_wdelta.dta`: commuting flows in NYC 2010, with zero commuting flows.
* `primitives_nyc2010_time.jld2`: productivities, land endowments, population (=2,488,905), wage and rent beliefs, and commuting costs.