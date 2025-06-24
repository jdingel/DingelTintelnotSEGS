SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_simulation = $(shell seq 1 1 100)
set_reports = $(shell seq 1 1 3)
OUTPUTS = $(foreach sim, $(set_simulation), $(foreach outcome, emp res rent wage, \
		../output/cont_$(outcome)_puncertainty_$(sim).csv))
REPORTS = $(foreach sim, $(set_reports), $(foreach outcome, emp res rent wage, \
		../report/cont_$(outcome)_puncertainty_$(sim).csv.log))
INPUTS = $(foreach sim, $(set_simulation), $(foreach file, orig_time dest_time lodes_wzero_wdelta, ../input/nyc2010_$(file)_puncertainty_$(sim).dta ) ../input/nyc2010_time_elasticity_puncertainty_$(sim).csv) 
INPUTS_prim = $(foreach sim, $(set_simulation), ../input/primitives_nyc2010_time_puncertainty_$(sim).jld2)

## RECIPES
all: $(OUTPUTS) $(REPORTS)
reports: $(REPORTS)
include ../../generic.make

## OUTPUTS
.SECONDEXPANSION:
../output/cont_emp_puncertainty_%.csv ../output/cont_res_puncertainty_%.csv ../output/cont_rent_puncertainty_%.csv ../output/cont_wage_puncertainty_%.csv: compute_cont_counterfactual.jl $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' compute_cont_counterfactual.jl) $(foreach file, orig_time dest_time lodes_wzero_wdelta, ../input/nyc2010_$(file)_puncertainty_$$*.dta) ../input/nyc2010_time_elasticity_puncertainty_%.csv ../input/primitives_nyc2010_time_puncertainty_%.jld2| $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

## INPUTS
../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@
../input/employment_gap_fn.jl: ../input/%.jl: ../../common_scripts/code/%.jl | ../input
	ln -sf $< $@
../input/baseline_equilibrium_solver.jl: ../../nyc_baseline_compute/code/baseline_equilibrium_solver.jl | ../input
	ln -sf $< $@
$(INPUTS): ../input/%: ../../Amazon_puncertainty_gravity/output/% | ../input
	ln -sf $< $@
$(INPUTS_prim): ../input/%: ../../Amazon_puncertainty_calibrate/output/% | ../input
	ln -sf $< $@

