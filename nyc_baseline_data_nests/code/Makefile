SHELL=bash
include ../../shell_functions.make

set_nest_type := ntapair countypair # pumapair 

OUTPUTS = $(addprefix ../output/nyc2010_, $(foreach nest_type, $(set_nest_type), \
	time_elasticity_$(nest_type).csv zeta_$(nest_type).csv orig_time_$(nest_type).dta dest_time_$(nest_type).dta) census_tabulation.dta)

all: $(OUTPUTS)
reports: $(subst ../output/,../report/,$(addsuffix .log,$(OUTPUTS)))
include ../../generic.make

../output/nyc2010_%: estimate_FE_time.do gravity_nests_saveFE_time.do $(shell grep -o '../input/[A-Za-z0-9_]*\.[a-z]*' estimate_FE_time.do) | $(STATA_OOPR)
	$(STATA) $< $(shell echo $* | grep -o '[a-z]*pair')

../input/nyc2010census_tabulation_equiv.xlsx: ../../initialdata/output/nyc2010census_tabulation_equiv.xlsx | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../../nyc_baseline_data/output/nyc2010_lodes_wzero_wdelta.dta | ../input
	ln -sf $< $@

