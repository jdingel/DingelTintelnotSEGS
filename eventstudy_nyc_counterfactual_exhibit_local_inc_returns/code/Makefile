SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
eta_list = 0.001 0.0028 0.1
eta_model_combos = $(foreach eta, $(eta_list), eta_$(eta)_csp)

OUTPUTS_stats =	$(foreach stat, MSE slope int, \
	$(foreach combo, $(eta_model_combos), ../output/$(stat)_$(combo)_comparison_scatterplot.eps))
OUTPUTS_comparison = $(foreach combo, $(eta_model_combos), ../output/slope_$(combo)_comparison_regression.txt)

INPUTS_analyze = $(foreach eta, $(eta_list), \
					../input/slope_int_MSE_all_csp_eta_$(eta).csv) \
					../input/slope_int_MSE_all_csp_sigma_4.0.csv


all: $(OUTPUTS_stats) $(OUTPUTS_comparison)
include ../../generic.make

## RECIPES
../output/MSE_eta_%_csp_comparison_scatterplot.eps ../output/slope_eta_%_csp_comparison_scatterplot.eps ../output/slope_eta_%_csp_comparison_regression.txt ../output/int_eta_%_csp_comparison_scatterplot.eps: \
	plot_slope_int_mse_comparison_csp.do $(INPUTS_analyze) ../input/slope_int_MSE_all_csp_sigma_4.0.csv | $(STATA_OOPR)
	$(STATA) $< $(shell echo $* | tr '_' ' ')	

$(INPUTS_analyze): ../input/%.csv: ../../eventstudy_nyc_counterfactual_analyze/output/%.csv | ../input 
	ln -sf $< $@
