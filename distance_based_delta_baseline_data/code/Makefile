SHELL=bash
include ../../shell_functions.make
OUTPUTS_dist = $(addprefix ../output/, nyc2010_bilat_predicted_dist.dta \
nyc2010_orig_dist.dta nyc2010_dest_dist.dta \
nyc2010_time_elasticity_dist.csv nyc2010_lodes_wzero_wdistdelta.dta log_time_log_dist_r2.tex)

## RECIPES
all: $(OUTPUTS_dist)
include ../../generic.make

#Output Recipes 
$(OUTPUTS_dist) : df_before_dist_delta.do compute_distance_based_delta_fn.do $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z]*' df_before_dist_delta.do)  ../input/2015_gaz_tracts_36.txt ../input/NYC_tractpairs_DDMM.dta | $(STATA_OOPR)
	 $(STATA) $< 

#Input Recipes
../input/merge_geocoords.do: ../../LODES_commuting_analysis/code/merge_geocoords.do | ../input
	ln -sf $< $@
../input/programs_LODES.do: ../../LODES_datapreparation/code/programs.do | ../input
	ln -sf $< $@
../input/gravity_saveFE_time.do: ../input/%.do: ../../common_scripts/code/%.do | ../input
	ln -sf $< $@

../input/2015_gaz_tracts_36.txt ../input/NYC_tractpairs_DDMM.dta: ../input/%: ../../initialdata/output/% | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzeros.dta: ../../nyc_baseline_data/output/nyc2010_lodes_wzeros.dta | ../input
	ln -sf $< $@
