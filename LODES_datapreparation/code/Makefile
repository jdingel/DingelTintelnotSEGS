SHELL=bash
include ../../shell_functions.make

LODES_NYC = $(foreach year, 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017, ../input/ny_od_main_JT01_$(year).csv)
INPUTS = $(LODES_NYC) \
			../input/2015_gaz_tracts_36.txt ../input/NYC_tractpairs_DDMM.dta 
OUTPUTS = $(foreach year, 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017, ../output/lodes_NYC_$(year).dta) 

## RECIPES
all: $(INPUTS) $(OUTPUTS)
clean:
	rm *.log
include ../../generic.make

# NYC
../output/lodes_NYC_%.dta: NYC_tract.do programs.do ../input/ny_od_main_JT01_%.csv ../input/2015_gaz_tracts_36.txt ../input/NYC_tractpairs_DDMM.dta | $(OOPR)
	$(STATA) $< $*


$(LODES_NYC): ../input/%.csv: ../../LODES_downloaddata/output/%.csv | ../input
	ln -sf $< $@
../input/2015_gaz_tracts_36.txt: ../input/%.txt: ../../initialdata/output/%.txt | ../input
	ln -sf $< $@
../input/NYC_tractpairs_DDMM.dta: ../../initialdata/output/NYC_tractpairs_DDMM.dta | ../input
	ln -sf $< $@
