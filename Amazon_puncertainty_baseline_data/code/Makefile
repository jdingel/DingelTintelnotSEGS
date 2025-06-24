SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_simulation = $(shell seq 1 1 100)
set_sim_report = $(shell seq 1 1 5)

OUTPUTS = $(foreach simulation, $(set_simulation), ../output/baseline_data_puncertainty_s$(simulation).csv)
REPORTS = $(foreach simulation, $(set_sim_report), ../report/baseline_data_puncertainty_s$(simulation).csv.log)

all: $(OUTPUTS) $(REPORTS)
reports: $(REPORTS)
include ../../generic.make

## OUTPUT RECIPES
../output/baseline_data_puncertainty_s%.csv: simulate_baseline_data.jl ../temp/df_before.csv | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< $* 

## TEMP RECIPES
../temp/df_before.csv: create_df_before.jl ../input/nyc2010_lodes_wzero_wdelta.dta | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< 

## INPUT RECIPE
../input/nyc2010_lodes_wzero_wdelta.dta: ../../nyc_baseline_data/output/nyc2010_lodes_wzero_wdelta.dta | ../input
	ln -sf $< $@


