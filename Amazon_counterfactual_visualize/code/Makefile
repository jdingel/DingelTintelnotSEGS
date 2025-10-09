SHELL=bash
include ../../shell_functions.make

## DEFINITIONS

OUTPUTS_PAPER = $(foreach change_var, reschange empchange change_realr change_realw, ../output/map_cont_$(change_var).png) \
$(addprefix ../output/,text_frac_zero_work_at_treated.tex text_Amazon_cs_rent_topdecile.tex map_res2010.png map_cs_changeres.png map_emp2010.png map_empchange_cs.png map_cs_hat_realr.png map_cs_hat_realw.png map_cs_hat_realr_cutoff.png map_cs_hat_realw_cutoff.png text_Amazon_cs_rent_4pct.tex text_Amazon_cs_rent_5pct.tex text_Amazon_CBM_rent_topdecile.tex)
MAPTILE_INPUTS = $(addprefix ../input/geoid11_,coords.dta database.dta maptile.ado)

## RECIPES
all: $(OUTPUTS_PAPER) 
include ../../generic.make

# PAPER OUTPUTS
../output/map_cont_reschange.png ../output/map_cont_empchange.png:map_cont_ell.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' map_cont_ell.do) $(MAPTILE_INPUTS) | $(STATA_OOPR)
	$(STATA) $<
../output/map_cont_change_realr.png ../output/map_cont_change_realw.png: map_cont_price.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' map_cont_price.do) $(MAPTILE_INPUTS) | $(STATA_OOPR)
	$(STATA) $<
$(addprefix ../output/,text_frac_zero_work_at_treated.tex text_Amazon_cs_rent_topdecile.tex map_res2010.png map_cs_changeres.png map_emp2010.png map_empchange_cs.png map_cs_hat_realr.png map_cs_hat_realw.png map_cs_hat_realr_cutoff.png map_cs_hat_realw_cutoff.png text_Amazon_cs_rent_4pct.tex text_Amazon_cs_rent_5pct.tex): \
map_cs.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' map_cs.do) $(MAPTILE_INPUTS) map_cutoff.do | $(STATA_OOPR)
	$(STATA) $<
../output/text_Amazon_CBM_rent_topdecile.tex: map_granular_s1_s10.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' map_granular_s1_s10.do) $(MAPTILE_INPUTS) map_cutoff.do | $(STATA_OOPR)
	$(STATA) $<
## INPUTS
../input/map_res.do ../input/map.do: ../input/%.do: ../../maps_counterfactuals/code/%.do | ../input
	ln -sf $< $@
$(MAPTILE_INPUTS): ../input/%: ../../maptile_templates/output/US_tract_2010_nyc/% | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../../nyc_baseline_data/output/nyc2010_lodes_wzero_wdelta.dta | ../input
	ln -sf $< $@
../input/amazon_%.csv: ../../Amazon_counterfactual_compute/output/amazon_%.csv | ../input
	ln -sf $< $@
../input/simulation_orig.csv ../input/simulation_dest.csv: ../input/%.csv: ../../Amazon_counterfactual_dispersion_simulation/output/%.csv | ../input
	ln -sf $< $@


