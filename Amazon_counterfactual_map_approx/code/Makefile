SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_models = ife_1 svd_16
MAPTILE_INPUTS = $(addprefix ../input/geoid11_,coords.dta database.dta maptile.ado)
INPUTS = $(foreach model, $(set_models), $(foreach var, ell rent wage, ../input/amazon_ctfl_tract_$(model)_$(var).csv))

OUTPUTS_SVD = $(addprefix ../output/,map_res2010_svd16.png map_svd16_reschange_cutoff.png map_reschange_svd16.png map_empchange_svd16.png map_svd16_hat_realr.png map_svd16_hat_realr_cutoff.png map_svd16_hat_realw.png map_svd16_hat_realw_cutoff.png text_Amazon_svd16_rent_topdecile.tex)
OUTPUTS_IFE =  $(addprefix ../output/,map_res2010_ife1.png map_ife1_reschange_cutoff.png map_empchange_ife1.png map_ife1_hat_realr.png map_ife1_hat_realr_cutoff.png map_ife1_hat_realw.png map_ife1_hat_realw_cutoff.png text_Amazon_ife1_rent_topdecile.tex)
all: $(OUTPUTS_SVD) $(OUTPUTS_IFE)
maptile: $(MAPTILE_INPUTS)
include ../../generic.make

## OUTPUT RECIPES

$(addprefix ../output/,map_res2010_svd%.png map_svd%_reschange_cutoff.png map_reschange_svd%.png map_empchange_svd%.png map_svd%_hat_realr.png map_svd%_hat_realr_cutoff.png map_svd%_hat_realw.png map_svd%_hat_realw_cutoff.png text_Amazon_svd%_rent_topdecile.tex): map_svd.do $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z]*' map_svd.do) $(foreach var, ell rent wage, ../input/amazon_ctfl_tract_svd_%_$(var).csv) $(MAPTILE_INPUTS) ../temp/nyc_2010_levels_tracttotract_approx_svd_%.dta | $(STATA_OOPR)
	$(STATA) $< $*
$(addprefix ../output/,map_res2010_ife%.png map_reschange_ife%.png map_ife%_reschange_cutoff.png map_empchange_ife%.png map_ife%_hat_realr.png map_ife%_hat_realr_cutoff.png map_ife%_hat_realw.png map_ife%_hat_realw_cutoff.png text_Amazon_ife%_rent_topdecile.tex): map_ife.do $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z]*' map_ife.do) $(foreach var, ell rent wage, ../input/amazon_ctfl_tract_ife_%_$(var).csv) $(MAPTILE_INPUTS) ../temp/nyc_2010_levels_tracttotract_approx_ife_%.dta | $(STATA_OOPR)
	$(STATA) $< $*

## TEMP RECIPES
../temp/nyc_2010_levels_tracttotract_approx_%.dta: ../input/nyc_2010_levels_tracttotract_approx_%.dta.zip | ../temp
	unzip -p $< > $@

## INPUT RECIPES
$(INPUTS): ../input/%: ../../Amazon_counterfactual_compute/output/% | ../input
	ln -sf $< $@
../input/map_res.do ../input/map.do: ../input/%.do: ../../maps_counterfactuals/code/%.do | ../input
	ln -sf $< $@
../input/map_cutoff.do: ../input/%.do: ../../Amazon_counterfactual_visualize/code/%.do | ../input
	ln -sf $< $@
$(MAPTILE_INPUTS): ../input/%: ../../maptile_templates/output/US_tract_2010_nyc/% | ../input
	ln -sf $< $@
../input/nyc_2010_levels_tracttotract_approx_svd_%.dta.zip: ../../nyc_baseline_data_SVD/output/nyc_2010_levels_tracttotract_approx_svd_%.dta.zip | ../input
	ln -sf $< $@
../input/nyc_2010_levels_tracttotract_approx_ife_%.dta.zip: ../../interactive_fe_reformat/output/nyc_2010_levels_tracttotract_approx_ife_%.dta.zip | ../input
	ln -sf $< $@
