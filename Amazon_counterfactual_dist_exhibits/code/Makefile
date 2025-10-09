SHELL=bash
include ../../shell_functions.make

## RECIPES
all: ../output/AHQ2_rent_change_polyplot.eps ../output/AHQ2_rent_change_polyplot_log.eps \
../output/AHQ2_rent_change_CBM_vs_CSP_polyplot_log.eps
include ../../generic.make
#Output Recipes
../output/AHQ2_rent_change_polyplot.eps: rent_change_plot_dist_poly.do ../input/amazon_ctfl_tract_csp_sigma_4.0_rent.csv ../input/amazon_ctfl_tract_cbm_sigma_4.0_rent.csv ../input/NYC_dist_to_treated.dta | $(STATA_OOPR)
	$(STATA) $^ dist_ij OLS  $@
../output/AHQ2_rent_change_polyplot_log.eps: rent_change_plot_dist_poly.do ../input/amazon_ctfl_tract_csp_sigma_4.0_rent.csv ../input/amazon_ctfl_tract_cbm_sigma_4.0_rent.csv ../input/NYC_dist_to_treated.dta | $(STATA_OOPR)
	$(STATA) $^ dist_log_ij OLS $@
../output/AHQ2_rent_change_CBM_vs_CSP_polyplot_log.eps: rent_change_plot_dist_poly.do ../input/amazon_ctfl_tract_csp_sigma_4.0_rent.csv ../input/amazon_ctfl_tract_cbm_sigma_4.0_rent.csv ../input/NYC_dist_to_treated.dta | $(STATA_OOPR)
	$(STATA) $^ dist_log_ij NO_OLS $@
#Input Recipes
 ../input/amazon_%:  ../../Amazon_counterfactual_compute/output/amazon_% | ../input
	ln -sf $< $@
../input/NYC_dist_to_treated.dta: ../../Amazon_compute_dist_to_treated/output/NYC_dist_to_treated.dta | ../input
	ln -sf $< $@
