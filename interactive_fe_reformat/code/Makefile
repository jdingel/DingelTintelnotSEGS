SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_rank_ife := 1 2 3

all: $(foreach rank, $(set_rank_ife), $(addprefix ../output/nyc2010_, orig_time_ife_$(rank).dta dest_time_ife_$(rank).dta lambda_ife_$(rank).dta))
include ../../generic.make

#OUTPUT RECIPES
../output/nyc2010_orig_time_ife_%.dta: reformat_fe_i.do ../input/nyc2010_orig_time_ife_%.csv | $(OOPR)
	$(STATA) $< $*
../output/nyc2010_dest_time_ife_%.dta: reformat_fe_j.do ../input/nyc2010_dest_time_ife_%.csv | $(OOPR)
	$(STATA) $< $*
../output/nyc2010_lambda_ife_%.dta: calibrate_lambda.do ../input/nyc2010_time_elasticity_ife_%.csv ../input/nyc2010_ife_ij_ife_%.csv | $(OOPR)
	$(STATA) $< $*

#INPUT RECIPES
../input/nyc2010_time_elasticity_ife_%.csv: ../../interactive_fe_estimation/output/beta_%.csv | ../input
	ln -sf $< $@
../input/nyc2010_orig_time_ife_%.csv: ../../interactive_fe_estimation/output/fe_i_%.csv | ../input
	ln -sf $< $@
../input/nyc2010_dest_time_ife_%.csv: ../../interactive_fe_estimation/output/fe_j_%.csv | ../input
	ln -sf $< $@
../input/nyc2010_ife_ij_ife_%.csv: ../../interactive_fe_estimation/output/ife_ij_%.csv | ../input
	ln -sf $< $@