# eventstudy_nyc_counterfactual_exhibit_SVD

This task produces summary statistics and exhibit on the counterfactual predictions using SVD-based or SVD-like approximations.

## Folder structure

`code/`:

* `eventstudy_nnmf_performance_skeleton.tex`: Empty skeleton for specialized table formatting which is not feasible to accomplish using prebuilt table packages in R

* `nnmf_table_generator.R`: Summarization script which accepts as inputs the substantial summaries of event study results and formats them to fill out the table skeleton.

`output/`:

* `eventstudy_nnmf_performance.tex`: Summary of NNMF event study performance across ranks.

`input/`:

* `slope_int_MSE_all_nnmf_%.csv`: The slope, intercept, MSE, and tract ID for all tracts using the predictions of the nnmf model.
