# Amazon p-uncertainty analysis
This task takes the counterfactual outcomes from the 100 parameter uncertainty simulations and computes the 5th and 95th percentile prediction for each tract.

## Output
* `cont_(var)_puncertainty_pctile.csv`: 90% confidence interval for the changes in (var) for each tract.
* `cont_emp_puncertainty_zero_in_ci_dest_count.txt`: A count of the number of destination tracts where 0 is included in the 90% CI
* `cont_res_puncertainty_zero_in_ci_dest_count.txt`: A count of the number of origin tracts where 0 is included in the 90% CI
* `cont_rent_puncertainty_pos_changes.txt`: A count of the number of times the 5th percentile predicted change in rents is positive.
* `cont_wage_puncertainty_pos_changes.txt`: A count of the number of times the 5th percentile predicted change in wages is positive.


## Code
* `compute_var_change.do`: This script compiles the counterfactual predictions from all 100 parameter uncertainty scenarios and computes the variation between the 5th and 95th percentile prediction for each tract in each of the four outcomes, as well. 
It then saves the results as a csv file.


## Input
* `cont_(var)_puncertainty_%.csv`: The AHQ2 counterfactual predictions for the parameter uncertainty simulation %. 
This output contains results for employment, rents, wages, and residents.
* `amazon_ctfl_tract_cbm_sigma_4.0_{ell,rent,wage}.csv`: The counterfactual predictions of commuting flows, rents, and wages for the CBM.