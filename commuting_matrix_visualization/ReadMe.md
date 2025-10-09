# commuting_matrix_visualization

This task visualizes the 2010 commuting flow matrix, 
the fitted matrices from the covariates-based method and the low-rank approximation via SVD.

## Folder structure

`code/`:

* `cbm_fit_commuting_matrix.do`: estimates PPMLE on 2010 LODES data and obtains the CBM-fitted values

* `plot_commuting_matrix.R`: generates visualizations of the 2010 commuting matrix and its approximations. 
Please note that the ranks in the approximations are pre-determined and hard-coded. 

* `scree_generation.R`: generates scree plot that shows the magnitude of successive singular values of the NYC 2010 commuting matrix.

`output/`:

* `lodes_visualizations_legend.png`: common legend for the visualizations

* `lodes{_, _cbm, _svd_$(rank), _nnmf_$(rank), _ife_$(rank), }_visualizations.png`: individual plot panels without headers

* `lodes_svd_normalized_scree_25.png`: the magnitude of successive singular values of the NYC 2010 commuting matrix

`input/`:

* `nyc_NTA_2010_lodes_wzero_wdelta.dta`: LODES NYC 2010 data at the NTA level (including zeros).

* `nyc_2010_levels_tracttotract_approx_svd_$(rank).dta.zip`: approximated labor allocation in Stata format.

* `nyc_2010_levels_tracttotract_approx_nnmf_$(rank).dta.zip`: non-negative matrix factored vector of approximated 2010 commuter count levels for tract pairs.

* `labor_b_approx_ife_$(rank).csv`: Fitted tract-to-tract commuting flows, computed from the IFE estimated parameters.