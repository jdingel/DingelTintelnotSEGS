SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_event = $(shell seq 1 1 100)
set_pop := 2.488905 5 12.5 25 50 125 250 2560
set_Lambda := 0 0.1 0.25 0.5 1
set_shock := 1.09


## RECIPES
all: ../output/sumstats_iid_labor_0_1.09.tex
include ../../generic.make

.NOTPARALLEL:
../output/sumstats_iid_labor_%_1.09.tex: exhibits_labor2.do \
	 $(foreach pop, $(set_pop), ../input/sum_iid_labor_%_$(pop)_1.09.dta) | $(OOPR)
	$(STATA) $< $* 1.09

## INPUTs
../input/sum_iid_labor_%: ../../monte_carlo_iid_analysis/output/sum_iid_labor_% | ../input
	ln -sf $< $@
