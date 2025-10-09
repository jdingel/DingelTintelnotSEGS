SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
OUTPUTS_NYC_2010 = $(foreach file,bilat_predicted_time orig_time dest_time wage lodes_wzeros lodes_wzero_wdelta,../output/nyc2010_$(file).dta) ../output/nyc2010_time_elasticity.csv
OUTPUTS_NYC_2008 = $(foreach file,bilat_predicted_time orig_time dest_time wage lodes_wzeros lodes_wzero_wdelta,../output/nyc2008_$(file).dta) ../output/nyc2008_time_elasticity.csv
OUTPUTS_NYC_AFTER = ../output/nyc2012_lodes_wzeros.dta
OUTPUTS_NYC_POOLED = $(foreach yrrange, 2008_2010, ../output/nyc_avg_wage_$(yrrange).dta ../output/nyc_avg_labor_$(yrrange).dta \
															../output/nyc_pool_$(yrrange)_lodes_wzero_wdelta.dta ../output/nyc_pool_$(yrrange)_time_elasticity.csv \
															../output/nyc_pool_bilat_predicted_$(yrrange).dta ../output/nyc_pool_$(yrrange)_orig_time.dta ../output/nyc_pool_$(yrrange)_dest_time.dta)

all: $(OUTPUTS_NYC_2010) $(OUTPUTS_NYC_2008) $(OUTPUTS_NYC_AFTER) $(OUTPUTS_NYC_POOLED) ../output/nyc_delta_bar.jld2
include ../../generic.make

#OUTPUT RECIPES
../output/nyc_delta_bar.jld2: convert_delta_bar_to_jld.jl ../input/describe_data.jl ../output/nyc2010_lodes_wzero_wdelta.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $<

../output/nyc2010_stddev_epslndelta.tex: nyc2010_stddev_epslndelta.do ../output/nyc2010_lodes_wzero_wdelta.dta ../output/nyc2010_time_elasticity.csv | $(STATA_OOPR)
	$(STATA) $<

#GROUP RECIPES
../output/nyc_avg_wage_2008_2010.dta ../output/nyc_avg_labor_2008_2010.dta: wage_labor_pool.do $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z]*' wage_labor_pool.do) ../input/ZIP_TRACT_122010.xlsx ../input/CB0800CZ1.txt ../input/CB0900CZ1.txt ../input/CB1000CZ1.txt ../input/ny_od_main_JT01_2008.csv ../input/ny_od_main_JT01_2009.csv ../input/ny_od_main_JT01_2010.csv | $(STATA_OOPR)
	$(STATA) $< 2008 2010

#IMPLICIT RULES
../output/nyc_pool_%_lodes_wzero_wdelta.dta ../output/nyc_pool_%_time_elasticity.csv ../output/nyc_pool_bilat_predicted_%.dta ../output/nyc_pool_%_orig_time.dta ../output/nyc_pool_%_dest_time.dta: gravity_pool.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' gravity_pool.do) ../input/NYC_tractpairs_DDMM.dta ../input/2015_gaz_tracts_36.txt ../output/nyc_avg_labor_%.dta | $(STATA_OOPR)
	$(STATA) $< $(subst _, ,$*)
$(addprefix ../output/nyc2008, _lodes_wzero_wdelta.dta _time_elasticity.csv _bilat_predicted_time.dta _orig_time.dta _dest_time.dta _wage.dta): ../input/data_before.do ../input/nyc_delta.do ../input/clean_wage.do ../input/merge_geocoords.do ../input/programs_LODES.do ../input/gravity_saveFE_time.do ../output/nyc2008_lodes_wzeros.dta $(addprefix ../input/, ny_od_main_JT01_2008.csv NYC_tractpairs_DDMM.dta 2015_gaz_tracts_36.txt ZIP_TRACT_122010.xlsx CB0800CZ1.txt) | $(STATA_OOPR)
	$(STATA) $< 2008
$(addprefix ../output/nyc2010, _lodes_wzero_wdelta.dta _time_elasticity.csv _bilat_predicted_time.dta _orig_time.dta _dest_time.dta _wage.dta): ../input/data_before.do ../input/nyc_delta.do ../input/clean_wage.do ../input/merge_geocoords.do ../input/programs_LODES.do ../input/gravity_saveFE_time.do ../output/nyc2010_lodes_wzeros.dta $(addprefix ../input/, ny_od_main_JT01_2010.csv NYC_tractpairs_DDMM.dta 2015_gaz_tracts_36.txt ZIP_TRACT_122010.xlsx CB1000CZ1.txt) | $(STATA_OOPR)
	$(STATA) $< 2010
../output/nyc%_lodes_wzeros.dta: ../input/process_lodes.do ../input/programs_LODES.do ../input/ny_od_main_JT01_%.csv | $(STATA_OOPR)
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
../input/ZIP_TRACT_1220%.xlsx: ../../initialdata/output/ZIP_TRACT_1220%.xlsx | ../input
	ln -sf $< $@
