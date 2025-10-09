SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_pop := 2.488905 5 12.5 25 50 125 250 2560
set_Lambda := 0 0.1 0.25 0.5 1
set_shock := 1.09

OUTPUTS_LABOR = $(addprefix ../output/, \
		$(foreach Lambda, $(set_Lambda), $(foreach pop, $(set_pop), $(foreach shock, $(set_shock), \
		csp_slope_median_iid_labor_$(Lambda)_2.488905_$(shock).tex \
		cbm_mse_mean_iid_labor_$(Lambda)_2.488905_$(shock).tex csp_mse_mean_iid_labor_$(Lambda)_2.488905_$(shock).tex \
		mse_ratio_sd_iid_labor_$(Lambda)_2.488905_$(shock).tex mse_ratio_median_iid_labor_$(Lambda)_2.488905_$(shock).tex \
		slopes_intercepts_densities_iid_labor_$(Lambda)_2.488905_$(shock).eps MSE_ratio_histogram_iid_labor_$(Lambda)_2.488905_$(shock).eps sumstats_iid_labor_$(Lambda)_$(shock).tex)))) 

## RECIPES
all: $(OUTPUTS_LABOR) ../output/monte_carlo_result_mean.tex
include ../../generic.make

.NOTPARALLEL:
$(addprefix ../output/, csp_slope_median_iid_labor_%.tex slopes_intercepts_densities_iid_labor_%.eps mse_ratio_median_iid_labor_%.tex cbm_mse_mean_iid_labor_%.tex csp_mse_mean_iid_labor_%.tex mse_ratio_sd_iid_labor_%.tex MSE_ratio_histogram_iid_labor_%.eps): exhibits_labor1.do \
	../input/sum_iid_labor_%.dta | $(STATA_OOPR)
	$(STATA) $< $(subst _, , $*)
../output/sumstats_iid_labor_%_1.09.tex: exhibits_labor2.do \
	 $(foreach pop, $(set_pop), ../input/sum_iid_labor_%_$(pop)_1.09.dta) | $(STATA_OOPR)
	$(STATA) $< $* 1.09

../output/monte_carlo_result_mean.tex: sum_all.do $(foreach Lambda, $(set_Lambda), $(foreach pop, $(set_pop), ../input/results_$(Lambda)_$(pop).dta)) | $(STATA_OOPR)
	$(STATA) $<

## INPUTs
../input/sum_iid_labor_%: ../../monte_carlo_iid_analysis/output/sum_iid_labor_% | ../input
	ln -sf $< $@
../input/results%: ../../monte_carlo_iid_analysis/output/results% | ../input
	ln -sf $< $@
