SHELL=bash
include ../../shell_functions.make

#### DEFINITIONS ####
LODES_MI_OD = $(foreach year, 2009 2010 2011 2012 2013 2014, \
				../output/mi_od_main_JT01_$(year).csv)
LODES_NY_OD = $(foreach year, 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017, ../output/ny_od_main_JT01_$(year).csv)
LODES_MSP_OD = $(foreach year, 2010 2013 2014, \
				../output/mn_od_main_JT01_$(year).csv ../output/wi_od_main_JT01_$(year).csv \
				../output/mn_od_aux_JT01_$(year).csv  ../output/wi_od_aux_JT01_$(year).csv )
OUTPUTS = $(LODES_MI_OD) $(LODES_NY_OD) $(LODES_MSP_OD) 

#### RECIPES ####
all: $(OUTPUTS)

include ../../generic.make
.INTERMEDIATE: $(foreach year, $(shell echo {2002..2017}), ../temp/ny_od_main_JT01_$(year).csv.gz)

#LODES commuting data
## Detroit
../output/mi_od_main_JT01_%.csv.gz: | ../output
	wget --no-check-certificate "https://lehd.ces.census.gov/data/lodes/LODES7/mi/od/$(@F)" -O ../output/$(@F)
../output/mi_od_main_JT01_%.csv: ../output/mi_od_main_JT01_%.csv.gz
	gunzip -c $< | cut -f 1-3 -d, > $@

## NYC
$(foreach year, 2008 2009 2010 2012, ../output/ny_od_main_JT01_$(year).csv): ../output/ny_od_main_JT01_%.csv: ../temp/ny_od_main_JT01_%.csv.gz
	gunzip -c $< | cut -f 1-3,7-9 -d, | grep -E '^w_geocode|^36005|^36047|^36061|^36081|^36085' | grep -E '^(.*,h_geocode|.*,36005|.*,36047|.*,36061|.*,36081|.*,36085)'  > $@ 
$(foreach year, $(shell echo {2002..2007} 2011 {2013..2017}), ../output/ny_od_main_JT01_$(year).csv): ../output/ny_od_main_JT01_%.csv: ../temp/ny_od_main_JT01_%.csv.gz
	gunzip -c $< | cut -f 1-3 -d, | grep -E '^w_geocode|^36005|^36047|^36061|^36081|^36085' | grep -E '^(.*,h_geocode|.*,36005|.*,36047|.*,36061|.*,36081|.*,36085)' > $@ 
../temp/ny_od_main_JT01_%.csv.gz: | ../output ../temp 
	wget --no-check-certificate "https://lehd.ces.census.gov/data/lodes/LODES7/ny/od/$(@F)" -O ../temp/$(@F)

## MSP
../output/wi_od_main_JT01_%.csv.gz: | ../output
	wget --no-check-certificate "https://lehd.ces.census.gov/data/lodes/LODES7/wi/od/$(@F)" -O ../output/$(@F)
../output/mn_od_main_JT01_%.csv.gz: | ../output
	wget --no-check-certificate "https://lehd.ces.census.gov/data/lodes/LODES7/mn/od/$(@F)" -O ../output/$(@F)
../output/wi_od_aux_JT01_%.csv.gz: | ../output
	wget --no-check-certificate "https://lehd.ces.census.gov/data/lodes/LODES7/wi/od/$(@F)" -O ../output/$(@F)
../output/mn_od_aux_JT01_%.csv.gz: | ../output
	wget --no-check-certificate "https://lehd.ces.census.gov/data/lodes/LODES7/mn/od/$(@F)" -O ../output/$(@F)
../output/wi_od_main_JT01_%.csv: ../output/wi_od_main_JT01_%.csv.gz
	gunzip -c $< | cut -f 1-3 -d, > $@
../output/mn_od_main_JT01_%.csv: ../output/mn_od_main_JT01_%.csv.gz
	gunzip -c $< | cut -f 1-3 -d, > $@
../output/wi_od_aux_JT01_%.csv: ../output/wi_od_aux_JT01_%.csv.gz
	gunzip -c $< | cut -f 1-3 -d, > $@
../output/mn_od_aux_JT01_%.csv: ../output/mn_od_aux_JT01_%.csv.gz
	gunzip -c $< | cut -f 1-3 -d, > $@

OUTPUTS_CHECKING = $(foreach year, 2009 2010 2011 2012 2013 2014, ../output/mi_od_main_JT01_$(year).csv) $(foreach year, 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017, ../output/ny_od_main_JT01_$(year).csv) $(foreach year, 2010 2013 2014, ../output/mn_od_main_JT01_$(year).csv ../output/wi_od_main_JT01_$(year).csv ../output/mn_od_aux_JT01_$(year).csv ../output/wi_od_aux_JT01_$(year).csv)

.PHONY: verify_downloads
verify_downloads: $(OUTPUTS_CHECKING) $(patsubst ../output/%,../report/%.md5,$(OUTPUTS_CHECKING))
	for file in $(OUTPUTS_CHECKING); do \
		report_file=$$(echo $$file | sed 's|output/|report/|').md5; \
		computed_hash=$$($(MDHASH) "$$file"); \
		stored_hash=$$(cat "$$report_file"); \
		if [ "$$computed_hash" != "$$stored_hash" ]; then \
			echo "MD5 mismatch: $$file"; exit 1; \
		else \
			echo "$$file matches"; \
		fi; \
	done