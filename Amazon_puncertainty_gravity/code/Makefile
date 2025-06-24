SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sim = $(shell seq 1 1 100)
OUTPUTS = $(foreach sim, $(set_sim), ../output/nyc2010_lodes_wzero_wdelta_puncertainty_$(sim).dta ../output/nyc2010_time_elasticity_puncertainty_$(sim).csv ../output/nyc2010_bilat_predicted_time_puncertainty_$(sim).dta ../output/nyc2010_orig_time_puncertainty_$(sim).dta ../output/nyc2010_dest_time_puncertainty_$(sim).dta)

all: $(OUTPUTS)
include ../../generic.make


#OUTPUT RECIPES
../output/nyc2010_lodes_wzero_wdelta_puncertainty_%.dta ../output/nyc2010_time_elasticity_puncertainty_%.csv ../output/nyc2010_bilat_predicted_time_puncertainty_%.dta ../output/nyc2010_orig_time_puncertainty_%.dta ../output/nyc2010_dest_time_puncertainty_%.dta ../output/nyc2010_wage_puncertainty_%.dta:  gravity.do ../input/nyc_delta.do ../input/merge_geocoords.do  ../input/gravity_saveFE_time.do ../input/baseline_data_puncertainty_s%.csv  ../input/NYC_tractpairs_DDMM.dta ../input/2015_gaz_tracts_36.txt ../input/ZIP_TRACT_122010.xlsx ../input/CB1000CZ1.txt | $(OOPR)
	$(STATA) $< $*

#CODE RECIPES
../input/merge_geocoords.do: ../../LODES_commuting_analysis/code/merge_geocoords.do | ../input
	ln -sf $< $@
../input/programs_LODES.do: ../../LODES_datapreparation/code/programs.do | ../input
	ln -sf $< $@
../input/data_before.do ../input/nyc_delta.do ../input/clean_wage.do ../input/process_lodes.do ../input/gravity_saveFE_time.do: ../input/%.do: ../../common_scripts/code/%.do | ../input
	ln -sf $< $@

#DATA INPUT RECIPES
../input/baseline_data_puncertainty_s%.csv: ../../Amazon_puncertainty_baseline_data/output/baseline_data_puncertainty_s%.csv | ../input
	ln -sf $< $@
../input/2015_gaz_tracts_36.txt: ../../initialdata/output/2015_gaz_tracts_36.txt | ../input
	ln -sf $< $@
../input/NYC_tractpairs_DDMM.dta: ../../initialdata/output/NYC_tractpairs_DDMM.dta | ../input
	ln -sf $< $@
../input/CB%00CZ1.txt: ../../initialdata/output/CB%00CZ1.txt | ../input
	ln -sf $< $@
../input/CB%00CZ11.txt: ../../initialdata/output/CB%00CZ11.txt | ../input
	ln -sf $< $@
../input/ZIP_TRACT_1220%.xlsx: ../../initialdata/output/ZIP_TRACT_1220%.xlsx | ../input
	ln -sf $< $@

