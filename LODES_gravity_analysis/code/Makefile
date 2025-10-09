SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
gravity_dataprep = $(foreach geo, DetroitUA NYC, ../input/$(geo)_dist_covariates.dta ../input/$(geo)_LODES_pooled.dta) \
					../input/DetroitUA_delta_LODES2013.dta ../input/DetroitUA_delta_LODES2014.dta \
					$(foreach yr, 2010 2012 2013 2014,../input/NYC_delta_LODES$(yr).dta)
LODES_dataprep = ../input/lodes_DetroitUA_2013.dta ../input/lodes_DetroitUA_2014.dta \
					$(foreach yr, 2010 2013 2014,../input/lodes_NYC_$(yr).dta)
OUTPUTS = $(addprefix ../output/, \
			$(foreach location_yr, DetroitUA_2014 NYC_2010, \
				$(location_yr)_gravity_time_impute.tex   scatter_destFE_$(location_yr)_impute.eps) \
			NYC_outliers_Columbia_footnote.tex \
			$(foreach loc, DetroitUA NYC, gravity_outofsample_$(loc).tex) \
			NYC2010_gravity_time_impute_simple.tex)

all: $(OUTPUTS)
include ../../generic.make

# OUTPUT RECIPES
.SECONDEXPANSION:
../output/%_gravity_time_impute.tex ../output/scatter_destFE_%_impute.eps ../output/scatter_origFE_%_impute.eps: compare_gravity_estimators_time_impute.do ../input/$$(word 1,$$(subst _, ,$$*))_delta_LODES$$(word 2,$$(subst _, ,$$*)).dta | $(STATA_OOPR)
	$(STATA) $< $(subst _, ,$*)

# REGULAR TARGETS
../output/gravity_outofsample_DetroitUA.tex: gravity_outofsample_dist_time.do ../input/DetroitUA_delta_LODES2013.dta ../input/lodes_DetroitUA_2014.dta ../input/2015_gaz_tracts_26.txt | $(STATA_OOPR)
	$(STATA) $< DetroitUA
../output/gravity_outofsample_NYC.tex: gravity_outofsample_dist_time.do ../input/NYC_delta_LODES2013.dta ../input/lodes_NYC_2014.dta ../input/2015_gaz_tracts_36.txt | $(STATA_OOPR)
	$(STATA) $< NYC
../output/NYC2010_gravity_time_impute_simple.tex: compare_gravity_estimators_time_impute_simple.do  ../input/NYC_delta_LODES2010.dta | $(STATA_OOPR)
	$(STATA) $<

# GROUP TARGETS
../output/NYC_outliers_Columbia_footnote.tex: NYC_CBM_residuals.do $(shell grep -o '../input/[A-Za-z0-9_\.]*' NYC_CBM_residuals.do) | $(STATA_OOPR)
	$(STATA) $<

#INPUT RECIPES
$(gravity_dataprep): ../input/%.dta: ../../LODES_gravity_dataprep/output/%.dta | ../input
	ln -sf $< $@
$(LODES_dataprep): ../input/%.dta: ../../LODES_datapreparation/output/%.dta | ../input
	ln -sf $< $@
../input/2015_gaz_tracts_26.txt ../input/2015_gaz_tracts_36.txt: ../input/%.txt: ../../initialdata/output/%.txt | ../input
	ln -sf $< $@


