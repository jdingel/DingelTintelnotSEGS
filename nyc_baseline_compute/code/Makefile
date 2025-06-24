SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
sigma_list = 1.1 4.0 Inf
ife_rank = 1 2 3

INPUTS_primitives = $(foreach stub, nyc2010_time, ../input/primitives_$(stub).jld2) \
					$(foreach sigma, $(sigma_list), ../input/primitives_nyc2010_time_sigma_$(sigma).jld2) \

OUTPUTS_varsigma = $(foreach sigma, $(sigma_list), ../output/baseline_equilibrium_outcomes_sigma_$(sigma).jld2) 
OUTPUTS_ife = $(foreach rank, $(ife_rank), ../output/baseline_equilibrium_outcomes_ife_$(rank).jld2)

OUTPUTS = $(OUTPUTS_varsigma) $(OUTPUTS_ife)
REPORTS = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(OUTPUTS)))

all: $(OUTPUTS) $(REPORTS)
reports: $(REPORTS)

include ../../generic.make

.NOTPARALLEL:
## OUTPUT Recipes
../output/baseline_equilibrium_outcomes_sigma_%.jld2: baseline_compute_var_sigma.jl ../input/primitives_nyc2010_time_sigma_%.jld2 $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' baseline_compute_var_sigma.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $* ../input/primitives_nyc2010_time_sigma_$*.jld2

../output/baseline_equilibrium_outcomes_ife_%.jld2: baseline_compute_factor.jl ../input/primitives_nyc2010_time_ife_%.jld2 $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' baseline_compute_factor.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $@ ../input/primitives_nyc2010_time_ife_$*.jld2

## INPUT Recipes
$(INPUTS_primitives) : ../input/%: ../../nyc_baseline_calibrate/output/% | ../input
	ln -sf $< $@

../input/primitives_nyc2010_time_ife_%.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time_ife_%.jld2 | ../input
	ln -sf $< $@ 
