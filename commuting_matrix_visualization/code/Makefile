SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_rank_SVD = 5 16 100 200
set_rank_NNMF = 5
set_rank_IFE = 1

OUTPUT_MAT_VIS = $(addprefix ../output/lodes_, \
    visualization.png cbm_visualization.png \
    svd_5_visualization.png svd_100_visualization.png\
	svd_16_visualization.png svd_200_visualization.png \
    nnmf_5_visualization.png visualizations_legend.png \
	ife_1_visualization.png)
OUTPUTS_SCREE = ../output/lodes_svd_normalized_scree_25.png
TEMP_SVD = $(foreach rank, $(set_rank_SVD), ../temp/nyc_2010_levels_tracttotract_approx_svd_$(rank).dta)
TEMP_NNMF = $(foreach rank, $(set_rank_NNMF), ../temp/nyc_2010_levels_tracttotract_approx_nnmf_$(rank).dta)
TEMP_IFE = $(foreach rank, $(set_rank_IFE), ../temp/labor_b_approx_ife_$(rank).csv)

## OUTPUT_MAT_VIS
all: $(OUTPUT_MAT_VIS) $(OUTPUTS_SCREE)
include ../../generic.make
.INTERMEDIATE: ../temp/nyc2010_lodes_cbmfit.dta $(TEMP_SVD) $(TEMP_NNMF) $(TEMP_IFE)

# OUTPUT RECIPES
../temp/nyc2010_lodes_cbmfit.dta: cbm_fit_commuting_matrix.do ../input/nyc2010_lodes_wzero_wdelta.dta | $(STATA_OOPR)
	$(STATA) $<
../output/nyc2010_lodes_cbmfit.dta: ../temp/nyc2010_lodes_cbmfit.dta | ../output
	cp -p $< $@
$(OUTPUT_MAT_VIS): plot_commuting_matrix.R ../temp/nyc2010_lodes_cbmfit.dta $(TEMP_SVD) $(TEMP_NNMF) $(TEMP_IFE) | $(OOPR)
	$(R) $<
$(OUTPUTS_SCREE): scree_generation.R ../input/nyc2010_lodes_wzero_wdelta.dta | $(OOPR)
	$(R) $<

## INPUT RECIPES
../input/nyc2010_lodes_wzero_wdelta.dta: ../../nyc_baseline_data/output/nyc2010_lodes_wzero_wdelta.dta | ../input
	ln -sf $< $@
../input/nyc_2010_levels_tracttotract_approx_svd_%.dta.zip: ../../nyc_baseline_data_SVD/output/nyc_2010_levels_tracttotract_approx_svd_%.dta.zip | ../input
	ln -sf $< $@
../temp/nyc_2010_levels_tracttotract_approx_svd_%.dta: | ../input/nyc_2010_levels_tracttotract_approx_svd_%.dta.zip ../temp 
	unzip -j ../input/nyc_2010_levels_tracttotract_approx_svd_$*.dta.zip -d ../temp
../input/nyc_2010_levels_tracttotract_approx_nnmf_%.dta.zip: ../../nyc_baseline_data_nnmf/output/nyc_2010_levels_tracttotract_approx_nnmf_%.dta.zip | ../input
	ln -sf $< $@
../temp/nyc_2010_levels_tracttotract_approx_nnmf_%.dta: | ../input/nyc_2010_levels_tracttotract_approx_nnmf_%.dta.zip ../temp
	unzip -j ../input/nyc_2010_levels_tracttotract_approx_nnmf_$*.dta.zip -d ../temp
../temp/nyc2010_lodes.csv: convert_lodes_dta_csv.do ../input/nyc2010_lodes_wzero_wdelta.dta | $(STATA_OOPR)
	$(STATA) $<
../temp/labor_b_approx_ife_1.csv: labor_b_approx.m ../temp/nyc2010_lodes.csv $(addprefix ../input/, beta_1.csv fe_i_1.csv fe_j_1.csv fe_i_inter_1.csv fe_j_inter_1.csv) | $(OOPR)
	$(MATLAB) labor_b_approx

$(addprefix ../input/, beta_1.csv fe_i_1.csv fe_j_1.csv fe_i_inter_1.csv fe_j_inter_1.csv): ../input/%.csv: ../../interactive_fe_estimation/output/%.csv | ../input
	ln -sf $< $@
