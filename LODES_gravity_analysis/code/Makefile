SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
OUTPUTS_INPAPER = $(addprefix ../output/, \
			NYC2010_gravity_time_impute_simple.tex)

all: $(OUTPUTS_INPAPER)
include ../../generic.make

# OUTPUT RECIPES
# REGULAR TARGETS
../output/NYC2010_gravity_time_impute_simple.tex: compare_gravity_estimators_time_impute_simple.do  ../input/NYC_delta_LODES2010.dta | $(OOPR)
	$(STATA) $<

#INPUT RECIPES
../input/NYC_delta_LODES2010.dta: ../../LODES_gravity_dataprep/output/NYC_delta_LODES2010.dta | ../input
	ln -sf $< $@


