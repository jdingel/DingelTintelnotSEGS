SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_simulation = $(shell seq 1 1 100)
set_block = $(shell seq 1 1 50)
set_sigma = 4.0 1.1 Inf

OUTPUTS = $(foreach sigma, $(set_sigma), $(foreach simulation, $(set_simulation), \
		../output/finite_labor_allocation_$(sigma)_$(simulation).csv.zip \
		../output/simulation_fixednu_$(sigma)_$(simulation).jld2))
REPORTS = $(foreach sigma, $(set_sigma), $(foreach simulation,1 2 3 4 5, ../report/granular_$(sigma)_$(simulation)_1.csv.log))

all: $(OUTPUTS) $(REPORTS)
reports: $(REPORTS)
include ../../generic.make

## OUTPUT RECIPES
.SECONDEXPANSION:
../output/simulation_fixednu_%.jld2: finitemodel_simulation.jl ../temp/finite_labor_allocation_%.csv $(shell grep -o '../input/[A-Za-z0-9_]*\.[A-Za-z0-9]*' finitemodel_simulation.jl)  ../input/model_cbm_sigma_$$(shell echo $$* | cut -d '_' -f1).jld2 ../input/amazon_ctfl_tract_cbm_sigma_$$(shell echo $$* | cut -d '_' -f1)_shock.csv ../input/primitives_nyc2010_time_sigma_$$(shell echo $$* | cut -d '_' -f1).jld2 | $(OOPR) $(JULIA_OOPR)
	$(eval args := $(shell echo $* | sed 's/_/ /g'))
	$(JULIA) $< $(args)
../output/finite_labor_allocation_%.csv.zip: ../temp/finite_labor_allocation_%.csv | $(OOPR)
	zip $@ $< -j 

## TEMP RECIPES
../temp/amazon_ctfl_tract_cbm_%_meanutil.csv: compute_meanutil.jl ../input/primitives_nyc2010_time_%.jld2 ../input/model_cbm_%.jld2 $(foreach input, rent wage shock, ../input/amazon_ctfl_tract_cbm_%_$(input).csv) ../input/baseline_equilibrium_outcomes_%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $^ $@
.SECONDEXPANSION:
../temp/temp_%.csv ../temp/finite_labor_allocation_%.csv: finitemodel_collect_choices.do $(foreach block, $(set_block), ../temp/granular_%_$(block).csv)  ../temp/amazon_ctfl_tract_cbm_sigma_$$(firstword $$(subst _, ,$$*))_meanutil.csv | $(STATA_OOPR)
	$(eval args := $(shell echo $* | sed 's/_/ /g'))
	$(STATA) $< $(args)
.SECONDEXPANSION:
../temp/granular_%.csv: finitemodel_simulate_choices.jl $(shell grep -o '../input/[A-Za-z0-9_.]*\.[a-z]*' finitemodel_simulate_choices.jl | grep -v '\.toml') ../temp/amazon_ctfl_tract_cbm_sigma_$$(shell echo $$* | cut -d '_' -f1)_meanutil.csv | $(OOPR) $(JULIA_OOPR)
	$(eval twoargs := $(shell echo $* | sed 's/_/ /g'))
	$(JULIA) $< $(twoargs)

## TEMP REPORT RECIPE
../report/granular_%.csv.log: ../temp/granular_%.csv | ../report
ifneq ($(shell command -v md5),)
	cat <(md5 $<) <(echo -n 'Lines:') <(cat $< | wc -l) <(head -3 $<) <(echo '...') <(tail -2 $<) > $@
else
	cat <(md5sum $<) <(echo -n 'Lines:') <(cat $< | wc -l) <(head -3 $<) <(echo '...') <(tail -2 $<) > $@
endif

## INPUT RECIPES
../input/model_cbm_sigma_%.jld2: ../../baseline_models_foreha/output/model_cbm_sigma_%.jld2 | ../input
	ln -sf $< $@
../input/finitemodel_programs.jl: ../../finitemodel_solver/code/finitemodel_programs.jl | ../input
	ln -sf $< $@
../input/amazon_%.csv: ../../Amazon_counterfactual_compute/output/amazon_%.csv | ../input 
	ln -sf $< $@
../input/primitives_nyc2010_time_sigma_%.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time_sigma_%.jld2 | ../input
	ln -sf $< $@
../input/baseline_equilibrium_outcomes_%.jld2: ../../nyc_baseline_compute/output/baseline_equilibrium_outcomes_%.jld2 | ../input
	ln -sf $< $@