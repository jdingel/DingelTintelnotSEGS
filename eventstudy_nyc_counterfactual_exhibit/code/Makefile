SHELL=bash
include ../../shell_functions.make
## DEFINITIONS
svd_rank := 16
set_rank_ife = 1 2 3
MODEL_approx = svd_$(svd_rank)
MODEL_ife = $(foreach rank, $(set_rank_ife), ife_$(rank))
MODEL_list = cbm_deltainf cbm_pool_2008_2010 csp_pool_2008_2010 \
	cbm_ntaorigin_0.75 csp_ntaorigin_0.75 cbm_workplace_0.75 csp_workplace_0.75 \
	cbm_nta csp_nta cbm_nta_weighted csp_nta_weighted cbm_nta_harmonic csp_nta_harmonic \
	cbm_sigma_1.1 cbm_sigma_4.0 cbm_sigma_Inf csp_sigma_1.1 csp_sigma_4.0 csp_sigma_Inf \
	cbm_ntaorigin_0.25 csp_ntaorigin_0.25 $(MODEL_approx) \
	csp_eta_0.001 csp_eta_0.0028 cbm_eta_0.001 cbm_eta_0.0028 \
	cbm_dist 

model_comparisons_approx = $(foreach model, $(MODEL_approx), cbm_sigma_4.0_vs_$(model))
model_comparisons_ife = $(foreach model, $(MODEL_ife), cbm_sigma_4.0_vs_$(model))

model_comparisons_NTA = cbm_nta_vs_csp_nta cbm_ntaorigin_0.25_vs_csp_ntaorigin_0.25
INPUTS_analyze = $(foreach model, $(MODEL_list), ../input/slope_int_MSE_all_$(model).csv)
INPUTS_analyze_ife = $(foreach model, $(foreach rank, $(set_rank_ife), ife_$(rank)), ../input/slope_int_MSE_all_$(model).csv)
INPUTS_analyze_svd = ../input/slope_int_MSE_all_svd_$(svd_rank).csv
model_comparisons = cbm_deltainf_vs_csp_sigma_4.0 cbm_pool_2008_2010_vs_csp_pool_2008_2010 \
cbm_sigma_1.1_vs_csp_sigma_1.1 cbm_sigma_4.0_vs_csp_sigma_4.0 cbm_sigma_Inf_vs_csp_sigma_Inf \
cbm_eta_0.001_vs_csp_eta_0.001 cbm_eta_0.0028_vs_csp_eta_0.0028 \
cbm_ntaorigin_0.75_vs_csp_ntaorigin_0.75 cbm_workplace_0.75_vs_csp_workplace_0.75 $(model_comparisons_approx) \
cbm_dist_vs_csp_sigma_4.0 cbm_dist_vs_cbm_sigma_4.0 $(model_comparisons_ife)

OUTPUTS_slope_kdensity_NTA = $(foreach modelcomp, $(model_comparisons_NTA), ../output/$(modelcomp)_slope_kdensity_exhibit.eps)
OUTPUTS_int_kdensity_NTA = $(foreach modelcomp, $(model_comparisons_NTA), ../output/$(modelcomp)_intercept_kdensity_exhibit.eps)
OUTPUTS_NTA_kdensity_notes = $(foreach modelcomp, $(model_comparisons_NTA), ../output/$(modelcomp)_kdensity_notes.tex)
OUTPUTS_kdensity = $(foreach modelcomp, $(model_comparisons) $(model_comparisons_NTA), ../output/$(modelcomp)_kdensity_exhibit.eps) 
OUTPUTS_kdensity_notes = $(foreach modelcomp, $(model_comparisons), ../output/$(modelcomp)_kdensity_notes.tex)
OUTPUTS_histogram = $(foreach modelcomp, $(model_comparisons) $(model_comparisons_NTA), ../output/$(modelcomp)_histogram_exhibit.eps)
OUTPUTS_tex = $(addprefix ../output/, predictions_contrast_slopes_intercepts.tex \
	predictions_contrast_slopes_intercepts_pool.tex predictions_intercept_mean.txt \
	predictions_slope_mean.txt cbm_events_median_coefficients.tex csp_events_median_coefficients.tex text_CSP_negativeslope.tex \
	text_csp_pool_2008_2010_pos_frac.tex)
OUTPUTS_tex_IFE = $(addprefix ../output/, $(foreach val, 1 2 3, text_ife_$(val)_vs_cbm_sigma_4.0_lower_MSE.tex text_ife_$(val)_vs_cbm_sigma_4.0_closest_to_1.tex) ife_1_events_median_slope.tex)
OUTPUTS_tex_SVD = $(addprefix ../output/, text_svd_$(svd_rank)_vs_cbm_sigma_4.0_lower_MSE.tex text_svd_$(svd_rank)_vs_cbm_sigma_4.0_closest_to_1.tex svd_$(svd_rank)_events_median_slope.tex)
OUTPUTS_MSE = $(addprefix ../output/, MSE_ratio_median.txt MSE_pool_ratio_median.txt text_num_event.tex text_CBM_win.tex text_dist_CBM_win.tex \
	text_pool_CBM_win.tex summary_MSE.tex summary_MSE_pool.tex \
	MSE_NTA_median.txt text_num_event_NTA.tex text_CBM_NTA_win.tex \
	summary_MSE_NTA.tex median_NTA_MSE_csp.txt median_NTA_MSE_cbm.txt median_MSE_cbm.txt median_MSE_csp.txt \
	median_MSE_cbm_pool.txt median_MSE_csp_pool.txt MSE_dist_ratio_median.txt)

