SHELL=bash
include ../../shell_functions.make

YEAR_LIST = 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017

INPUTS_OD = $(foreach year, $(YEAR_LIST), ../input/lodes_NYC_$(year).dta)
NYC_outputs_OD = $(addprefix ../output/,nyc_20102012_spikes_list.txt tract_employmentcountsOD_36061008300.eps tract_employmentcountsOD_36061005800.eps tract_employmentcountsOD_notes.tex)

all: $(INPUTS_OD) $(NYC_outputs_OD)
include ../../generic.make

../output/nyc_20102012_spikes_list.txt: findspikes_NYC_OD.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' findspikes_NYC_OD.do) | $(OOPR)
	$(STATA) $<
$(foreach tract, 36061008300 36061005800, ../output/tract_employmentcountsOD_$(tract).eps) ../output/tract_employmentcountsOD_notes.tex: emp_time_series.do $(INPUTS_OD) | $(OOPR)
	$(STATA) $<

#Inputs recipes
$(INPUTS_OD): ../input/%.dta: ../../LODES_datapreparation/output/%.dta | ../input
	ln -sf $< $@
