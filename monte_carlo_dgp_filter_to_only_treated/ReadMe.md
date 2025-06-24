# monte_carlo_iid_dgp_filter_to_only_treated

This task takes the commuting flows created in `monte_carlo_iid_dgp` and reduces them down to only include the origin-destination pairs where the treated tract is the destination.


## OUTPUTS
* `DGP_iid_1145_treatedonly_$(Lambda)_$(pop)_$(shock)_$(event)`: The same as the output from `monte_carlo_iid_dgp`, but only includes the destination IDs that correspond to a given treatment ID.

* `DGP_continuum_1145_treatedonly_$(Lambda)_$(pop)_$(shock)_$(event)`: The same as the output from `monte_carlo_continuum_compute`, but only includes the destination IDs that correspond to a given treatment ID.

## CODE
* `keep_only_treated.do`: Takes in the DGP data and keeps only the destination IDs that correspond to a given treatment ID.

## INPUTS
* `DGP_$(Lambda)_$(pop)_$(shock)_$(event).csv` from `monte_carlo_iid_dgp`
* `DGP_continuum_$(Lambda)_$(pop)_$(shock)_$(event).csv` from `monte_carlo_continuum_compute`
