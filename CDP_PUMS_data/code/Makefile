SHELL=bash
include ../../shell_functions.make
																											
# RECIPES
all: $(addprefix ../output/, ss01pus.csv ss02pus.csv PUMSDataDict00_02.pdf puma_code.csv migsp_code.csv)
include ../../generic.make

# Download PUMS data and data dictionary for state abbreviation lists
../output/ss01pus.csv: | ../temp/ss01pus.zip 
	unzip $| -d ../output
../temp/ss01pus.zip: | ../temp
	wget --no-check-certificate "https://www2.census.gov/programs-surveys/acs/data/pums/2001/csv_pus.zip" -O $@

../output/ss02pus.csv: | ../temp/ss02pus.zip 
	unzip $| -d ../output
../temp/ss02pus.zip: | ../temp
	wget --no-check-certificate "https://www2.census.gov/programs-surveys/acs/data/pums/2002/csv_pus.zip" -O $@

../output/PUMSDataDict00_02.pdf: | ../output
	wget --no-check-certificate "https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMSDataDict00_02.pdf" -O $@

../output/puma_code.csv ../output/migsp_code.csv: state_codes_manually_extracted.txt
	$(error migsp and puma codes are hand collected from the data dictionary. See $<)

OUTPUTS_CHECKING = $(addprefix ../output/, ss01pus.csv ss02pus.csv)
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