SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_zeta = 0.25
set_simulation = $(shell seq 1 1 100)

INPUTS = $(foreach zeta, $(set_zeta), $(foreach simulation, $(set_simulation), ../input/simulation_fixednu_$(zeta)_$(simulation)_nested.jld2))
OUTPUTS = $(addprefix ../output/simulation_distribution_, orig_nested.csv dest_nested.csv)
												

all: $(OUTPUTS)
include ../../generic.make


## OUTPUT RECIPES
$(addprefix ../output/simulation_distribution_, orig_nested.csv dest_nested.csv): simulation_sumstats_nested.jl $(INPUTS) $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' simulation_sumstats_nested.jl) | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< $*

## INPUT RECIPE
../input/simulation_fixednu_0.25_%_nested.jld2: ../../Amazon_fixednu_simulate_nested/output/simulation_fixednu_0.25_%_nested.jld2 | ../input
	ln -sf $< $@
