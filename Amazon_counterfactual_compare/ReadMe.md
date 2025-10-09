# Amazon counterfactual compare

This task compares the counterfactual predictions of commuting flows (ell) between the CBM and other model variations.
We currently use the best rank of the SVD approximation, which is 16, and the rank 1 for the IFE approximation.
It also compares the counterfactual predictions for rents between two different values of sigma. 
It develops comparisons for sigma = 1.1, 4.0, and Inf. 

## Output
* `approx_ell_cbm_{SVD|IFE}_comparison_scatterplot.eps`: Scatterplot comparing the counterfactual commuting flow predictions between the CBM and {SVD|IFE}-approximated baseline data.
* `varsigma_rents_(sigma_1)_(sigma_2)_(model)_(treat)_comparison_scatterplot.eps`: 
Scatterplot comparing changes in rents in the AHQ2 counterfactual simulation with sigma_1 to sigma_2 for either the CSP or CBM. 
(treat) is either "wtreat" or "notreat" depending on whether the treated tract is included in the scatterplot.

## Code
* `compare_ell_predict_approx.do`: Creates a scatterplot with the CBM's commuting predictions on the x-axis and the {SVD|IFE} predictions on the y-axis.
* `compare_rent_predict_varsigma.do`: Takes in the counterfactual predictions for rents between two different values of sigma and plots the scatterplot comparing the two. 
Includes options that change the model used and determine whether the treated tract is included in the scatterplot.


## Input
* `amazon_ctfl_tract_cbm_sigma_4.0_ell.csv`: The counterfactual commuting flow predictions for the CBM.
* `amazon_ctfl_tract_(model)_(variable).csv`: The counterfactual predictions for a given variable in the AHQ2 case for a given model.
