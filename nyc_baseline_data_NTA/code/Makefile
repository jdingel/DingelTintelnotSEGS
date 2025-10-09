SHELL=bash
include ../../shell_functions.make
OUTPUTS_arithmetic = $(addprefix ../output/, nyc_NTA_2010_orig_FE.dta nyc_NTA_2010_dest_FE.dta nyc_NTA_2010_time_elasticity.csv nyc_NTA_2010_lodes_wzero_wdelta.dta nyc_NTA_2010_bilat_predicted_time.dta nyc_NTA_2010_r2p.txt)
INPUTS_delta = ../input/NTA_delta_arithmetic.dta
all: $(OUTPUTS_arithmetic)
include ../../generic.make
.NOTPARALLEL:
#OUTPUT RECIPES
$(OUTPUTS_arithmetic): NTA_gravity_regression_arithmetic.do  ../input/NTA_delta_arithmetic.dta ../input/NTA_commutingflows_2010.dta NTA_gravity_saveFE_time.do | $(STATA_OOPR)
	$(STATA) $^ 
#INPUT RECIPES
$(INPUTS_delta) ../input/NTA_commutingflows_2010.dta: ../input/%:  ../../nyc_NTA_employment_data/output/% | ../input
	ln -sf $< $@

