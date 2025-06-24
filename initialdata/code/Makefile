SHELL=bash
include ../../shell_functions.make

all: $(addprefix ../output/,2015_gaz_tracts_36.txt CB1000CZ1.txt NYC_tractpairs_DDMM.dta ZIP_TRACT_122010.xlsx nyc2010census_tabulation_equiv.xlsx)
include ../../generic.make
.INTERMEDIATE: ../temp ../temp/tractpairs.dta.zip ../temp/CB%00CZ1.zip

##NYC tract-to-tract transit times from Davis, Dingel, Monras, Morales (2019)
../output/NYC_tractpairs_DDMM.dta: | ../temp/tractpairs.dta.zip ../output
	unzip -d ../temp ../temp/tractpairs.dta.zip
	mv ../temp/tractpairs.dta $@
../temp/tractpairs.dta.zip: | ../temp
	wget "https://github.com/jdingel/DavisDingelMonrasMorales/raw/master/initialdata/input/tractpairs.dta.zip" -O $@

# US Census tract-level geographic info
../output/2015_gaz_tracts_36.txt: | ../output
	wget "https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2015_Gazetteer/2015_gaz_tracts_36.txt" -O $@

# ZIP Code Business Statistics
../output/CB%00CZ1.txt: | ../temp/CB%00CZ1.zip ../output
	unzip -LL ../temp/CB$*00CZ1.zip -d ../temp
	mv ../temp/cb$*00cz1.dat ../output/CB$*00CZ1.txt
../temp/CB%00CZ1.zip:| ../temp
	wget "https://www2.census.gov/econ20$*/CB/sector00/$(@F)" -O $@

# ZIP-Tract crosswalk
../output/ZIP_TRACT_12%.xlsx: | ../output
	wget "https://www.huduser.gov/portal/datasets/usps/$(@F)" -O ../output/$(@F)
