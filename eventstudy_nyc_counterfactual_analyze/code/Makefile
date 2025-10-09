SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
# treated tracts and ntas
TRACTS_2010_list = ../temp/treatmentIDS.csv
NTAs_2010_list = ../temp/treatmentIDS_NTA.csv

# ranks for matrix approximation and ife
nnmf_ranks = $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50
svd_ranks = $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 500 1000 1500 2143
ife_ranks = 1 2 3
set_nests = ntaorigin_0.75 workplace_0.75 ntaorigin_0.25 workplace_0.5 residence_0.75 residence_0.5

MODEL_cbm = $(addprefix cbm_, dist $(addprefix sigma_, 1.1 4.0 Inf) deltainf $(addprefix eta_, 0.001 0.0028 0.1))
MODEL_csp = $(addprefix csp_, $(addprefix sigma_, 1.1 4.0 Inf) $(addprefix eta_, 0.001 0.0028 0.1))
MODEL_approx = $(foreach rank, $(svd_ranks), svd_$(rank)) \
	$(foreach rank, $(nnmf_ranks), nnmf_$(rank))
MODEL_nests = $(foreach nest, $(set_nests), cbm_$(nest) csp_$(nest))
MODEL_pool = cbm_pool_2008_2010 csp_pool_2008_2010
MODEL_nta = cbm_nta csp_nta
MODEL_ife = $(foreach rank, $(ife_ranks), ife_$(rank))

# Defining input files
INPUTS_obs_changes_tract = ../input/nyc_2012_2010_observed_changes_tracttotract.dta
INPUTS_obs_changes_nta = ../input/nyc_NTA_2012_2010_observed_changes_origtodest.dta
INPUTS_predict_changes = $(foreach model, $(MODEL_cbm) $(MODEL_csp) $(MODEL_approx) \
	$(MODEL_pool) $(MODEL_nests) $(MODEL_nta) $(MODEL_ife), \
	../input/nyc_obs_$(model)_all.csv)

# Defining intermediate file lists
OUTPUTS_nta = $(foreach model, $(MODEL_nta), ../output/slope_int_MSE_all_$(model).csv)
OUTPUTS_tract = $(foreach model, $(MODEL_cbm) $(MODEL_csp) $(MODEL_approx) $(MODEL_nests) , ../output/slope_int_MSE_all_$(model).csv)
OUTPUTS_pool = $(foreach model, $(MODEL_pool), ../output/slope_int_MSE_all_$(model).csv)
OUTPUTS_ife = $(foreach model, $(MODEL_ife), ../output/slope_int_MSE_all_$(model).csv)

# Type `make ../temp/treatmentIDS_NTA.csv` to avoid "cat: ../temp/treatmentIDS_NTA.csv: No such file or directory"
OUTPUTS_nta_figures = $(foreach model, cbm_nta csp_nta, \
	$(foreach nta, $(shell cat ../temp/treatmentIDS_NTA.csv | tail -n +2 | tr '\n' ' '), \
	../output/slope_int_MSE_scatterplot_$(model)_$(nta).eps))

# Defining targets
all: $(OUTPUTS_tract) $(OUTPUTS_nta) $(OUTPUTS_pool) $(OUTPUTS_ife) $(OUTPUTS_nta_figures)
nta: $(OUTPUTS_nta) $(OUTPUTS_nta_figures)
nests: $(foreach model, $(MODEL_nests), ../output/slope_int_MSE_all_$(model).csv)
pool: $(foreach model, $(MODEL_pool), ../output/slope_int_MSE_all_$(model).csv)
approx: $(foreach model, $(MODEL_approx), ../output/slope_int_MSE_all_$(model).csv)
ife: $(foreach model, $(MODEL_ife), ../output/slope_int_MSE_all_$(model).csv)
include ../../generic.make

## OUTPUT RECIPES
$(OUTPUTS_tract) $(OUTPUTS_ife) $(OUTPUTS_pool): ../output/slope_int_MSE_all_%.csv: compute_stats.do $(TRACTS_2010_list) $(INPUTS_obs_changes_tract) ../input/nyc_obs_%_all.csv ../input/specification_list.csv | $(STATA_OOPR)
	$(STATA) $< $(TRACTS_2010_list) $* $(INPUTS_obs_changes_tract)
$(OUTPUTS_nta): ../output/slope_int_MSE_all_%.csv: compute_stats.do $(NTAs_2010_list) $(INPUTS_obs_changes_nta) ../input/nyc_obs_%_all.csv ../input/specification_list.csv | $(STATA_OOPR)
	$(STATA) $< $(NTAs_2010_list) $* $(INPUTS_obs_changes_nta)

## TEMP RECIPES
../temp/treatmentIDS.csv: ../input/nyc_20102012_spikes_list.txt | ../temp
	(echo "id" && cat $<) > $@
../temp/treatmentIDS_NTA.csv: ../input/NTA_spikes_list_12.5pct.csv | ../temp
	sed 's/"//g; s/NTA_code/id/' $< > $@

## INPUT RECIPES
../input/specification_list.csv: ../../baseline_models_foreha/output/specification_list.csv | ../input 
	ln -sf $< $@
$(INPUTS_predict_changes): ../input/%.csv: ../../eventstudy_nyc_counterfactual_compute_simultaneous/output/%.csv | ../input 
	ln -sf $< $@
../input/nyc_20102012_spikes_list.txt: ../input/%: ../../LODES_findemploymentspikes/output/% | ../input
	ln -sf $< $@
../input/NTA_spikes_list_12.5pct.csv: ../input/%: ../../eventstudy_nyc_NTA_findemploymentspikes/output/% | ../input
	ln -sf $< $@
$(INPUTS_obs_changes_tract) $(INPUTS_obs_changes_nta): ../input/%: ../../eventstudy_nyc_observed_changes/output/% | ../input
	ln -sf $< $@
