SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
# treated tracts and ntas
TRACTS_2010_list = ../temp/treatmentIDS.csv

# ranks for matrix approximation and ife
svd_ranks = $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 500 1000 1500 2143
ife_ranks = 1 2 3

MODEL_cbm = $(addprefix cbm_, $(addprefix sigma_, 1.1 4.0 Inf) deltainf)
MODEL_csp = $(addprefix csp_, $(addprefix sigma_, 1.1 4.0 Inf))
MODEL_approx = $(foreach rank, $(svd_ranks), svd_$(rank)) 
MODEL_ife = $(foreach rank, $(ife_ranks), ife_$(rank))

# Defining input files
INPUTS_obs_changes_tract = ../input/nyc_2012_2010_observed_changes_tracttotract.dta
INPUTS_predict_changes = $(foreach model, $(MODEL_cbm) $(MODEL_csp) $(MODEL_approx) \
	$(MODEL_ife), \
	../input/nyc_obs_$(model)_all.csv)

# Defining intermediate file lists
OUTPUTS_tract = $(foreach model, $(MODEL_cbm) $(MODEL_csp) $(MODEL_approx) , ../output/slope_int_MSE_all_$(model).csv)
OUTPUTS_ife = $(foreach model, $(MODEL_ife), ../output/slope_int_MSE_all_$(model).csv)

# Defining targets
all: $(OUTPUTS_tract) $(OUTPUTS_ife)
approx: $(foreach model, $(MODEL_approx), ../output/slope_int_MSE_all_$(model).csv)
ife: $(foreach model, $(MODEL_ife), ../output/slope_int_MSE_all_$(model).csv)
include ../../generic.make

## OUTPUT RECIPES
$(OUTPUTS_tract) $(OUTPUTS_ife): ../output/slope_int_MSE_all_%.csv: compute_stats.do $(TRACTS_2010_list) $(INPUTS_obs_changes_tract) ../input/nyc_obs_%_all.csv ../input/specification_list.csv | $(OOPR)
	$(STATA) $< $(TRACTS_2010_list) $* $(INPUTS_obs_changes_tract)

## TEMP RECIPES
../temp/treatmentIDS.csv: ../input/nyc_20102012_spikes_list.txt | ../temp
	(echo "id" && cat $<) > $@

## INPUT RECIPES
../input/specification_list.csv: ../../baseline_models_foreha/output/specification_list.csv | ../input 
	ln -sf $< $@
$(INPUTS_predict_changes): ../input/%.csv: ../../eventstudy_nyc_counterfactual_compute_simultaneous/output/%.csv | ../input 
	ln -sf $< $@
../input/nyc_20102012_spikes_list.txt: ../input/%: ../../LODES_findemploymentspikes/output/% | ../input
	ln -sf $< $@
$(INPUTS_obs_changes_tract): ../input/%: ../../eventstudy_nyc_observed_changes/output/% | ../input
	ln -sf $< $@
