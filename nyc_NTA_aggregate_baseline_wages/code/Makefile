SHELL=bash
include ../../shell_functions.make

all: ../output/NTA_avg_wages_2010.dta
include ../../generic.make

#OUTPUT RECIPES
../output/NTA_avg_wages_2010.dta: aggregate_NTA_wages.do  ../input/nyc_tract_NTA_crosswalk.dta  ../input/nyc2010_wage.dta ../input/nyc2010_lodes_wzero_wdelta.dta | $(STATA_OOPR)
	$(STATA) $< $@
#INPUT RECIPES
../input/nyc_tract_NTA_crosswalk.dta:  ../input/%.dta: ../../nyc_NTA_crosswalk/output/%.dta | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../input/%:  ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
../input/nyc2010_wage.dta: ../input/%:  ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
