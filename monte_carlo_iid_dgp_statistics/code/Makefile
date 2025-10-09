SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_event = $(shell seq 1 1 100)
set_shock = 1.09
OUTPUTS_EMP_CHANGES = $(addprefix ../output/, $(foreach shock, $(set_shock), hist_montecarlo_iid_empchanges_$(shock).eps sumstats_montecarlo_iid_empchanges_$(shock).tex sd_montecarlo_iid_empchanges_$(shock).tex))

all: $(OUTPUTS_EMP_CHANGES)
include ../../generic.make

## OUTPUTS
$(addprefix ../output/, hist_montecarlo_iid_empchanges_%.eps sumstats_montecarlo_iid_empchanges_%.tex sd_montecarlo_iid_empchanges_%.tex): sum_emp_changes.do $(foreach event, $(set_event), ../input/DGP_iid_1145_treatedonly_0_2.488905_1.09_$(event).dta) | $(STATA_OOPR)
	$(eval arg := $(shell echo $@ | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(arg)

## INPUTS
../input/DGP_%.dta: ../../monte_carlo_dgp_filter_to_only_treated/output/DGP_%.dta | ../input
	ln -sf $< $@
