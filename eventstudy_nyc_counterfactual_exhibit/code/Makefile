SHELL=bash
include ../../shell_functions.make
## DEFINITIONS
svd_rank := 16
set_rank_ife = 1
MODEL_approx = svd_16
MODEL_ife = $(foreach rank, $(set_rank_ife), ife_$(rank))
MODEL_list = cbm_deltainf \
	cbm_sigma_1.1 cbm_sigma_4.0 cbm_sigma_Inf csp_sigma_1.1 csp_sigma_4.0 csp_sigma_Inf \
	cbm_ntaorigin_0.25 csp_ntaorigin_0.25 $(MODEL_approx)

model_comparisons_approx = $(foreach model, $(MODEL_approx), cbm_sigma_4.0_vs_$(model))
model_comparisons_ife = $(foreach model, $(MODEL_ife), cbm_sigma_4.0_vs_$(model))

model_comparisons_NTA = cbm_ntaorigin_0.25_vs_csp_ntaorigin_0.25
INPUTS_analyze = $(foreach model, $(MODEL_list), ../input/slope_int_MSE_all_$(model).csv)
INPUTS_analyze_ife = $(foreach model, $(foreach rank, $(set_rank_ife), ife_$(rank)), ../input/slope_int_MSE_all_$(model).csv)
INPUTS_analyze_svd = ../input/slope_int_MSE_all_svd_$(svd_rank).csv
model_comparisons = cbm_deltainf_vs_csp_sigma_4.0 \
cbm_sigma_1.1_vs_csp_sigma_1.1 cbm_sigma_4.0_vs_csp_sigma_4.0 cbm_sigma_Inf_vs_csp_sigma_Inf \
$(model_comparisons_approx) \
$(model_comparisons_ife)

OUTPUTS_kdensity = $(foreach modelcomp, $(model_comparisons), ../output/$(modelcomp)_kdensity_exhibit.eps) 
OUTPUTS_kdensity_notes = $(foreach modelcomp, $(model_comparisons), ../output/$(modelcomp)_kdensity_notes.tex)
OUTPUTS_histogram = $(foreach modelcomp, $(model_comparisons), ../output/$(modelcomp)_histogram_exhibit.eps)

all: $(OUTPUTS_kdensity) $(OUTPUTS_kdensity_notes) $(OUTPUTS_histogram)
include ../../generic.make
.NOTPARALLEL:

#OUTPUT RECIPES
.SECONDEXPANSION:
$(OUTPUTS_kdensity): ../output/%_kdensity_exhibit.eps: slope_int_kdensity_exhibitor.do ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/\([a-zA-Z.0-9]\)_vs_.*/\1/').csv ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/^.*_vs_\(.*\)/\1/').csv | plotting_functions.do $(OOPR)
	$(STATA) --no-job-name $^ $@
.SECONDEXPANSION:
$(OUTPUTS_kdensity_notes): ../output/%_kdensity_notes.tex: slope_int_kdensity_exhibitor.do ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/\([a-zA-Z.0-9]\)_vs_.*/\1/').csv ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/^.*_vs_\(.*\)/\1/').csv | plotting_functions.do $(OOPR)
	$(STATA) --no-job-name $^ ../output/$*_kdensity_exhibit.eps

.SECONDEXPANSION:
$(OUTPUTS_histogram): ../output/%_histogram_exhibit.eps: mse_histogram_exhibitor.do ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/\([a-zA-Z.0-9]\)_vs_.*/\1/').csv ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/^.*_vs_\(.*\)/\1/').csv | plotting_functions.do $(OOPR)
	$(STATA) --no-job-name $^ $@

#INPUT RECIPES
$(INPUTS_analyze) $(INPUTS_analyze_ife): ../input/%.csv: ../../eventstudy_nyc_counterfactual_analyze/output/%.csv | ../input
	ln -sf $< $@
