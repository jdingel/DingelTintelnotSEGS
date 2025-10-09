SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_zeta = 0.25 0.75

OUTPUTS = $(foreach zeta, $(set_zeta), ../output/ell_nested_comparison_plots_$(zeta).eps)

MAPTILE_INPUTS = $(addprefix ../input/geoid11_,coords.dta database.dta maptile.ado)

all: $(OUTPUTS) ../output/map_cont_change_res_nested.png
include ../../generic.make



#OUTPUT RECIPES
../output/ell_nested_comparison_plots_%.eps: compare_ell_predict_nested.do ../input/amazon_ctfl_tract_cbm_ntaorigin_%_ell.csv ../input/amazon_ctfl_tract_cbm_sigma_4.0_ell.csv | $(STATA_OOPR)
	$(STATA) $< $*
../output/map_cont_change_res_nested.png: plot_map_res_change.do ../input/amazon_ctfl_tract_cbm_ntaorigin_0.25_ell.csv ../input/map_res.do $(MAPTILE_INPUTS) ../input/nyc2010_lodes_wzero_wdelta.dta | $(STATA_OOPR)
	$(STATA) $< $*


#INPUT RECIPES
../input/amazon_%.csv: ../../Amazon_counterfactual_compute/output/amazon_%.csv | ../input
	ln -sf $< $@
$(MAPTILE_INPUTS): ../input/%: ../../maptile_templates/output/US_tract_2010_nyc/% | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../input/%.dta: ../../nyc_baseline_data/output/%.dta | ../input
	ln -sf $< $@
../input/map_res.do ../input/map.do: ../input/%.do: ../../maps_counterfactuals/code/%.do | ../input
	ln -sf $< $@
	
