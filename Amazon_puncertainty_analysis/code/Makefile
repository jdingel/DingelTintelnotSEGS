SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sims = $(shell seq 1 1 100)
INPUTS = $(foreach sim, $(set_sims), $(foreach var, res emp rent wage, ../input/cont_$(var)_puncertainty_$(sim).csv))
INPUTS_base_compute = $(foreach var, ell rent wage, ../input/amazon_ctfl_tract_cbm_sigma_4.0_$(var).csv)
OUTPUTS = $(foreach var, res emp rent wage, ../output/cont_$(var)_puncertainty_pctile.csv)
OUTPUTS_comp = $(add_prefix ../output/cont_, emp_puncertainty_zero_in_ci_dest_count.txt rent_puncertainty_pos_changes.txt wage_puncertainty_pos_changes.txt res_puncertainty_zero_in_ci_dest_count.txt)
## RECIPES
all: $(OUTPUTS) $(OUTPUTS_comp)
include ../../generic.make
## OUTPUT
$(OUTPUTS) $(OUTPUTS_comp): compute_var_change.do $(INPUTS) $(INPUTS_base_compute) | $(STATA_OOPR)
	$(STATA) $<

## INPUT
$(INPUTS): ../input/%: ../../Amazon_puncertainty_compute/output/% | ../input
	ln -sf $< $@
../input/amazon_%.csv: ../../Amazon_counterfactual_compute/output/amazon_%.csv | ../input
	ln -sf $< $@