all: $(OUTPUTS_kdensity) $(OUTPUTS_histogram) $(OUTPUTS_tex) $(OUTPUTS_MSE) $(OUTPUTS_kdensity_notes) $(OUTPUTS_slope_kdensity_NTA) \
	$(OUTPUTS_int_kdensity_NTA) $(OUTPUTS_NTA_kdensity_notes) $(OUTPUTS_tex_IFE) $(OUTPUTS_tex_SVD)
include ../../generic.make
.NOTPARALLEL:

#OUTPUT RECIPES
.SECONDEXPANSION:
$(OUTPUTS_kdensity): ../output/%_kdensity_exhibit.eps: slope_int_kdensity_exhibitor.do ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/\([a-zA-Z.0-9]\)_vs_.*/\1/').csv ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/^.*_vs_\(.*\)/\1/').csv | plotting_functions.do $(STATA_OOPR)
	$(STATA) --no-job-name $^ $@
.SECONDEXPANSION:
$(OUTPUTS_kdensity_notes): ../output/%_kdensity_notes.tex: slope_int_kdensity_exhibitor.do ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/\([a-zA-Z.0-9]\)_vs_.*/\1/').csv ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/^.*_vs_\(.*\)/\1/').csv | plotting_functions.do $(STATA_OOPR)
	$(STATA) --no-job-name $^ ../output/$*_kdensity_exhibit.eps

.SECONDEXPANSION: 
$(OUTPUTS_slope_kdensity_NTA): ../output/%_slope_kdensity_exhibit.eps: NTA_kdensity_exhibitor.do ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/\([a-zA-Z0-9\._]\)_vs_.*/\1/').csv ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/^.*_vs_\(.*\)/\1/').csv | plotting_functions.do $(STATA_OOPR)
	$(STATA) --no-job-name $^ $@
.SECONDEXPANSION:
$(OUTPUTS_int_kdensity_NTA): ../output/%_intercept_kdensity_exhibit.eps: NTA_kdensity_exhibitor.do ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/\([a-zA-Z0-9\._]\)_vs_.*/\1/').csv ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/^.*_vs_\(.*\)/\1/').csv| plotting_functions.do $(STATA_OOPR)
	$(STATA) --no-job-name $^ $@
.SECONDEXPANSION:
$(OUTPUTS_NTA_kdensity_notes): ../output/%_kdensity_notes.tex: NTA_kdensity_exhibitor.do ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/\([a-zA-Z0-9\._]\)_vs_.*/\1/').csv ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/^.*_vs_\(.*\)/\1/').csv | plotting_functions.do $(STATA_OOPR)
	$(STATA) --no-job-name $^ ../output/$*_kdensity_exhibit.eps

.SECONDEXPANSION:
$(OUTPUTS_histogram): ../output/%_histogram_exhibit.eps: mse_histogram_exhibitor.do ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/\([a-zA-Z.0-9]\)_vs_.*/\1/').csv ../input/slope_int_MSE_all_$$(shell echo $$* | sed 's/^.*_vs_\(.*\)/\1/').csv | plotting_functions.do $(STATA_OOPR)
	$(STATA) --no-job-name $^ $@

$(OUTPUTS_tex): predictions_contrast_slopes_intercepts.do $(shell grep -o '../input/[A-Za-z_0-9.]*\.[a-z]*' predictions_contrast_slopes_intercepts.do) | $(STATA_OOPR)
	$(STATA) --no-job-name $^
$(OUTPUTS_tex_IFE): predictions_contrast_slopes_approx.do $(shell grep -o '../input/[A-Za-z_0-9.]*\.[a-z]*' predictions_contrast_slopes_approx.do) $(INPUTS_analyze_ife) | $(STATA_OOPR)
	$(STATA) $< ife
$(OUTPUTS_tex_SVD): predictions_contrast_slopes_approx.do $(shell grep -o '../input/[A-Za-z_0-9.]*\.[a-z]*' predictions_contrast_slopes_approx.do) $(INPUTS_analyze_svd) | $(STATA_OOPR)
	$(STATA) $< svd $(svd_rank)
$(OUTPUTS_MSE): MSE_contrast.do $(shell grep -o '../input/[A-Za-z_0-9.]*\.[a-z]*' MSE_contrast.do) | $(STATA_OOPR)
	$(STATA) --no-job-name $^



#INPUT RECIPES
$(INPUTS_analyze) $(INPUTS_analyze_ife): ../input/%.csv: ../../eventstudy_nyc_counterfactual_analyze/output/%.csv | ../input
	ln -sf $< $@
