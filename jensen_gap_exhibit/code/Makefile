SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sigma = 4.0 1.1 Inf
set_sim = $(shell seq 1 100)
INPUTS_jensen_simulation = $(foreach sim, $(set_sim), $(foreach sigma, $(set_sigma), ../input/jensen_simulation_sigma_$(sigma)_simulation_$(sim).jld2))
OUTPUTS_scatter = $(foreach sigma, $(set_sigma), ../output/jensen_wage_comparison_sigma_$(sigma).eps ../output/jensen_rent_comparison_sigma_$(sigma).eps)
OUTPUTS_print = $(foreach sigma, $(set_sigma), $(foreach var, wage rent, ../output/dev_CCRE_$(var)_p50_sigma_$(sigma).tex ../output/dev_CCRE_$(var)_p95_sigma_$(sigma).tex))
OUTPUTS_density = ../output/wage_deviation_density.eps ../output/wage_deviation_density_winsorized.eps
## RECIPES
all: $(OUTPUTS_scatter) $(OUTPUTS_print) $(OUTPUTS_density)
include ../../generic.make

## OUTPUTS
../output/jensen_wage_comparison_sigma_%.eps ../output/dev_CCRE_wage_p95_sigma_%.tex ../output/dev_CCRE_wage_p50_sigma_%.tex: jensen_simulation_wage_comparison.do  ../temp/jensen_simulation_compiled_w_sigma_%.csv | $(STATA_OOPR)
	$(STATA) $< $*
../output/jensen_rent_comparison_sigma_%.eps ../output/dev_CCRE_rent_p95_sigma_%.tex ../output/dev_CCRE_rent_p50_sigma_%.tex: jensen_simulation_rent_comparison.do  ../temp/jensen_simulation_compiled_r_sigma_%.csv | $(STATA_OOPR)
	$(STATA) $< $*
../output/wage_deviation_density.eps ../output/wage_deviation_density_winsorized.eps: jensen_simulation_wage_density.do $(foreach sigma, 1.1 4.0, ../temp/jensen_simulation_compiled_w_sigma_$(sigma).csv)| $(STATA_OOPR)
	$(STATA) $< $*
	
## TEMP
../temp/jensen_simulation_compiled_w_sigma_%.csv ../temp/jensen_simulation_compiled_r_sigma_%.csv: compile_jensen.jl $(shell echo ../input/jensen_simulation_sigma_%_simulation_{1..100}.jld2) ../input/baseline_equilibrium_outcomes_sigma_%.jld2 ../input/primitives_nyc2010_time_sigma_%.jld2 | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< $*

## INPUTS
../input/primitives_nyc2010_time_sigma_%.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time_sigma_%.jld2 | ../input
	ln -sf $< $@
../input/baseline_equilibrium%: ../../nyc_baseline_compute/output/baseline_equilibrium% | ../input
	ln -sf $< $@
../input/jensen_simulation_sigma_%: ../../jensen_gap_simulate/output/jensen_simulation_sigma_% | ../input
	ln -sf $< $@
