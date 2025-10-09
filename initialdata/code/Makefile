SHELL=bash
include ../../shell_functions.make

#### DEFINITIONS ####

CENSUS_GEO_Tract = ../output/2015_gaz_tracts_36.txt ../output/2015_gaz_tracts_26.txt
ACS_COMMUTING = ../output/ACS_20112015_commuting.xlsx ../output/ACS_20092013_commuting.xlsx ../output/ACS_20062010_commuting.xlsx
ZIP_Tract = $(foreach year, 2010 2011 2012 2013, ../output/ZIP_TRACT_12$(year).xlsx)
ZIP_wage_before10 = $(foreach year, 06 07 08 09 10, ../temp/CB$(year)00CZ1.zip ../output/CB$(year)00CZ1.txt)
OUTPUTS =   $(CENSUS_GEO_Tract) $(ACS_COMMUTING) $(ZIP_Tract) $(ZIP_wage_before10) \
			../output/sf12010countydistance100miles.csv ../output/NYC_tractpairs_DDMM.dta ../output/CENSO10_commuting.dta \
			../output/Kij_GoogleTime.xlsx \
			$(foreach num,06 07 08 09 10,../output/CB$(num)00CZ1.txt) \
			../output/nyc2010census_tabulation_equiv.xlsx

.SECONDARY: ../temp ../temp/RD_AEJP_0651_Replication_Files.zip

#### RECIPES ####

all: $(OUTPUTS)
include ../../generic.make

#Owens, Rossi-Hansberg, and Sarte (2020): The benchmark year in our analysis is 2014. Our analysis covers the 297 census tracts in Detroit, as well as the surrounding adjacent metro area (Wayne County, Oakland County, and Macomb County), which includes 866 additional tracts.
../temp/RD_AEJP_0651_Replication_Files.zip: | ../temp
	wget --no-check-certificate "https://www.dropbox.com/s/zyanui1llqv2djh/RD_AEJP_0651_Replication_Files.zip?dl=0"  -O $@

../output/Tract_Classification.xlsx:  | ../output ../temp/RD_AEJP_0651_Replication_Files.zip
	unzip -j ../temp/RD_AEJP_0651_Replication_Files.zip "RD_AEJP_0651_Replication_Files/Stata-to-Excel/Tract Classification.xlsx" -d ../output
	mv "../output/Tract Classification.xlsx" $@

../output/Kij_GoogleTime.xlsx: | ../output ../temp/RD_AEJP_0651_Replication_Files.zip
	unzip -j ../temp/RD_AEJP_0651_Replication_Files.zip RD_AEJP_0651_Replication_Files/Stata-to-Excel/$(@F) -d ../output

#American Community Survey commuting data
../output/ACS_20112015_commuting.xlsx: | ../output
	wget --no-check-certificate "https://www2.census.gov/programs-surveys/demo/tables/metro-micro/2015/commuting-flows-2015/table1.xlsx" -O $@
../output/ACS_20092013_commuting.xlsx: | ../output
	wget --no-check-certificate "https://www2.census.gov/programs-surveys/commuting/tables/time-series/commuting-flows/table1.xlsx" -O $@
../output/ACS_20062010_commuting.xlsx: | ../output
	wget --no-check-certificate "https://www2.census.gov/programs-surveys/demo/tables/metro-micro/2010/commuting-employment-2010/table1.xlsx" -O $@

##NYC tract-to-tract transit times from Davis, Dingel, Monras, Morales (2019)
../output/NYC_tractpairs_DDMM.dta: | ../temp/tractpairs.dta.zip ../output
	unzip -d ../temp ../temp/tractpairs.dta.zip
	mv ../temp/tractpairs.dta $@
../temp/tractpairs.dta.zip: | ../temp
	wget --no-check-certificate "https://github.com/jdingel/DavisDingelMonrasMorales/raw/master/initialdata/input/tractpairs.dta.zip" -O $@

# US Census tract-level geographic info
# tract-level
# NY
../output/2015_gaz_tracts_36.txt: | ../output
	wget --no-check-certificate "https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2015_Gazetteer/2015_gaz_tracts_36.txt" -O $@
