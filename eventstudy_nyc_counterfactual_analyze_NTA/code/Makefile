SHELL=bash
include ../../shell_functions.make

-include ../temp/tracts.make

## DEFINITIONS
INPUTS_2010_all = $(addprefix ../input/, nyc_obs_csp_sigma_4.0_all.csv nyc_obs_cbm_sigma_4.0_all.csv nyc_obs_cbm_deltainf_all.csv) 
OUTPUTS_tables = $(foreach tract, $(TRACTS_2010_list),../output/$(tract)_contrastchanges_NTA.tex)
OUTPUTS = ../output/nyc_tract_NTA_crosswalk.dta $(OUTPUTS_tables) \
			../output/MSE_MAE_values_NTA.txt ../output/slopes_intercepts_NTA.txt \
			../output/summary_MSE_NTA_post_aggregated.tex ../output/MSE_histogram_cont_cs_NTA.eps ../output/density_slope_NTA_cont_cs.eps ../output/density_slope_NTA_cont_cs_slides.eps ../output/density_intercept_NTA_cont_cs.eps ../output/median_MSE_cbm_NTA_aggregated.txt ../output/median_MSE_csp_NTA_aggregated.txt

all: $(OUTPUTS)
include ../../generic.make

#OUTPUT RECIPES
../output/nyc_tract_NTA_crosswalk.dta: map_tract_NTA.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' map_tract_NTA.do) | $(STATA_OOPR)
	$(STATA) $<
../output/%_contrastchanges_NTA.tex: reg_obs_pred.do ../output/nyc_tract_NTA_crosswalk.dta ../input/nyc2012_lodes_wzeros.dta $(INPUTS_2010_all) | $(STATA_OOPR)
	$(STATA) $< $*

#Summarize
../output/MSE_MAE_values_NTA.txt: $(OUTPUTS_tables) | $(OOPR)
	cat <(echo 'Tract,Criterion,CSP,CBM,CBM_deltainf') \
	<(grep 'MSE\|MAE' ../output/*_contrastchanges_NTA.tex | \
	sed 's/^\.\.\/output\///' | sed 's/_contrastchanges_NTA\.tex:/,/' | sed 's/&/,/g' | sed 's/\\\\//' | sed 's/\\hline//') \
	> $@
../output/slopes_intercepts_NTA.txt: $(OUTPUTS_tables) | $(OOPR)
	cat <(echo 'Tract,Coefficient,CSP,CBM,CBM_deltainf') \
	<(grep 'Predicted\|Constant' ../output/*_contrastchanges_NTA.tex | \
	sed 's/^\.\.\/output\///' | sed 's/_contrastchanges_NTA\.tex:/,/' | sed 's/&/,/g' | sed 's/\\\\//') \
	> $@
../output/summary_MSE_NTA_post_aggregated.tex: ../output/MSE_MAE_values_NTA.txt | $(OOPR)
	$(eval LOWER := $(shell grep 'MSE' ../output/MSE_MAE_values_NTA.txt | awk -F, '$$4<$$3' | wc -l))
	$(eval EVENTS := $(shell grep 'MSE' ../output/MSE_MAE_values_NTA.txt | wc -l))
	echo 'the covariates-based model has a lower MSE than the calibrated-shares procedure in $(LOWER) of the $(EVENTS) events.' > $@
../output/MSE_histogram_cont_cs_NTA.eps ../output/density_slope_NTA_cont_cs.eps ../output/density_slope_NTA_cont_cs_slides.eps ../output/density_intercept_NTA_cont_cs.eps ../output/median_MSE_cbm_NTA_aggregated.txt ../output/median_MSE_csp_NTA_aggregated.txt: sum_slope_intercept_MSE.do ../output/MSE_MAE_values_NTA.txt ../output/slopes_intercepts_NTA.txt | $(STATA_OOPR)
	$(STATA) $<

#TEMP RECIPES
../temp/tracts.make: ../input/nyc_20102012_spikes_list.txt | ../temp
	@printf "TRACTS_2010_list := " > $@
	@cat $< | sed 's/^36/ 36/' | tr '\n' ' ' >> $@
	@echo "" >> $@

#INPUT RECIPES
../input/nyc_20102012_spikes_list.txt: ../../LODES_findemploymentspikes/output/nyc_20102012_spikes_list.txt | ../input
	ln -sf $< $@
../input/nyc2012_lodes_wzeros.dta: ../../nyc_baseline_data/output/nyc2012_lodes_wzeros.dta | ../input
	ln -sf $< $@
$(INPUTS_2010_all): ../input/%.csv: ../../eventstudy_nyc_counterfactual_compute_simultaneous/output/%.csv | ../input
	ln -sf $< $@
../input/nyc2010census_tabulation_equiv.xlsx: ../../initialdata/output/nyc2010census_tabulation_equiv.xlsx | ../input
	ln -sf $< $@

