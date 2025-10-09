# Amazon fixednu Y CI
This task computes the aggregate output before and after the Amazon HQ2 shock and plots the histogram of the percentage change in output and presents the 90% confidence interval for the percentage change in output.

## Output
* `AHQ2_fixednu_output_change_CI.tex`: A text file containing the confidence interval for the percentage change in output.
* `AHQ2_fixednu_output_change_histogram.eps`: A histogram of the percentage change in output with confidence intervals.


## Code
* `compute_Y_fixednu.jl`: Takes in equilibrium wages, rents, and commuting shares and computes the output before and after the productivity shock.
* `plot_Y_histogram.do`: Creates histogram and confidence intervals for the percentage change in output.

## Input
* `finite_labor_allocation_4.0_$(simulation).csv.zip`: collects the individuals' choices for a given simulation and convert the results into commuting matrix.
* `simulation_fixednu_4.0_$(simulation).jld2`: stores the real wages and rents as well as the number of residents and workers before and after the shock.
* `primitives_nyc2010_time.jld2`: The calibrated primitives (land endowment, productivity, wage & rent beliefs, commuting cost matrix, and population).
