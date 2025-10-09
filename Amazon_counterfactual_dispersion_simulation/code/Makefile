SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_simulation = $(shell seq 1 1 10)
OUTPUTS = $(addprefix ../output/, \
	$(foreach s, $(set_simulation), simulation$(s).jld2) \
	simulation_dest.csv simulation_orig.csv \
	simulation_100k_distribution_orig.csv simulation_100k_distribution_dest.csv)

## RECIPES
all: $(OUTPUTS)
include ../../generic.make

## Output Recipes
../output/simulation%.jld2: simulation.jl $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' simulation.jl)| $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*
../output/simulation_dest.csv ../output/simulation_orig.csv: sum_by_simulation_count.jl $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' sum_by_simulation_count.jl) $(foreach s, $(set_simulation), ../output/simulation$(s).jld2) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $<
../output/simulation_100k_distribution_orig.csv ../output/simulation_100k_distribution_dest.csv: simulation_100k_stats.jl  $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' simulation_100k_stats.jl) $(foreach s, $(set_simulation), ../output/simulation$(s).jld2) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $<

# Input Recipes
../input/finitemodel_programs.jl: ../../finitemodel_solver/code/finitemodel_programs.jl | ../input
	ln -sf $< $@
../input/nyc2010_time_elasticity.csv : ../input/%.csv: ../../nyc_baseline_data/output/%.csv | ../input
	ln -sf $< $@
../input/primitives_nyc2010_time.jld2: ../input/%.jld2: ../../nyc_baseline_calibrate/output/%.jld2 | ../input
	ln -sf $< $@
../input/amazon_%.csv: ../../Amazon_counterfactual_compute/output/amazon_%.csv| ../input
	ln -sf $< $@
../input/baseline_equilibrium%: ../../nyc_baseline_compute/output/baseline_equilibrium% | ../input
	ln -sf $< $@
