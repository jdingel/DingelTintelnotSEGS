SHELL=bash
include ../../shell_functions.make


## RECIPES
all: ../output/NYC_dist_to_treated.dta
include ../../generic.make

../output/NYC_dist_to_treated.dta: dist_to_treated.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' dist_to_treated.do) | $(STATA_OOPR)
	$(STATA) $<

# Input Recipes
../input/2015_gaz_tracts_36.txt: ../../initialdata/output/2015_gaz_tracts_36.txt | ../input
	ln -sf $< $@
