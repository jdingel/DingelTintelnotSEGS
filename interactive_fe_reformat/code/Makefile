SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_rank_ife := 1 2 3
OUTPUTS = $(foreach rank, $(set_rank_ife), ../output/nyc_2010_levels_tracttotract_approx_ife_$(rank).dta.zip)
temp = $(foreach rank, $(set_rank_ife), ../temp/nyc_2010_levels_tracttotract_approx_ife_$(rank).dta)

all: $(OUTPUTS) $(foreach rank, $(set_rank_ife), $(addprefix ../output/nyc2010_, orig_time_ife_$(rank).dta dest_time_ife_$(rank).dta lambda_ife_$(rank).dta))
include ../../generic.make
.INTERMEDIATE: $(temp)
#OUTPUT RECIPES
$(OUTPUTS): ../output/nyc_2010_levels_tracttotract_approx_ife_%.dta.zip: ../temp/nyc_2010_levels_tracttotract_approx_ife_%.dta | ../output
	zip $@ $<
../output/nyc2010_orig_time_ife_%.dta: reformat_fe_i.do ../input/nyc2010_orig_time_ife_%.csv | $(STATA_OOPR)
	$(STATA) $< $*
../output/nyc2010_dest_time_ife_%.dta: reformat_fe_j.do ../input/nyc2010_dest_time_ife_%.csv | $(STATA_OOPR)
	$(STATA) $< $*
../output/nyc2010_lambda_ife_%.dta: calibrate_lambda.do ../input/nyc2010_time_elasticity_ife_%.csv ../input/nyc2010_ife_ij_ife_%.csv | $(STATA_OOPR)
	$(STATA) $< $*

#TEMP RECIPES
../temp/nyc_2010_levels_tracttotract_approx_ife_%.dta: reformat_ife_data.do ../temp/labor_b_approx_ife_%.csv | $(STATA_OOPR)
	$(STATA) $< ../temp/labor_b_approx_ife_$*.csv $@

../temp/labor_b_approx_ife_%.csv: ../input/labor_b_approx_ife_%.csv.zip | ../temp
	unzip -p $< > $@

#INPUT RECIPES
../input/nyc2010_time_elasticity_ife_%.csv: ../../interactive_fe_estimation/output/beta_%.csv | ../input
	ln -sf $< $@
../input/labor_b_approx_ife_%.csv.zip: ../../interactive_fe_estimation/output/labor_b_approx_ife_%.csv.zip | ../input
	ln -sf $< $@
../input/nyc2010_orig_time_ife_%.csv: ../../interactive_fe_estimation/output/fe_i_%.csv | ../input
	ln -sf $< $@
../input/nyc2010_dest_time_ife_%.csv: ../../interactive_fe_estimation/output/fe_j_%.csv | ../input
	ln -sf $< $@
../input/nyc2010_ife_ij_ife_%.csv: ../../interactive_fe_estimation/output/ife_ij_%.csv | ../input
	ln -sf $< $@
