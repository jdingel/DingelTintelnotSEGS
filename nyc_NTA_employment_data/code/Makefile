SHELL=bash
include ../../shell_functions.make

OUTPUTS = $(foreach stub, employment commutingflows_2010 residents_2010 commutingflows_2012 residents_2012, ../output/NTA_$(stub).dta) ../output/NTA_residents_hist_2010.eps ../output/NTA_residents_hist_2012.eps ../output/NTA_residents_list_2012.tex ../output/NTA_residents_list_2010.tex
OUTPUTS_delta = $(foreach stub, arithmetic weighted harmonic, ../output/NTA_delta_$(stub).dta)

all: $(OUTPUTS) $(OUTPUTS_delta)
deltas : $(OUTPUTS_delta)
include ../../generic.make

#OUTPUT RECIPES
../output/NTA_employment.dta: aggregate_NTA_employment.do ../input/lodes_NYC_2010.dta ../input/lodes_NYC_2012.dta ../input/nyc_tract_NTA_crosswalk.dta | $(STATA_OOPR)
	$(STATA) $<
$(OUTPUTS_delta): aggregate_NTA_delta.do ../input/nyc_tract_NTA_crosswalk.dta ../input/nyc2010_lodes_wzero_wdelta.dta | $(STATA_OOPR)
	$(STATA) $<
../output/NTA_commutingflows_2010.dta ../output/NTA_residents_2010.dta ../output/NTA_residents_hist_2010.eps ../output/NTA_residents_list_2010.tex: aggregate_NTA_commutingflows_residents.do  ../input/nyc_tract_NTA_crosswalk.dta ../input/nyc2010_lodes_wzero_wdelta.dta| $(STATA_OOPR)
	$(STATA) $^ ../output/NTA_commutingflows_2010.dta ../output/NTA_residents_2010.dta ../output/NTA_residents_hist_2010.eps ../output/NTA_residents_list_2010.tex
../output/NTA_commutingflows_2012.dta ../output/NTA_residents_2012.dta ../output/NTA_residents_hist_2012.eps ../output/NTA_residents_list_2012.tex: aggregate_NTA_commutingflows_residents.do  ../input/nyc_tract_NTA_crosswalk.dta ../input/nyc2012_lodes_wzeros.dta| $(STATA_OOPR)
	$(STATA) $^ ../output/NTA_commutingflows_2012.dta ../output/NTA_residents_2012.dta ../output/NTA_residents_hist_2012.eps ../output/NTA_residents_list_2012.tex

#INPUT RECIPES
../input/lodes_NYC_2010.dta ../input/lodes_NYC_2012.dta : ../input/%.dta: ../../LODES_datapreparation/output/%.dta | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta ../input/nyc2012_lodes_wzeros.dta: ../input/%:  ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
../input/nyc_tract_NTA_crosswalk.dta:  ../input/%.dta: ../../nyc_NTA_crosswalk/output/%.dta | ../input
	ln -sf $< $@

