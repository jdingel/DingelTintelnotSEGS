SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_event = $(shell seq 1 1 100)
set_pop := 2.488905 5 12.5 25 50 125 250 2560
shock := 1.09

OUTPUTS_labor_deterministic = $(foreach pop, $(set_pop), ../output/sum_continuum_labor_0_$(pop)_$(shock).dta)
OUTPUTS_prices_deterministic = $(foreach pop, $(set_pop), ../output/sum_continuum_prices_0_$(pop)_$(shock).dta)

OUTPUTS_labor_varying = $(foreach Lambda, 0.1 0.25 0.5 1, $(foreach pop, $(set_pop), ../output/sum_continuum_labor_$(Lambda)_$(pop)_$(shock).dta))
OUTPUTS_prices_varying = $(foreach Lambda, 0.1 0.25 0.5 1, $(foreach pop, $(set_pop), ../output/sum_continuum_prices_$(Lambda)_$(pop)_$(shock).dta))

OUTPUTS_detail_deterministic = $(foreach pop, $(set_pop), ../output/results_0_$(pop).dta)
OUTPUTS_detail_varying = $(foreach Lambda, 0.1 0.25 0.5 1, $(foreach pop, $(set_pop), ../output/results_$(Lambda)_$(pop).dta))

OUTPUTS = $(OUTPUTS_labor_deterministic) $(OUTPUTS_prices_deterministic) $(OUTPUTS_labor_varying) $(OUTPUTS_prices_varying)
OUTPUTS_detail = $(OUTPUTS_detail_deterministic) $(OUTPUTS_detail_varying)

all: $(OUTPUTS) $(OUTPUTS_detail)
detail: $(OUTPUTS_detail)
include ../../generic.make

## RECIPES (DETERMINISTIC)
$(OUTPUTS_labor_deterministic): ../output/sum_continuum_labor_%.dta: sum_labor.do \
	$(foreach event, $(set_event), ../input/prediction_cbm_%_$(event)_ell.csv ../input/prediction_csp_%_$(event)_ell.csv ../input/DGP_continuum_1145_treatedonly_0_$(shock)_1.dta) | $(STATA_OOPR)
	$(eval threeargs := $(shell echo $@ | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(threeargs)

$(OUTPUTS_prices_deterministic): ../output/sum_continuum_prices_%.dta: sum_prices.do \
	$(foreach event, $(set_event), ../input/prediction_cbm_%_$(event)_r.csv ../input/prediction_csp_%_$(event)_r.csv ../input/DGP_continuum_0_$(shock)_1_r.csv) | $(STATA_OOPR)
	$(eval threeargs := $(shell echo $@ | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(threeargs)

$(OUTPUTS_detail_deterministic): ../output/results_%.dta: summarize_detail.do \
	$(foreach event, $(set_event), ../input/DGP_continuum_1145_treatedonly_0_$(shock)_1.dta ../input/prediction_cbm_%_$(shock)_$(event)_ell.csv ../input/prediction_csp_%_$(shock)_$(event)_ell.csv) | $(STATA_OOPR)
	$(eval args := $(subst _, , $*))
	$(STATA) $< $(args)

## RECIPES (VARYING)
.SECONDEXPANSION:
$(OUTPUTS_labor_varying): ../output/sum_continuum_labor_%.dta: sum_labor.do \
	$(foreach event, $(set_event), ../input/prediction_cbm_%_$(event)_ell.csv ../input/prediction_csp_%_$(event)_ell.csv ../input/DGP_continuum_1145_treatedonly_$$(word 1,$$(subst _, ,$$*))_$(shock)_$(event).dta) | $(STATA_OOPR)
	$(eval threeargs := $(shell echo $@ | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(threeargs)

.SECONDEXPANSION:
$(OUTPUTS_prices_varying): ../output/sum_continuum_prices_%.dta: sum_prices.do \
	$(foreach event, $(set_event), ../input/prediction_cbm_%_$(event)_r.csv ../input/prediction_csp_%_$(event)_r.csv ../input/DGP_continuum_$$(word 1,$$(subst _, ,$$*))_$(shock)_$(event)_r.csv) | $(STATA_OOPR)
	$(eval threeargs := $(shell echo $@ | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(threeargs)

.SECONDEXPANSION:
$(OUTPUTS_detail_varying): ../output/results_%.dta: summarize_detail.do \
	$(foreach event, $(set_event), ../input/DGP_continuum_1145_treatedonly_$$(word 1,$$(subst _, ,$$*))_$(shock)_$(event).dta ../input/prediction_cbm_%_$(shock)_$(event)_ell.csv ../input/prediction_csp_%_$(shock)_$(event)_ell.csv) | $(STATA_OOPR)
	$(eval args := $(subst _, , $*))
	$(STATA) $< $(args)

## INPUTS
../input/DGP_continuum_%.dta: ../../monte_carlo_dgp_filter_to_only_treated/output/DGP_continuum_%.dta | ../input
	ln -sf $< $@
../input/DGP_continuum_%.csv: ../../monte_carlo_continuum_compute/output/DGP_continuum_%.csv | ../input
	ln -sf $< $@
../input/prediction_cbm%.csv: ../../monte_carlo_continuum_predictions/output/prediction_cbm%.csv | ../input
	ln -sf $< $@
../input/prediction_csp%.csv: ../../monte_carlo_continuum_predictions/output/prediction_csp%.csv | ../input
	ln -sf $< $@
