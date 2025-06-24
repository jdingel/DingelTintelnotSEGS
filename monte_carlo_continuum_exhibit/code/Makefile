SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_event = $(shell seq 1 1 100)
set_pop := 2.488905 5 12.5 25 50 125 250 2560
set_Lambda := 0 0.1 0.25 0.5 1
set_shock := 1.09 
OUTPUTS_LABOR = $(addprefix ../output/, \
		$(foreach Lambda, $(set_Lambda), $(foreach shock, $(set_shock), \
		csp_slope_median_continuum_labor_$(Lambda)_2.488905_$(shock).tex slopes_intercepts_densities_continuum_labor_$(Lambda)_2.488905_$(shock).eps \
		mse_ratio_median_continuum_labor_$(Lambda)_2.488905_$(shock).tex mse_ratio_sd_continuum_labor_$(Lambda)_2.488905_$(shock).tex \
		MSE_ratio_histogram_continuum_labor_$(Lambda)_2.488905_$(shock).eps sumstats_continuum_labor_$(Lambda)_$(shock).tex)))
INPUTS = $(addprefix ../input/, \
		$(foreach Lambda, $(set_Lambda), $(foreach pop, $(set_pop), \
		sum_continuum_labor_$(Lambda)_2.488905_$(pop).dta sum_continuum_prices_$(Lambda)_2.488905_$(pop).dta results_$(Lambda)_$(pop).dta)))

all: $(OUTPUTS_LABOR) 
include ../../generic.make
.INTERMEDIATE: $(INPUTS)
.NOTPARALLEL:

## RECIPES

$(addprefix ../output/, csp_slope_median_continuum_labor_%.tex slopes_intercepts_densities_continuum_labor_%.eps mse_ratio_median_continuum_labor_%.tex mse_ratio_sd_continuum_labor_%.tex MSE_ratio_histogram_continuum_labor_%.eps): exhibits_labor1.do \
	../input/sum_continuum_labor_%.dta | $(OOPR)
	$(STATA) $< $(subst _, , $*)

$(foreach shock, $(set_shock), ../output/sumstats_continuum_labor_%_$(shock).tex): exhibits_labor2.do \
$(foreach shock, $(set_shock), $(foreach pop, $(set_pop), ../input/sum_continuum_labor_%_$(pop)_$(shock).dta)) | $(OOPR)
	$(eval twoargs := $(shell echo $@ | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(twoargs)

## INPUTS
../input/sum_continuum_labor_%.dta: ../../monte_carlo_continuum_analysis/output/sum_continuum_labor_%.dta | ../input
	ln -sf $< $@
