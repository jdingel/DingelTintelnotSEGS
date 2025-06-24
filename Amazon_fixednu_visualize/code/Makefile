SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sigma = Inf 4.0 1.1
OUTPUTS_pricediff = $(foreach sigma, $(set_sigma), $(foreach var, realr realw, ../output/scatter_gu_$(var)_simulation_fixednu_sumstats_diff_sigma_$(sigma).eps))
OUTPUTS_emp_res = $(foreach sigma, $(set_sigma), $(foreach var, res emp, ../output/scatter_gu_$(var)_simulation_fixednu_sumstats_diff_sigma_$(sigma).eps) ../output/outlier_note_gu_emp_fixednu_sigma_$(sigma).tex)
OUTPUTS_GU_DESC = $(foreach sigma, $(set_sigma), $(foreach var, realr realw emp, ../output/report_gu_$(var)_fixednu_sigma_$(sigma).tex))
OUTPUTS_GU_MAPS = $(foreach sigma, $(set_sigma), $(addprefix ../output/map_gu_real, \
rchange_fixednu_sigma_$(sigma).png wchange_fixednu_sigma_$(sigma).png \
rchange_fixednu_mean_change_sigma_$(sigma).png wchange_fixednu_mean_change_sigma_$(sigma).png))
#remove wchange variables with sigma = Inf from above, wages are trivial under sigma = Inf
OUTPUTS_GU_MAPS  := $(filter-out ../output/map_gu_realwchange_fixednu_sigma_Inf.png ../output/map_gu_realwchange_fixednu_mean_change_sigma_Inf.png, $(OUTPUTS_GU_MAPS))
MAPTILE_INPUTS = $(addprefix ../input/geoid11_,coords.dta database.dta maptile.ado)

all: $(OUTPUTS_pricediff) $(OUTPUTS_emp_res) $(OUTPUTS_GU_DESC) $(OUTPUTS_GU_MAPS) 
include ../../generic.make
## OUTPUT RECIPES
$(foreach var, res emp, ../output/scatter_gu_$(var)_simulation_fixednu_sumstats_diff_sigma_%.eps) $(foreach var, realr realw, ../output/scatter_gu_$(var)_simulation_fixednu_sumstats_diff_sigma_%.eps) $(foreach var, realr realw emp, ../output/report_gu_$(var)_fixednu_sigma_%.tex) ../output/outlier_note_gu_emp_fixednu_sigma_%.tex: plot_granular_uncertainty.do $(addprefix ../input/simulation_distribution_, orig_sigma_%.csv dest_sigma_%.csv) ../input/nyc2010_lodes_wzero_wdelta.dta ../input/amazon_ctfl_tract_cbm_sigma_%_prob.csv | $(OOPR)
	$(STATA) $< $*
$(foreach var, rchange wchange, ../output/map_gu_real$(var)_fixednu_sigma_%.png ../output/map_gu_real$(var)_fixednu_mean_change_sigma_%.png): plot_gu_map.do $(addprefix ../input/simulation_distribution_, orig_sigma_%.csv dest_sigma_%.csv) ../input/map.do $(MAPTILE_INPUTS) $(addprefix ../input/amazon_ctfl_tract_cbm_, sigma_%_wage.csv sigma_%_ell.csv) | $(OOPR)
	$(STATA) $< $*

## INPUT RECIPES
../input/simulation_distribution_%.csv: ../../Amazon_fixednu_analyze/output/simulation_distribution_%.csv | ../input 
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../../nyc_baseline_data/output/nyc2010_lodes_wzero_wdelta.dta | ../input 
	ln -sf $< $@
../input/amazon_%_prob.csv: ../../Amazon_counterfactual_compute_prob/output/amazon_%_prob.csv | ../input
	ln -sf $< $@
../input/amazon_%.csv: ../../Amazon_counterfactual_compute/output/amazon_%.csv | ../input
	ln -sf $< $@
../input/map.do: ../input/%.do: ../../maps_counterfactuals/code/%.do | ../input
	ln -sf $< $@
$(MAPTILE_INPUTS): ../input/%: ../../maptile_templates/output/US_tract_2010_nyc/% | ../input
	ln -sf $< $@