SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_Lambda := 0 0.1 0.25 0.5 1
set_pop := 2.488905 5 12.5 25 50 125 250 2560
set_shock := 1.09 
set_event = $(shell seq 1 1 100)

set_triplet = $(foreach pop, $(set_pop), $(foreach shock, $(set_shock), $(foreach event, $(set_event),$(pop)_$(shock)_$(event))))

OUTPUT_iid = $(foreach Lambda, $(set_Lambda), $(foreach triplet, $(set_triplet), ../output/DGP_iid_1145_treatedonly_$(Lambda)_$(triplet).dta))
OUTPUT_cont_deterministic = $(foreach shock, $(set_shock), $(foreach event, 1 2, ../output/DGP_continuum_1145_treatedonly_0_$(shock)_$(event).dta))
OUTPUT_cont_varying = $(foreach Lambda, 0.1 0.25 0.5 1, $(foreach shock, $(set_shock), $(foreach event, $(set_event), ../output/DGP_continuum_1145_treatedonly_$(Lambda)_$(shock)_$(event).dta)))
OUTPUT_cont = $(OUTPUT_cont_deterministic) $(OUTPUT_cont_varying)

## RECIPES
all: $(OUTPUT_iid) $(OUTPUT_cont)
cont: $(OUTPUT_cont)
iid: $(OUTPUT_iid)
include ../../generic.make

#OUTPUTS
../output/DGP_iid_1145_treatedonly_%.dta: keep_only_treated.do ../input/DGP_%.csv | $(STATA_OOPR)
	$(STATA) $^ 1145 $@

../output/DGP_continuum_1145_treatedonly_%.dta: keep_only_treated.do ../input/DGP_continuum_%_ell.csv | $(STATA_OOPR)
	$(STATA) $^ 1145 $@

#INPUTS
$(foreach Lambda, $(set_Lambda), $(foreach triplet, $(set_triplet), ../input/DGP_$(Lambda)_$(triplet).csv)): ../input/%.csv: ../../monte_carlo_iid_dgp/output/%.csv | ../input
	ln -sf $< $@
$(foreach event, $(set_event), ../input/DGP_0_2.488905_1.00_$(event).csv): ../input/%.csv: ../../monte_carlo_iid_dgp/output/%.csv | ../input
	ln -sf $< $@
../input/DGP_continuum_%_ell.csv: ../../monte_carlo_continuum_compute/output/DGP_continuum_%_ell.csv | ../input
	ln -sf $< $@