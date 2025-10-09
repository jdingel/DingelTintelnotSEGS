SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_simulation = $(shell seq 1 1 100)
OUTPUTS = $(addprefix ../output/simulation_distribution_, orig_NTA.csv dest_NTA.csv)
INPUTS = $(foreach simulation, $(set_simulation), ../input/simulation_fixednu_NTA_s$(simulation).jld2)

all: $(OUTPUTS)
include ../../generic.make

## OUTPUT RECIPES
$(addprefix ../output/simulation_distribution_, orig_NTA.csv dest_NTA.csv): simulation_sumstats_NTA.jl $(INPUTS) $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' simulation_sumstats_NTA.jl) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

## INPUT RECIPES
../input/simulation_fixednu_NTA_s%.jld2: ../../Amazon_fixednu_simulate_NTA/output/simulation_fixednu_NTA_s%.jld2 | ../input
	ln -sf $< $@

