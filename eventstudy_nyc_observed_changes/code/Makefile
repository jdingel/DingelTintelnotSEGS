SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
OUTPUTS = $(addprefix ../output/, $(foreach end,_observed_changes_tracttotract.dta _observed_changes_dest_tract.dta,\
nyc_2012_2010$(end)))
INPUTS_2010 = $(addprefix ../input/,  nyc2010_lodes_wzero_wdelta.dta nyc2012_lodes_wzeros.dta)

all: $(OUTPUTS)
include ../../generic.make

#OUTPUT RECIPES
../output/nyc_2012_2010_observed_changes_tracttotract.dta : compute_observed_changes_origtodest.do $(INPUTS_2010) | $(OOPR)
	 $(STATA) --no-job-name $^ $@
../output/nyc_2012_2010_observed_changes_dest_tract.dta : compute_observed_changes_dest.do $(INPUTS_2010) | $(OOPR)
	 $(STATA) --no-job-name $^ $@

#INPUT RECIPES
$(INPUTS_2010): ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@

