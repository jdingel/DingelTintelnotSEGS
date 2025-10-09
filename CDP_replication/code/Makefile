SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
OUTPUTS = $(addprefix ../output/, \
	migration_share_impute.dta CDP_2001_2002_migration_transition_matrix.tex histogram_state_migration_2001.eps histogram_state_migration_2002.eps ACS_2001_data_cleaning_details.tex \
	$(foreach stub,offdiag_mean zeros belowmean,ACS_migration_2001_$(stub).tex))
INPUTS = $(addprefix ../input/,ss01pus.csv ss02pus.csv puma_code.csv migsp_code.csv) 

# RECIPES
all: $(OUTPUTS) 
include ../../generic.make

$(OUTPUTS): PUMS_clean.do $(INPUTS)  | $(STATA_OOPR)
	$(STATA) $<

#INPUT RECIPES
$(INPUTS): ../input/%: ../../CDP_PUMS_data/output/% | ../input
	ln -sf $< $@

