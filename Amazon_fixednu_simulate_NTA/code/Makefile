SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_simulation = $(shell seq 1 1 100)

OUTPUTS = $(foreach simulation, $(set_simulation), \
		../output/finite_labor_allocation_NTA_s$(simulation).csv.zip \
		../output/simulation_fixednu_NTA_s$(simulation).jld2)

REPORTS = $(foreach simulation, $(set_simulation), ../report/granular_NTA_s$(simulation).csv.log)

.INTERMEDIATE: $(foreach simulation, $(set_simulation), \
		../temp/finite_labor_allocation_NTA_s$(simulation).csv)

all: $(OUTPUTS) $(REPORTS)
reports: $(REPORTS)
include ../../generic.make

## OUTPUT RECIPES
../output/simulation_fixednu_NTA_s%.jld2: finitemodel_simulation_NTA.jl ../temp/finite_labor_allocation_NTA_s%.csv $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' finitemodel_simulation_NTA.jl) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

../output/finite_labor_allocation_NTA_s%.csv.zip: ../temp/finite_labor_allocation_NTA_s%.csv | $(OOPR)
	zip $@ $< -j 


## TEMP RECIPES
../temp/amazon_ctfl_cbm_%_meanutil.csv: ../input/compute_meanutil.jl ../input/primitives_nyc_NTA_2010_time.jld2 ../input/model_cbm_nta.jld2 $(foreach input, rent wage shock, ../input/amazon_ctfl_cbm_%_$(input).csv) ../input/baseline_equilibrium_outcomes_nta.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $^ $@

../temp/granular_NTA_s%.csv: finitemodel_simulate_choices_NTA.jl ../temp/amazon_ctfl_cbm_nta_meanutil.csv $(shell grep -o '\.\./input/[A-Za-z0-9_\.]*' finitemodel_simulate_choices_NTA.jl) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

../temp/finite_labor_allocation_NTA_s%.csv: finitemodel_collect_choices_NTA.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' finitemodel_collect_choices_NTA.do) ../temp/granular_NTA_s%.csv | $(STATA_OOPR)
	$(STATA) $< $*

## TEMP REPORT RECIPE
../report/granular_NTA_s%.csv.log: ../temp/granular_NTA_s%.csv | ../report
ifneq ($(shell command -v md5),)
	cat <(md5 $<) <(echo -n 'Lines:') <(cat $< | wc -l ) <(head -3 $<) <(echo '...') <(tail -2 $<)  > $@
else
	cat <(md5sum $<) <(echo -n 'Lines:') <(cat $< | wc -l ) <(head -3 $<) <(echo '...') <(tail -2 $<) > $@
endif

## INPUT RECIPE
../input/model_cbm_%.jld2: ../../baseline_models_foreha/output/model_cbm_%.jld2 | ../input
	ln -sf $< $@
../input/compute_meanutil.jl: ../../Amazon_fixednu_simulate/code/compute_meanutil.jl | ../input
	ln -sf $< $@
../input/finitemodel_programs.jl: ../../finitemodel_solver/code/finitemodel_programs.jl | ../input
	ln -sf $< $@
../input/shock_tract.jl: ../../common_scripts/code/shock_tract.jl | ../input
	ln -sf $< $@
../input/nyc_NTA_2010_time_elasticity.csv: ../../nyc_baseline_data_NTA/output/nyc_NTA_2010_time_elasticity.csv | ../input
	ln -sf $< $@
../input/primitives_nyc_NTA_2010_time.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc_NTA_2010_time.jld2 | ../input
	ln -sf $< $@
../input/amazon_%.csv: ../../Amazon_counterfactual_compute/output/amazon_%.csv | ../input
	ln -sf $< $@

