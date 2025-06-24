SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
YEAR_list = 2010
LODES_list = $(foreach year, $(YEAR_list), ../input/lodes_NYC_$(year).dta)
INPUTS= ../input/2015_gaz_tracts_36.txt \
		../input/NYC_tractpairs_DDMM.dta \
		../input/nyc_delta.do
OUTPUTS_NYC = ../output/NYC_delta_LODES2010.dta

OUTPUTS = $(OUTPUTS_NYC)


## RECIPES
all: $(INPUTS) $(OUTPUTS)
clean:
	rm *.log
include ../../generic.make

$(addprefix ../output/NYC_, 2010_times_imputed.tex 2013_times_imputed.tex delta_LODES2010.dta delta_LODES2012.dta delta_LODES2013.dta delta_LODES2014.dta dist_covariates.dta LODES_pooled.dta): NYC_calls.do programs.do ../input/nyc_delta.do $(foreach year, $(YEAR_list), ../input/lodes_NYC_$(year).dta) ../input/NYC_tractpairs_DDMM.dta ../input/2015_gaz_tracts_36.txt | $(OOPR)
	$(STATA) $<

$(LODES_list): ../input/%.dta: ../../LODES_datapreparation/output/%.dta | ../input
	ln -sf $< $@
../input/NYC_tractpairs_DDMM.dta: ../../initialdata/output/NYC_tractpairs_DDMM.dta | ../input
	ln -sf $< $@
../input/2015_gaz_tracts_36.txt: ../input/%.txt: ../../initialdata/output/%.txt | ../input
	ln -sf $< $@
../input/nyc_delta.do: ../../common_scripts/code/nyc_delta.do | ../input
	ln -sf $< $@
