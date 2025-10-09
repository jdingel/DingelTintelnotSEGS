SHELL=bash
include ../../shell_functions.make

all: ../output/nyc_tract_NTA_crosswalk.dta
include ../../generic.make

#OUTPUT RECIPES
../output/nyc_tract_NTA_crosswalk.dta: NTA_crosswalk_maker.do  ../input/nyc2010census_tabulation_equiv.xlsx | $(STATA_OOPR)
	$(STATA) $<
#INPUT RECIPES
../input/nyc2010census_tabulation_equiv.xlsx: ../../initialdata/output/nyc2010census_tabulation_equiv.xlsx | ../input
	ln -sf $< $@
