SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
YEAR_list = 2009 2010 2011 2012 2013 2014
LODES_list = $(foreach year, $(YEAR_list), ../input/lodes_DetroitUA_$(year).dta) $(foreach year, $(YEAR_list), ../input/lodes_NYC_$(year).dta)
INPUTS= $(LODES_list) ../input/Tract_Classification.xlsx ../input/Kij_GoogleTime.xlsx \
		../input/2015_gaz_tracts_36.txt ../input/2015_gaz_tracts_26.txt \
		../input/NYC_tractpairs_DDMM.dta \
		../input/nyc_delta.do
OUTPUTS_Detroit = ../output/DetroitUA_2013_times_imputed.tex ../output/DetroitUA_2014_times_imputed.tex \
											../output/DetroitUA_delta_LODES2013.dta ../output/DetroitUA_delta_LODES2014.dta \
											../output/DetroitUA_dist_covariates.dta ../output/DetroitUA_LODES_pooled.dta
OUTPUTS_NYC = $(foreach yr,2010 2012 2013 2014,../output/NYC_delta_LODES$(yr).dta) \
	$(addprefix ../output/NYC_,2010_times_imputed.tex 2013_times_imputed.tex dist_covariates.dta LODES_pooled.dta)

OUTPUTS = $(OUTPUTS_Detroit) $(OUTPUTS_NYC)


## RECIPES
all: $(OUTPUTS)
clean:
	rm *.log
include ../../generic.make

$(addprefix ../output/DetroitUA_, 2013_times_imputed.tex 2014_times_imputed.tex delta_LODES2013.dta delta_LODES2014.dta dist_covariates.dta LODES_pooled.dta): DetroitUA_calls.do programs.do detroit_delta_impute.do $(foreach year, $(YEAR_list), ../input/lodes_DetroitUA_$(year).dta) ../input/Tract_Classification.xlsx ../input/Kij_GoogleTime.xlsx ../input/2015_gaz_tracts_26.txt | $(STATA_OOPR)
	$(STATA) $<
$(addprefix ../output/NYC_, 2010_times_imputed.tex 2013_times_imputed.tex delta_LODES2010.dta delta_LODES2012.dta delta_LODES2013.dta delta_LODES2014.dta dist_covariates.dta LODES_pooled.dta): NYC_calls.do programs.do ../input/nyc_delta.do $(foreach year, $(YEAR_list), ../input/lodes_NYC_$(year).dta) ../input/NYC_tractpairs_DDMM.dta ../input/2015_gaz_tracts_36.txt | $(STATA_OOPR)
	$(STATA) $<

$(LODES_list): ../input/%.dta: ../../LODES_datapreparation/output/%.dta | ../input
	ln -sf $< $@
../input/NYC_tractpairs_DDMM.dta: ../../initialdata/output/NYC_tractpairs_DDMM.dta | ../input
	ln -sf $< $@
../input/2015_gaz_tracts_36.txt ../input/2015_gaz_tracts_26.txt: ../input/%.txt: ../../initialdata/output/%.txt | ../input
	ln -sf $< $@
../input/Tract_Classification.xlsx ../input/Kij_GoogleTime.xlsx: ../input/%.xlsx: ../../initialdata/output/%.xlsx | ../input
	ln -sf $< $@
../input/nyc_delta.do: ../../common_scripts/code/nyc_delta.do | ../input
	ln -sf $< $@
