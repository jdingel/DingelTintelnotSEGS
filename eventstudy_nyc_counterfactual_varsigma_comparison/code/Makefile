SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
SIGMA_list = 4.0 1.1 Inf

INPUTS_analyze = $(foreach sigma, $(SIGMA_list), ../input/slope_int_MSE_all_csp_sigma_$(sigma).csv)
OUTPUTS_eval = $(foreach comp, 1.1_4.0 inf_4.0, $(foreach var, MSE slope int, ../output/$(var)_$(comp)_comparison_scatterplot.eps))

all: $(OUTPUTS_eval)
include ../../generic.make

#OUTPUT RECIPES
../output/MSE_%_comparison_scatterplot.eps ../output/slope_%_comparison_scatterplot.eps ../output/int_%_comparison_scatterplot.eps: plot_slope_int_mse_comparison.do $(INPUTS_analyze) | $(STATA_OOPR)
	$(STATA) $< $(shell echo $* | tr '_' ' ')

#INPUT RECIPES
$(INPUTS_analyze) : ../input/%.csv: ../../eventstudy_nyc_counterfactual_analyze/output/%.csv | ../input
	ln -sf $< $@
