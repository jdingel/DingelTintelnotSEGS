SHELL=bash
include ../../shell_functions.make


## DEFINITIONS
set_shock := 1.09
set_event = $(shell seq 1 1 100) # total set of events = 100

OUTPUTS_EMP_CHANGES = $(addprefix ../output/, $(foreach shock, $(set_shock), hist_montecarlo_fixednu_empchanges_$(shock).eps \
	sumstats_montecarlo_fixednu_empchanges_$(shock).tex sd_montecarlo_fixednu_emp_changes_$(shock).tex))
OUTPUTS_LABOR = $(addprefix ../output/, $(foreach shock, $(set_shock), \
	montecarlo_MSE_ratio_histogram_$(shock)_fixednu.eps montecarlo_slopes_intercepts_densities_$(shock)_fixednu.eps \
	csp_slope_median_fixednu_labor_$(shock)_fixednu.tex csp_slope_median_fixednu_labor_$(shock)_fixednu.tex \
	cbm_mse_mean_fixednu_labor_$(shock)_fixednu.tex csp_mse_mean_fixednu_labor_$(shock)_fixednu.tex \
	mse_ratio_median_fixednu_labor_$(shock)_fixednu.tex mse_ratio_sd_fixednu_labor_$(shock)_fixednu.tex \
	monte_carlo_csp_mean_$(shock)_fixednu.tex monte_carlo_csp_stats_$(shock)_fixednu.tex))

all: $(OUTPUTS_EMP_CHANGES) $(OUTPUTS_LABOR) 
include ../../generic.make


## RECIPES
$(addprefix ../output/, hist_montecarlo_fixednu_empchanges_%.eps sumstats_montecarlo_fixednu_empchanges_%.tex sd_montecarlo_fixednu_emp_changes_%.tex): sum_emp_changes.do $(foreach event, $(set_event), ../input/DGP_%_$(event)_fixednu.csv) | $(STATA_OOPR)
	$(eval arg := $(shell echo $* | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(arg)

.INTERMEDIATE: ../temp/sum_labor_%_fixednu.dta
../temp/sum_labor_%_fixednu.dta: sum_labor_fixednu.do \
	$(foreach event, $(set_event), ../input/DGP_%_$(event)_fixednu.csv ../input/prediction_cbm_%_$(event)_treated_ell_change_fixednu.csv ../input/prediction_csp_%_$(event)_treated_ell_change_fixednu.csv) | $(STATA_OOPR)
	$(eval arg := $(shell echo $* | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(arg)

$(addprefix ../output/, montecarlo_MSE_ratio_histogram_%_fixednu.eps montecarlo_slopes_intercepts_densities_%_fixednu.eps csp_slope_median_fixednu_labor_%_fixednu.tex csp_slope_median_fixednu_labor_%_fixednu.tex \
	cbm_mse_mean_fixednu_labor_%_fixednu.tex csp_mse_mean_fixednu_labor_%_fixednu.tex \
	mse_ratio_median_fixednu_labor_%_fixednu.tex mse_ratio_sd_fixednu_labor_%_fixednu.tex \
	monte_carlo_csp_mean_%_fixednu.tex monte_carlo_csp_stats_%_fixednu.tex): exhibits_labor_fixednu.do \
	../temp/sum_labor_%_fixednu.dta | $(STATA_OOPR)
	$(eval arg := $(shell echo $* | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(arg)

## INPUTS
# Fixed-nu DGP output and modeled predictions
../input/DGP_%_fixednu.csv: ../../monte_carlo_fixednu_dgp/output/DGP_%_fixednu.csv | ../input
	ln -sf $< $@
../input/prediction_cbm_%_treated_ell_change_fixednu.csv: ../../monte_carlo_fixednu_predictions/output/prediction_cbm_%_treated_ell_change_fixednu.csv | ../input
	ln -sf $< $@
../input/prediction_csp_%_treated_ell_change_fixednu.csv: ../../monte_carlo_fixednu_predictions/output/prediction_csp_%_treated_ell_change_fixednu.csv | ../input
	ln -sf $< $@



