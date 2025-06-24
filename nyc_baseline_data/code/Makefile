SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
OUTPUTS_NYC_2010 = $(foreach file,bilat_predicted_time orig_time dest_time wage lodes_wzeros,../output/nyc2010_$(file).dta) ../output/nyc2010_time_elasticity.csv
OUTPUTS_NYC_2008 = $(foreach file,bilat_predicted_time orig_time dest_time wage lodes_wzeros,../output/nyc2008_$(file).dta) ../output/nyc2008_time_elasticity.csv
OUTPUTS_NYC_AFTER = ../output/nyc2012_lodes_wzeros.dta

all: $(OUTPUTS_NYC_2010) $(OUTPUTS_NYC_2008) $(OUTPUTS_NYC_AFTER)
include ../../generic.make

#OUTPUT RECIPES
../output/nyc_delta_bar.jld2: convert_delta_bar_to_jld.jl ../input/describe_data.jl ../output/nyc2010_lodes_wzero_wdelta.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $<

#IMPLICIT RULES
$(addprefix ../output/nyc2008, _lodes_wzero_wdelta.dta _time_elasticity.csv _bilat_predicted_time.dta _orig_time.dta _dest_time.dta _wage.dta): ../input/data_before.do ../input/nyc_delta.do ../input/clean_wage.do ../input/merge_geocoords.do ../input/programs_LODES.do ../input/gravity_saveFE_time.do ../output/nyc2008_lodes_wzeros.dta $(addprefix ../input/, ny_od_main_JT01_2008.csv NYC_tractpairs_DDMM.dta 2015_gaz_tracts_36.txt ZIP_TRACT_122010.xlsx CB0800CZ1.txt) | $(OOPR)
	$(STATA) $< 2008
$(addprefix ../output/nyc2010, _lodes_wzero_wdelta.dta _time_elasticity.csv _bilat_predicted_time.dta _orig_time.dta _dest_time.dta _wage.dta): ../input/data_before.do ../input/nyc_delta.do ../input/clean_wage.do ../input/merge_geocoords.do ../input/programs_LODES.do ../input/gravity_saveFE_time.do ../output/nyc2010_lodes_wzeros.dta $(addprefix ../input/, ny_od_main_JT01_2010.csv NYC_tractpairs_DDMM.dta 2015_gaz_tracts_36.txt ZIP_TRACT_122010.xlsx CB1000CZ1.txt) | $(OOPR)
	$(STATA) $< 2010
../output/nyc%_lodes_wzeros.dta: ../input/process_lodes.do ../input/programs_LODES.do ../input/ny_od_main_JT01_%.csv | $(OOPR)
	$(STATA) $< $*

#CODE RECIPES
../input/merge_geocoords.do: ../../LODES_commuting_analysis/code/merge_geocoords.do | ../input
	ln -sf $< $@
../input/programs_LODES.do: ../../LODES_datapreparation/code/programs.do | ../input
	ln -sf $< $@
../input/data_before.do ../input/nyc_delta.do ../input/clean_wage.do ../input/process_lodes.do ../input/gravity_saveFE_time.do: ../input/%.do: ../../common_scripts/code/%.do | ../input
	ln -sf $< $@

#DATA INPUT RECIPES
../input/2015_gaz_tracts_36.txt: ../../initialdata/output/2015_gaz_tracts_36.txt | ../input
	ln -sf $< $@
../input/NYC_tractpairs_DDMM.dta: ../../initialdata/output/NYC_tractpairs_DDMM.dta | ../input
	ln -sf $< $@
../input/ny_od_main_JT01_%.csv: ../../LODES_downloaddata/output/ny_od_main_JT01_%.csv | ../input
	ln -sf $< $@
../input/CB%00CZ1.txt: ../../initialdata/output/CB%00CZ1.txt | ../input
	ln -sf $< $@
../input/CB%00CZ11.txt: ../../initialdata/output/CB%00CZ11.txt | ../input
	ln -sf $< $@
../input/ZIP_TRACT_1220%.xlsx: ../../initialdata/output/ZIP_TRACT_1220%.xlsx | ../input
	ln -sf $< $@
