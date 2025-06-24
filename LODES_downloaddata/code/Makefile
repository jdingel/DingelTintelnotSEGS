SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
LODES_NY = $(foreach year, 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017, \
				../output/ny_wac_S000_JT00_$(year).csv ../output/ny_wac_S000_JT01_$(year).csv \
				../output/ny_rac_S000_JT00_$(year).csv ../output/ny_rac_S000_JT01_$(year).csv)
LODES_NY_OD = $(foreach year, 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017, ../output/ny_od_main_JT01_$(year).csv)
OUTPUTS = $(LODES_NY) $(LODES_NY_OD) 

## RECIPES
all: $(OUTPUTS)

include ../../generic.make
.INTERMEDIATE: $(foreach year, $(shell echo {2002..2017}), ../temp/ny_od_main_JT01_$(year).csv.gz) ../temp/ny_od_main_JT01_%.csv.gz

# LODES workplace area characteristics data
../output/ny_wac_S000_JT00_%.csv.gz: | ../output
	wget "https://lehd.ces.census.gov/data/lodes/LODES7/ny/wac/$(@F)" -O ../output/$(@F)
../output/ny_wac_S000_JT00_%.csv: ../output/ny_wac_S000_JT00_%.csv.gz
	gunzip -c $< > $@
../output/ny_wac_S000_JT01_%.csv.gz: | ../output
	wget "https://lehd.ces.census.gov/data/lodes/LODES7/ny/wac/$(@F)" -O ../output/$(@F)
../output/ny_wac_S000_JT01_%.csv: ../output/ny_wac_S000_JT01_%.csv.gz
	gunzip -c $< > $@

# LODES residence area characteristics data
../output/ny_rac_S000_JT00_%.csv.gz: | ../output
	wget "https://lehd.ces.census.gov/data/lodes/LODES7/ny/rac/$(@F)" -O ../output/$(@F)
../output/ny_rac_S000_JT00_%.csv: ../output/ny_rac_S000_JT00_%.csv.gz
	gunzip -c $< > $@
../output/ny_rac_S000_JT01_%.csv.gz: | ../output
	wget "https://lehd.ces.census.gov/data/lodes/LODES7/ny/rac/$(@F)" -O ../output/$(@F)
../output/ny_rac_S000_JT01_%.csv: ../output/ny_rac_S000_JT01_%.csv.gz
	gunzip -c $< > $@

#LODES commuting data

## NYC
$(foreach year, 2008 2009 2010 2012, ../output/ny_od_main_JT01_$(year).csv): ../output/ny_od_main_JT01_%.csv: ../temp/ny_od_main_JT01_%.csv.gz
	gunzip -c $< | cut -f 1-3,7-9 -d, | grep -E '^w_geocode|^36005|^36047|^36061|^36081|^36085' | grep -E '^(.*,h_geocode|.*,36005|.*,36047|.*,36061|.*,36081|.*,36085)'  > $@ 
$(foreach year, $(shell echo {2002..2007} 2011 {2013..2017}), ../output/ny_od_main_JT01_$(year).csv): ../output/ny_od_main_JT01_%.csv: ../temp/ny_od_main_JT01_%.csv.gz
	gunzip -c $< | cut -f 1-3 -d, | grep -E '^w_geocode|^36005|^36047|^36061|^36081|^36085' | grep -E '^(.*,h_geocode|.*,36005|.*,36047|.*,36061|.*,36081|.*,36085)' > $@ 
../temp/ny_od_main_JT01_%.csv.gz: | ../output ../temp 
	wget "https://lehd.ces.census.gov/data/lodes/LODES7/ny/od/$(@F)" -O ../temp/$(@F)


