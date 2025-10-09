SHELL=bash
include ../../shell_functions.make

data_prep = $(foreach year, 2009 2010 2011 2012 2013 2014, \
			../input/lodes_DetroitUA_$(year).dta) \
			../input/lodes_detroitMSA_2010.dta ../input/lodes_detroitMSA_2014.dta ../input/lodes_detroitMSA_county_2014.dta ../input/lodes_detroitMSA_place_2014.dta \
			$(foreach year, 2008 2009 2010 2011 2012 2013 2014, ../input/lodes_NYC_$(year).dta) \
			$(foreach year, 2010 2013 2014, ../input/lodes_MSP_$(year).dta ../input/lodes_MSP_county_$(year).dta) 
GEO_list = DetroitUA MSP NYC
OUTPUTS = 	$(addprefix ../output/, $(foreach location_yr, DetroitUA_2014 NYC_2010 MSP_2014, \
				$(location_yr)_asymmetriczeros.tex $(location_yr)_asymmetriczeros_robust.tex \
				$(location_yr)_share1.tex $(location_yr)_share5.tex) \
			$(foreach location, $(GEO_list), \
				$(location)_2013_2014_tabulatezerosfreq.tex $(location)_2013_2014_tabulatezerospct.tex $(location)_2013_2014_zeropersistence.tex $(location)_2013_2014_transition_matrix.tex $(location)_2013_2014_bothzeros.tex \
				histogram_$(location)_2010_positive.eps histogram_$(location)_2010_withzeros.eps histogram_$(location)_2010.eps histogram_$(location)_2010_topcode.tex \
				histogram_$(location)_2014_positive.eps histogram_$(location)_2014_withzeros.eps histogram_$(location)_2014.eps histogram_$(location)_2014_topcode.tex \
				$(location)_2010_zeros_prev.tex $(location)_2010_zeros_prev_slide.tex $(location)_2010_number_tracts.tex \
				$(location)_2014_zeros_prev.tex $(location)_2014_zeros_prev_slide.tex $(location)_2014_number_tracts.tex \
				text_count_pop_pair_$(location)_2014.tex) \
				histogram_NYC_2010_positive_w_shares.eps \
				$(foreach location, DetroitUA MSP, histogram_$(location)_2014_positive_w_shares.eps) \
			DetroitUA_2014_mediantract_employees.tex DetroitUA_2014_share5_slides.tex DetroitUA_2013zero_2014pos.tex \
			NYC_2014_count_cells_and_ppl.tex NYC_2010_share1.tex NYC_2010_share5.tex NYC_2010_share5_slides.tex NYC_2010_mediantract_employees.tex \
			text_count_pop_pair_NYC_2010.tex)

all: $(OUTPUTS)
clean:
	rm *.log
include ../../generic.make

#GROUPED TARGETS
$(addprefix ../output/NYC_,2014_count_cells_and_ppl.tex 2014_share1.tex 2014_share5.tex 2010_share1.tex 2010_share5.tex 2010_share5_slides.tex 2010_mediantract_employees.tex): NYC.do programs_descriptives.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' NYC.do) | $(STATA_OOPR)
	$(STATA) $<
$(addprefix ../output/DetroitUA_2014_,share1.tex share5.tex mediantract_employees.tex share5_slides.tex) ../output/DetroitUA_2013zero_2014pos.tex: detroit_descriptives.do programs_descriptives.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' detroit_descriptives.do) | $(STATA_OOPR)
	$(STATA) $<
$(addprefix ../output/MSP_2014_, share1.tex share5.tex mediantract_employees.tex count_cells_and_ppl.tex): MSP_descriptives.do programs_descriptives.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' MSP_descriptives.do) | $(STATA_OOPR)
	$(STATA) $<
#REGULAR RECIPES
../output/%_2014_asymmetriczeros.tex ../output/%_2014_asymmetriczeros_robust.tex: asymmetriczeros.do ../input/lodes_%_2014.dta | $(STATA_OOPR)
	$(STATA) $< $* 2014
../output/%_2010_asymmetriczeros.tex ../output/%_2010_asymmetriczeros_robust.tex: asymmetriczeros.do ../input/lodes_%_2010.dta | $(STATA_OOPR)
	$(STATA) $< $* 2010
../output/%_2013_2014_tabulatezerosfreq.tex ../output/%_2013_2014_tabulatezerospct.tex ../output/%_2013_2014_zeropersistence.tex ../output/%_2013_2014_transition_matrix.tex ../output/%_2013_2014_bothzeros.tex: transitionmatrix.do ../input/lodes_%_2013.dta ../input/lodes_%_2014.dta | $(STATA_OOPR)
	$(STATA) $< $*
$(addprefix ../output/, histogram_%_2014_positive.eps histogram_%_2014_withzeros.eps histogram_%_2014.eps %_2014_zeros_prev.tex %_2014_zeros_prev_slide.tex %_2014_number_tracts.tex histogram_%_2014_topcode.tex): tractpair_histograms.do ../input/lodes_%_2014.dta | $(STATA_OOPR)
	$(STATA) $< $* 2014
$(addprefix ../output/, histogram_%_2010_positive.eps histogram_%_2010_withzeros.eps histogram_%_2010.eps %_2010_zeros_prev.tex %_2010_zeros_prev_slide.tex %_2010_number_tracts.tex histogram_%_2010_topcode.tex): tractpair_histograms.do ../input/lodes_%_2010.dta | $(STATA_OOPR)
	$(STATA) $< $* 2010
../output/histogram_%_2010_positive_w_shares.eps: tractpair_histograms_w_shares.do ../input/lodes_%_2010.dta | $(STATA_OOPR)
	$(STATA) $< $* 2010
../output/histogram_%_2014_positive_w_shares.eps: tractpair_histograms_w_shares.do ../input/lodes_%_2014.dta | $(STATA_OOPR)
	$(STATA) $< $* 2014
../output/text_count_pop_pair_%_2014.tex: count_pop_pair.do ../input/lodes_%_2014.dta | $(STATA_OOPR)
	$(STATA) $< $* 2014
../output/text_count_pop_pair_%_2010.tex: count_pop_pair.do ../input/lodes_%_2010.dta | $(STATA_OOPR)
	$(STATA) $< $* 2010

$(data_prep): ../input/%.dta: ../../LODES_datapreparation/output/%.dta | ../input
	ln -sf $< $@

