SHELL=bash
include ../../shell_functions.make

LODES_Detroit = $(foreach year, 2009 2010 2011 2012 2013 2014, ../input/mi_od_main_JT01_$(year).csv)
LODES_NYC = $(foreach year, 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017, ../input/ny_od_main_JT01_$(year).csv)
LODES_MSP = $(foreach year, 2010 2013 2014, ../input/wi_od_main_JT01_$(year).csv ../input/wi_od_aux_JT01_$(year).csv ../input/mn_od_aux_JT01_$(year).csv ../input/mn_od_main_JT01_$(year).csv)
INPUTS = $(LODES_Detroit) $(LODES_NYC) $(LODES_MSP) \
			../input/2015_gaz_tracts_36.txt ../input/NYC_tractpairs_DDMM.dta
OUTPUTS = $(foreach year, 2009 2010 2011 2012 2013 2014, ../output/lodes_DetroitUA_$(year).dta) \
			$(foreach year, 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017, ../output/lodes_NYC_$(year).dta ) \
			$(foreach year, 2010 2013 2014, ../output/lodes_MSP_$(year).dta)

## RECIPES
all: $(OUTPUTS)
clean:
	rm *.log
include ../../generic.make

# Detroit
../output/lodes_DetroitUA_%.dta: DetroitUA_tract.do programs.do ../input/mi_od_main_JT01_%.csv | $(STATA_OOPR)
	$(STATA) $< $*

# NYC
../output/lodes_NYC_%.dta: NYC_tract.do programs.do ../input/ny_od_main_JT01_%.csv ../input/2015_gaz_tracts_36.txt ../input/NYC_tractpairs_DDMM.dta | $(STATA_OOPR)
	$(STATA) $< $*

# MSP
../output/lodes_MSP_%.dta: MSP_tract.do ../input/wi_od_main_JT01_%.csv ../input/wi_od_aux_JT01_%.csv ../input/mn_od_aux_JT01_%.csv ../input/mn_od_main_JT01_%.csv | $(STATA_OOPR)
	$(STATA) $< $*


$(LODES_Detroit) $(LODES_NYC) $(LODES_MSP): ../input/%.csv: ../../LODES_downloaddata/output/%.csv | ../input
	ln -sf $< $@
../input/2015_gaz_tracts_36.txt: ../input/%.txt: ../../initialdata/output/%.txt | ../input
	ln -sf $< $@
../input/NYC_tractpairs_DDMM.dta: ../../initialdata/output/NYC_tractpairs_DDMM.dta | ../input
	ln -sf $< $@