# MI
../output/2015_gaz_tracts_26.txt: | ../output
	wget --no-check-certificate "https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2015_Gazetteer/2015_gaz_tracts_26.txt" -O $@

# county-level
../output/sf12010countydistance100miles.csv: | ../output
	wget --no-check-certificate "http://data.nber.org/distance/2010/sf1/county/$(@F)" -O ../output/$(@F)

# ZIP Code Business Statistics
../output/CB%00CZ1.txt: | ../temp/CB%00CZ1.zip ../output
	unzip -LL ../temp/CB$*00CZ1.zip -d ../temp
	mv ../temp/cb$*00cz1.dat ../output/CB$*00CZ1.txt
../temp/CB%00CZ1.zip:| ../temp
	wget --no-check-certificate "https://www2.census.gov/econ20$*/CB/sector00/$(@F)" -O $@

# ZIP-Tract crosswalk
../output/ZIP_TRACT_12%.xlsx: | ../output
	wget --no-check-certificate "https://www.huduser.gov/portal/datasets/usps/$(@F)" -O ../output/$(@F)

# NTA-tract equivalency
../output/nyc2010census_tabulation_equiv.xlsx: | ../output
	wget --no-check-certificate "https://www1.nyc.gov/assets/planning/download/office/data-maps/nyc-population/census2010/$(@F)" -O ../output/$(@F)

# Brazil Municipio coordinates
../output/municipios_2010_withcoordinates.dta:
	$(error $@ is drawn from the Dingel-Miscio-Davis project. $@ should be committed to this repo.)

# Brazil Census data
../output/CENSO10_commuting.dta: | ../temp/CENSO10_commuting.dta.zip ../output
	unzip ../temp/CENSO10_commuting.dta.zip  -d ../output
../temp/CENSO10_commuting.dta.zip: | ../temp
	wget --no-check-certificate "https://github.com/jdingel/DingelMiscioDavis/raw/master/brazil/municipio_to_MSA/output/CENSO10_commuting.dta.zip" -O $@

OUTPUTS_CSV_TXT = $(addprefix ../output/, 2015_gaz_tracts_36.txt 2015_gaz_tracts_26.txt sf12010countydistance100miles.csv $(foreach num,06 07 08 09 10,CB$(num)00CZ1.txt))
.PHONY: verify_downloads
verify_downloads: $(OUTPUTS_CSV_TXT) $(patsubst ../output/%,../report/%.md5,$(OUTPUTS_CSV_TXT))
	for file in $(OUTPUTS_CSV_TXT); do \
		report_file=$$(echo $$file | sed 's|output/|report/|').md5; \
		computed_hash=$$($(MDHASH) "$$file"); \
		stored_hash=$$(cat "$$report_file"); \
		if [ "$$computed_hash" != "$$stored_hash" ]; then \
			echo "MD5 mismatch: $$file"; exit 1; \
		else \
			echo "$$file matches"; \
		fi; \
	done

##Plain text files for data editor
XLSX_LIST = Tract_Classification Kij_GoogleTime ACS_20112015_commuting ACS_20092013_commuting ACS_20062010_commuting nyc2010census_tabulation_equiv $(foreach year, 2010 2011 2012 2013, ZIP_TRACT_12$(year))
DTA_LIST = NYC_tractpairs_DDMM municipios_2010_withcoordinates CENSO10_commuting
../output_plaintext:
	mkdir $@
.PHONY: plain_text
plain_text: $(foreach stub,$(XLSX_LIST) $(DTA_LIST),../output_plaintext/$(stub).csv)
$(foreach stub,$(XLSX_LIST),../output_plaintext/$(stub).csv): ../output_plaintext/%.csv: ../output/%.xlsx | ../output_plaintext
	in2csv $< > $@ #This requires csvkit: https://csvkit.readthedocs.io (not used elsewhere in this repo)
$(foreach stub,$(DTA_LIST),../output_plaintext/$(stub).csv): ../output_plaintext/%.csv: ../output/%.dta | ../output_plaintext
	$(STATA) convert_DTA_to_CSV.do $< $@