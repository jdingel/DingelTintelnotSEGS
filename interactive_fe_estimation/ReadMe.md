# interactive fixed effects estimation

This task performs estimation for the interactive fixed effects procedure, which consists of four primary outputs:
 1. Fitted commuting flows from the estimation output,
 2. commuting elasticities,
 3. additive FE estimates, and
 4. interactive FE estimates,

each estimated for each factor structure rank R. 

The code here is largely derived from the replication code 
accompanying Chen, Fernández-Val, and Weidner (2021, Journal of Econometrics).

The procedure itself consists of
 - converting the LODES `dta` file into a `.csv` for reading into MATLAB,
 - estimating the interactive fixed effects model starting from multiple randomized start points for each rank,
 - selecting the likelihood-optimal estimates from among the converged estimates for each rank,
 - exporting fitted values and commuting elasticity for each rank,
 - determining the optimal rank (according to the eigenvalue ratio test proposed in Chen et al. (2021)) for the factor structure.

## Remarks
* This task takes over 200 CPU-hours to run in its entirety, largely due to the multistart estimation of the IFE rank-3 case. 
* The `Makefile` assumes that you will run this on a cluster that uses SLURM to schedule jobs.
* Please parallelize by using `make -j #`, where `#` is a large number of jobs.
* Different start points take different durations to converge.
* This task is more memory-intensive than most tasks. A minimum of 5GB of RAM per job is recommended. Modify if needed in `matlab_slurm_header.sbatch`.

## Output
* `obj_ife_$(R).csv`: The maximum log likelihood value for rank `R`-IFE.
* `optimum_seed_$(R).csv`: The seeds corresponding to the optimal IFE estimates.
* `labor_b_approx_ife_$(rank).csv`: Fitted tract-to-tract commuting flows, computed from the IFE estimated parameters.
* `fe_i_$(rank).csv`/`fe_j_$(rank).csv`: Additive fixed effects estimates from the IFE procedure.
* `fe_i_inter_$(rank).csv`/`fe_j_inter_$(rank).csv`: Interactive fixed effects estimates from the IFE procedure.
* `beta_$(rank).csv`: Commuting elasticity estimates from the IFE procedure.
* `ife_ij_$(rank).csv`: Full factor structure, computed as the tract-pair-specific product of the IFE estimates.

Notice that we need the following transformation to obtain $\lambda^{IFE}$ in appendix B.5. 
Denote the observation in `ife_ij_$(rank).csv` by $x$, $\lambda^{IFE} = exp(- x/\epsilon)$.
* `ife_fitted_vals_vs_obs_$(rank).png`: Scatterplot of fitted values from $(rank) IFE estimation against
    observed LODES values.
* `commuting_elasticity_vs_IFE_rank.png`: Visualization of the magnitude of commuting elasticity estimates across
    IFE ranks.
* `gravity_time_NYC_IFE.tex`: Output table summarizing IFE estimation results and comparing these results 
    with the OLS regression outputs
* `optimal_rank_3_2010.txt`: The optimal IFE rank based on the eigenvalue ratio test in Chen et al. (2021).

## Code
* `convert_lodes_dta_csv.do`: convert the 2010 LODES data into the .csv format required by the MATLAB scripts.
* `int_fe_est.m`: Estimation interface; accepts year, rank, multistart index, and tolerance parameters as inputs. 
    Outputs commuting elasticity and both additive and interactive FE estimates.
* `IFE_MLE.m`: Script to perform the MLE procedure, given rank and initial values for all parameters. 
    Derived from the Chen et al. replication package; includes previously separate functions model(), 
    normalize(), and SampleLogL().
* `select_optimal_ests_from_multistarts.m`: Reads through multistart output and selects the likelihood-optimal estimates 
    (of commuting elasticity and additive/interactive FEs) for a given rank.
* `eigenvalue_ratio_test.m`: Performs the eigenvalue ratio test for determining optimal rank.
* `plot_fitted_values_elast_comparisons.m`: Plots fitted values from the IFE estimation for each of the ranks, against
    the actually observed LODES data. Also visualizes the estimated commuting elasticity magnitude from each of the IFE ranks.
* `IFE_estimation_results_skeleton.tex`: Skeleton for production of formatted IFE estimation output table.
* `table_generator_IFE.R`: Table generation script for achieving otherwise difficult table formatting
* `mcfadden_r2_calculation.jl`: Computes McFadden's R-squared for the IFE (MLE) estimates


## Input
* `nyc2010_lodes_wzero_wdelta.dta`: NYC 2010 LODES data with commuting costs.
* `NYC2010_gravity_time_impute_simple.tex`: Output table containing point estimate 
    and R-squared from OLS `reghdfe` regressions

## Calling MATLAB scripts
* `matlab_slurm_header.sbatch`: This task makes use of an exceptional system for calling MATLAB scripts. 
Due to difficulties in integrating parameterized MATLAB functions with the remainder of the standard workflow 
(i.e. as is done for Julia, Stata, and R), we've instead implemented the following system.

    The file `matlab_slurm_header.sbatch` is an sbatch header which is constant across all MATLAB scripts that 
    need to be run for this task.
    Each function/script which does need to be called is then directly appended
    to this header, and saved in the temporary file `matlab_slurm_header.sbatch`.
    This is the sbatch script which is actually used; after being run, it's deleted.
