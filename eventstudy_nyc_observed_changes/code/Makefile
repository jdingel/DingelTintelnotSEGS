SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
OUTPUTS = $(addprefix ../output/, $(foreach end,_observed_changes_tracttotract.dta _observed_changes_dest_tract.dta,\
nyc_2012_2010$(end) nyc_2012_2010_2008_pool$(end))) ../output/nyc_NTA_2012_2010_observed_changes_origtodest.dta ../output/nyc_NTA_2012_2010_observed_changes_dest.dta
INPUTS_2010 = $(addprefix ../input/,  nyc2010_lodes_wzero_wdelta.dta nyc2012_lodes_wzeros.dta)
INPUTS_2008_2010 = $(addprefix ../input/, nyc_pool_2008_2010_lodes_wzero_wdelta.dta nyc2012_lodes_wzeros.dta)
INPUTS_NTA = $(addprefix ../input/, NTA_commutingflows_2010.dta NTA_commutingflows_2012.dta)

all: $(OUTPUTS)
include ../../generic.make

#OUTPUT RECIPES
../output/nyc_2012_2010_observed_changes_tracttotract.dta : compute_observed_changes_origtodest.do $(INPUTS_2010) | $(STATA_OOPR)
	 $(STATA) --no-job-name $^ $@
../output/nyc_2012_2010_observed_changes_dest_tract.dta : compute_observed_changes_dest.do $(INPUTS_2010) | $(STATA_OOPR)
	 $(STATA) --no-job-name $^ $@

../output/nyc_2012_2010_2008_pool_observed_changes_tracttotract.dta : compute_observed_changes_origtodest.do $(INPUTS_2008_2010) | $(STATA_OOPR)
	 $(STATA) --no-job-name $^ $@
../output/nyc_2012_2010_2008_pool_observed_changes_dest_tract.dta : compute_observed_changes_dest.do $(INPUTS_2008_2010) | $(STATA_OOPR)
	 $(STATA) --no-job-name $^ $@

../output/nyc_NTA_2012_2010_observed_changes_origtodest.dta : compute_observed_changes_origtodest.do $(INPUTS_NTA) | $(STATA_OOPR)
	 $(STATA) --no-job-name $^ $@
../output/nyc_NTA_2012_2010_observed_changes_dest.dta : compute_observed_changes_dest.do $(INPUTS_NTA) | $(STATA_OOPR)
	 $(STATA) --no-job-name $^ $@
#INPUT RECIPES
$(INPUTS_2010) ../input/nyc_pool_2008_2010_lodes_wzero_wdelta.dta: ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
$(INPUTS_NTA): ../input/%: ../../nyc_NTA_employment_data/output/% | ../input
	ln -sf $< $@

