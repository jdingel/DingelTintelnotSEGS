SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_ife = 1 2 3
set_svd = 16 100 200 500 # 110 120 130 140 150 160 170 180 190
INPUTS_CBM = ../input/nyc2010_lodes_cbmfit.dta
INPUTS_IFE = $(addprefix ../input/labor_b_approx_ife_, 1.csv.zip 2.csv.zip 3.csv.zip)
INPUTS_SVD = $(addprefix ../input/nyc_2010_levels_tracttotract_approx_svd_, $(foreach svd, $(set_svd), $(svd).dta.zip))
OUTPUTS_CSV_CHI2 = $(addprefix ../output/Chi2_test_statistic_dist_, cbmfit.csv $(foreach ife, $(set_ife), ifefit_$(ife).csv) $(foreach svd, $(set_svd), svdfit_$(svd).csv))
OUTPUTS_CSV_CHI2_subset = $(addprefix ../output/Chi2_test_statistic_dist_, cbmfit.csv $(foreach ife, $(set_ife), ifefit_$(ife).csv))
OUTPUTS_TEX_CHI2 = $(addprefix ../output/Chi2_stat_value_, cbmfit.tex $(foreach ife, $(set_ife), ifefit_$(ife).tex) $(foreach svd, $(set_svd), svdfit_$(svd).tex))
OUTPUTS_TEX_CHI2_subset = $(addprefix ../output/Chi2_stat_value_, cbmfit.tex $(foreach ife, $(set_ife), ifefit_$(ife).tex))
OUTPUTS_CSV_MSE = $(addprefix ../output/MSE_test_statistic_dist_, cbmfit.csv $(foreach ife, $(set_ife), ifefit_$(ife).csv) $(foreach svd, $(set_svd), svdfit_$(svd).csv))
OUTPUTS_CSV_MSE_subset = $(addprefix ../output/MSE_test_statistic_dist_, $(foreach svd, $(set_svd), svdfit_$(svd).csv))
OUTPUTS_TEX_MSE = $(addprefix ../output/MSE_stat_value_, cbmfit.tex $(foreach ife, $(set_ife), ifefit_$(ife).tex) $(foreach svd, $(set_svd), svdfit_$(svd).tex))
OUTPUTS_TEX_MSE_subset = $(addprefix ../output/MSE_stat_value_, cbmfit.tex $(foreach ife, $(set_ife), ifefit_$(ife).tex))

## RECIPES
all: $(OUTPUTS_CSV_CHI2_subset) $(OUTPUTS_TEX_CHI2_subset) ../output/Chi2_parametric_dist.eps $(OUTPUTS_CSV_MSE_subset) $(OUTPUTS_TEX_MSE_subset) ../output/MSE_parametric_dist.eps
include ../../generic.make

## OUTPUT RECIPES
../output/Chi2_test_statistic_dist_%.csv ../output/Chi2_stat_value_%.tex ../output/MSE_test_statistic_dist_%.csv ../output/MSE_stat_value_%.tex: empirical_dist.jl ../temp/nyc2010_lodes_%.dta | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< ../temp/nyc2010_lodes_$*.dta ../output/Chi2_test_statistic_dist_$*.csv ../output/Chi2_stat_value_$*.tex ../output/MSE_test_statistic_dist_$*.csv ../output/MSE_stat_value_$*.tex

## VISUALIZATION
../output/Chi2_parametric_dist.eps: draw_bootstrap_based_dist_chi2.do $(OUTPUTS_CSV_CHI2_subset)  | $(STATA_OOPR)
	$(STATA) $<   $(OUTPUTS_CSV_CHI2_subset)  ../output/Chi2_parametric_dist.eps
../output/MSE_parametric_dist.eps: draw_bootstrap_based_dist_MSE.do $(OUTPUTS_CSV_MSE_subset)  | $(STATA_OOPR)
	$(STATA) $<   $(OUTPUTS_CSV_MSE_subset)  ../output/MSE_parametric_dist.eps


## TEMP RECIPES
../temp/nyc2010_lodes_ifefit_%.dta: clean_ife_fitted_values.do ../temp/nyc2010_lodes_ifefit_%.csv $(INPUTS_CBM)  | $(STATA_OOPR)
	$(STATA) $<  ../temp/nyc2010_lodes_ifefit_$*.csv $(INPUTS_CBM)  $@
../temp/nyc2010_lodes_svdfit_%.dta: clean_svd_fitted_values.do ../temp/nyc_2010_levels_tracttotract_approx_svd_%.dta $(INPUTS_CBM)  | $(STATA_OOPR)
	$(STATA) $<  ../temp/nyc_2010_levels_tracttotract_approx_svd_$*.dta $(INPUTS_CBM)  $@
../temp/nyc2010_lodes_cbmfit.dta: ../input/nyc2010_lodes_cbmfit.dta | ../temp
	ln -sf $< $@

## UNZIP	
../temp/nyc2010_lodes_ifefit_%.csv: ../input/labor_b_approx_ife_%.csv.zip | ../temp
	unzip -p $< > $@
../temp/nyc_2010_levels_tracttotract_approx_svd_%.dta: ../input/nyc_2010_levels_tracttotract_approx_svd_%.dta.zip  | ../temp 
	unzip -p $< > $@

## INPUT RECIPES
$(INPUTS_CBM): ../input/%.dta: ../../commuting_matrix_visualization/output/%.dta | ../input
	ln -sf $< $@
$(INPUTS_IFE): ../input/%csv.zip: ../../interactive_fe_estimation/output/%csv.zip | ../input
	ln -sf $< $@
$(INPUTS_SVD): ../input/%dta.zip: ../../nyc_baseline_data_SVD/output/%dta.zip | ../input
	ln -sf $< $@

