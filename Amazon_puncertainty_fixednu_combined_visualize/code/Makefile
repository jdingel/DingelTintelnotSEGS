SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
INPUTS_bootstrap = $(foreach var, res emp rent wage, ../input/cont_$(var)_puncertainty_pctile.csv)
INPUTS_fixednu = $(foreach type, dest orig, ../input/simulation_distribution_$(type)_sigma_4.0.csv)
OUTPUTS_orig = $(foreach var, res rent, ../output/fixednu_puncertainty_scatter_$(var).eps)
OUTPUTS_dest = $(foreach var, emp wage, ../output/fixednu_puncertainty_scatter_$(var).eps)
## RECIPES
all: $(OUTPUTS_dest) $(OUTPUTS_orig)
bootstrap: $(INPUTS_bootstrap)
fixednu: $(INPUTS_fixednu)
include ../../generic.make

## OUTPUT
$(OUTPUTS_dest): fixednu_puncertainty_combined_scatter_exhibit_dest.do ../input/cont_wage_puncertainty_pctile.csv ../input/cont_emp_puncertainty_pctile.csv ../input/simulation_distribution_dest_sigma_4.0.csv | $(STATA_OOPR)
	$(STATA) $<
$(OUTPUTS_orig): fixednu_puncertainty_combined_scatter_exhibit_orig.do ../input/cont_rent_puncertainty_pctile.csv ../input/cont_res_puncertainty_pctile.csv ../input/simulation_distribution_orig_sigma_4.0.csv | $(STATA_OOPR)
	$(STATA) $<

## INPUT
$(INPUTS_bootstrap): ../input/%: ../../Amazon_puncertainty_analysis/output/% | ../input
	ln -sf $< $@
$(INPUTS_fixednu): ../input/%: ../../Amazon_fixednu_analyze/output/% | ../input
	ln -sf $< $@

