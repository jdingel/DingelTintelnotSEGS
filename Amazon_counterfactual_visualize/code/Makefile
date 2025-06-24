SHELL=bash
include ../../shell_functions.make

## DEFINITIONS

OUTPUTS_PAPER = $(foreach change_var, reschange change_realr, ../output/map_cont_$(change_var).png) \
$(addprefix ../output/, map_res2010.png map_cs_changeres.png map_cs_hat_realr.png)
MAPTILE_INPUTS = $(addprefix ../input/geoid11_,coords.dta database.dta maptile.ado)

## RECIPES
all: $(OUTPUTS_PAPER) 
include ../../generic.make

# PAPER OUTPUTS
../output/map_cont_reschange.png: map_cont_ell.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' map_cont_ell.do) $(MAPTILE_INPUTS) | $(OOPR)
	$(STATA) $<
../output/map_cont_change_realr.png: map_cont_price.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' map_cont_price.do) $(MAPTILE_INPUTS) | ../output ../temp
	$(STATA) $<
$(addprefix ../output/, map_res2010.png map_cs_changeres.png map_cs_hat_realr.png): \
map_cs.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' map_cs.do) $(MAPTILE_INPUTS) | $(OOPR)
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
