SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_Lambda := 0.1 0.25 0.5 1
set_shock := 1.09 
set_event = $(shell seq 1 1 100)
OUTPUTS = $(foreach shock, $(set_shock), $(foreach event, 1 2, $(foreach var, ell w r, \
	../output/DGP_continuum_0_$(shock)_$(event)_$(var).csv))) \
	$(foreach Lambda, $(set_Lambda), \
	$(foreach shock, $(set_shock), $(foreach event, $(set_event), $(foreach var, ell w r, \
	../output/DGP_continuum_$(Lambda)_$(shock)_$(event)_$(var).csv))))

REPORTS = 	$(foreach shock, $(set_shock), $(foreach event, 1 2, $(foreach var, ell w r, \
	../report/DGP_continuum_0_$(shock)_$(event)_$(var).csv.log))) \
	$(foreach Lambda, $(set_Lambda), \
	$(foreach shock, $(set_shock), $(foreach event, 1 2, $(foreach var, ell w r, \
	../report/DGP_continuum_$(Lambda)_$(shock)_$(event)_$(var).csv.log)))) \

## RECIPES
all: $(OUTPUTS) $(REPORTS)
reports: $(REPORTS)
include ../../generic.make

## OUTPUTS
$(addprefix ../output/DGP_continuum_, %_ell.csv %_w.csv %_r.csv): continuum_outcomes.jl \
	$(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' continuum_outcomes.jl) | $(OOPR) $(JULIA_OOPR)
	$(eval args := $(shell echo $@ | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(JULIA) $< $(args)

## INPUTS
../input/nyc2010_time_elasticity.csv: ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
../input/primitives_nyc2010_time.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time.jld2 | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.csv: ../../monte_carlo_iid_dgp/output/nyc2010_lodes_wzero_wdelta.csv | ../input 
	ln -sf $< $@
../input/employment_gap_fn.jl ../input/hat_P.jl: ../input/%: ../../common_scripts/code/% | ../input
	ln -sf $< $@
../input/baseline_equilibrium_solver.jl: ../../nyc_baseline_compute/code/baseline_equilibrium_solver.jl | ../input
	ln -sf $< $@
../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@