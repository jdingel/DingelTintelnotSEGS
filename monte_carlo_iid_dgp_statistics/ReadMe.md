# monte_carlo_iid_dgp_statistics
This task computes summary statistics of employment changes in the treated tract and generates a histogram. 

## Output
* `hist_montecarlo_iid_empchanges_$(shock).eps`, `sd_montecarlo_iid_empchanges_$(shock).tex`, `sumstats_montecarlo_iid_empchanges_$(shock).tex`: 
summary statistics and histogram of employment changes in the treated tract

## Code
* `sum_emp_changes.do`: computes summary statistics of employment changes in the treated tract and generates a histogram

## Input
* `DGP_iid_1145_treatedonly_$(Lambda)_$(pop)_$(shock)_$(event).dta`: Before and after commuting flows from the DGP, filtered to only include the treated tract as the destination