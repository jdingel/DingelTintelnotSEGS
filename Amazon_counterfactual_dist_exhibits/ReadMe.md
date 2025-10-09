# Amazon counterfactual dist exhibits

This task creates a set of polynomial fit plot counterparts to figure 7 that compares the rent changes predicted by the covariates-based continuum model (CBM) and the calibrated-shares procedure (CSP). Each figure plots predicted rent changes as functions of distance and log distance to the Amazon HQ2 tract.
The results indicate that distance influences the predicted rent changes in both models, with a stronger gradient observed for the CBM compared to the CSP.

## Output
* `AHQ2_rent_change_polyplot(_log).eps` `AHQ2_rent_change_CBM_vs_CSP_polyplot_log.eps`: polynomial fit plots with 95 percentile confidence intervals comparing the CSP and CBM predicted rent changes vs the (log) distance to the Amazon HQ2 tract.

## Input
* `NYC_dist_to_treated.dta`: the distance between origin tracts and the treatment tract.
* `amazon_ctfl_tract_cbm_sigma_4.0_rent.csv`: price predicted by the cbm.
* `amazon_ctfl_tract_csp_sigma_4.0_rent.csv`: rent changes predicted by the calibrated-shares procedure.


## Code
* `rent_change_plot_dist_poly.do`: Plot a polynomial fit of the predicted rent changes for the CBM and CSP models vs the distance to the treated tract.


