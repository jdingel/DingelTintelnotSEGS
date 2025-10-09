SHELL=bash
include ../../shell_functions.make

#### DEFINITIONS ####
year_list = 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017

INPUTS_OD = $(foreach year, $(year_list), ../input/lodes_NYC_$(year).dta)
NYC_outputs_OD = ../output/nyc_20102012_spikes_list.txt ../output/tract_employmentcountsOD_36061008300.eps ../output/tract_employmentcountsOD_36061005800.eps ../output/tract_employmentcountsOD_notes.tex


#### RECIPES ####
all: $(NYC_outputs_OD)
include ../../generic.make

../output/nyc_20102012_spikes_list.txt: findspikes_NYC_OD.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' findspikes_NYC_OD.do) | $(STATA_OOPR)
	$(STATA) $<
$(foreach tract, 36061008300 36061005800, ../output/tract_employmentcountsOD_$(tract).eps) ../output/tract_employmentcountsOD_notes.tex: emp_time_series.do $(INPUTS_OD) | $(STATA_OOPR)
	$(STATA) $<

$(INPUTS_OD): ../input/%.dta: ../../LODES_datapreparation/output/%.dta | ../input
	ln -sf $< $@
