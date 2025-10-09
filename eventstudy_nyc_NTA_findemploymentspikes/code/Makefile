SHELL=bash
include ../../shell_functions.make
#DEFINITIONS
reports = $(addprefix ../report/, $(addsuffix .log, NTA_spikes_list_5pct.csv NTA_spikes_list_10pct.csv NTA_spikes_list_12.5pct.csv))
spikes_list = $(foreach pct, 5 10 12.5, ../output/NTA_spikes_list_$(pct)pct.csv)
spikes_tex = $(foreach pct, 5 10 12.5, ../output/NTA_boom_count_$(pct)pct.tex) ../output/NTA_boom_count_12.5pct_num.tex
temp_dta = $(foreach pct, 5 10 12.5, ../temp/NTA_spikes_list_$(pct)pct.dta) 
all: $(spikes_list) $(spikes_tex) $(reports)


include ../../generic.make
#OUTPUT RECIPES
$(spikes_list) $(spikes_tex): NTA_findspikes.do ../input/NTA_employment.dta  | $(STATA_OOPR)
	$(STATA) $^

#TEMP RECIPES
$(addprefix ../temp/NTA_spikes_list_, 5pct.dta 10pct.dta 12.5pct.dta) : NTA_findspikes.do ../input/NTA_employment.dta  | $(STATA_OOPR)
	$(STATA) $< $@

#INPUT RECIPES
../input/NTA_employment.dta: ../input/%.dta: ../../nyc_NTA_employment_data/output/%.dta | ../input
	ln -sf $< $@
	
