SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sigma = 4.0 1.1 Inf
set_sim = $(shell seq 1 100)
OUTPUTS = $(foreach sim, $(set_sim), $(foreach sigma, $(set_sigma), ../output/jensen_simulation_sigma_$(sigma)_simulation_$(sim).jld2))
## RECIPES
all: $(OUTPUTS)
include ../../generic.make

## OUTPUTS
.SECONDEXPANSION:
../output/jensen_simulation_sigma_%.jld2: jensen_simulation.jl ../input/nyc2010_time_elasticity.csv \
		../input/baseline_equilibrium_outcomes_sigma_$$(firstword $$(subst _, , $$*)).jld2 \
		../input/primitives_nyc2010_time_sigma_$$(firstword $$(subst _, , $$*)).jld2 \
		$(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z]*' jensen_simulation.jl) | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< $(firstword $(subst _, , $*)) $(lastword $(subst _, , $*))

## INPUTS
../input/finitemodel_programs.jl: ../../finitemodel_solver/code/finitemodel_programs.jl | ../input
	ln -sf $< $@
../input/nyc2010_time_elasticity.csv: ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
../input/primitives_nyc2010_time_sigma_%.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time_sigma_%.jld2 | ../input
	ln -sf $< $@
../input/baseline_equilibrium_outcomes_sigma_%.jld2: ../../nyc_baseline_compute/output/baseline_equilibrium_outcomes_sigma_%.jld2 | ../input
	ln -sf $< $@
