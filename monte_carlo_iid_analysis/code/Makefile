SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_event = $(shell seq 1 1 100)
set_pop := 2.488905 5 12.5 25 50 125 250 2560
set_Lambda := 0 0.1 0.25 0.5 1 
set_shock := 1.09 

OUTPUTS = $(addprefix ../output/, \
		$(foreach Lambda, $(set_Lambda), $(foreach pop, $(set_pop), $(foreach shock, $(set_shock), \
		sum_iid_labor_$(Lambda)_$(pop)_$(shock).dta))))
OUTPUTS_detail = $(foreach Lambda, $(set_Lambda), $(foreach pop, $(set_pop), ../output/results_$(Lambda)_$(pop).dta))

## RECIPES
all: $(OUTPUTS) $(OUTPUTS_detail)
detail: $(OUTPUTS_detail)
rest: $(OUTPUTS)
include ../../generic.make

## OUTPUTS
../output/sum_iid_labor_%.dta: sum_labor.do \
	$(foreach event, $(set_event), ../input/DGP_iid_1145_treatedonly_%_$(event).dta ../input/prediction_cbm_%_$(event)_ell.csv ../input/prediction_csp_%_$(event)_ell.csv) | $(STATA_OOPR)
	$(eval threeargs := $(shell echo $@ | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(threeargs)

../output/results_%.dta: summarize_detail.do \
$(foreach event, $(set_event), ../input/DGP_iid_1145_treatedonly_%_1.09_$(event).dta ../input/prediction_cbm_%_1.09_$(event)_ell.csv ../input/prediction_csp_%_1.09_$(event)_ell.csv) | $(STATA_OOPR)
	$(eval args := $(subst _, , $*))
	$(STATA) $< $(args)

## INPUTS
../input/DGP_iid_%.dta: ../../monte_carlo_dgp_filter_to_only_treated/output/DGP_iid_%.dta | ../input
	ln -sf $< $@
../input/prediction_cbm_%.csv: ../../monte_carlo_iid_predictions/output/prediction_cbm_%.csv | ../input
	ln -sf $< $@
../input/prediction_csp_%.csv: ../../monte_carlo_iid_predictions/output/prediction_csp_%.csv | ../input
	ln -sf $< $@

