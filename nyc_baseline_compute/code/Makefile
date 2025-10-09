SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
sigma_list = 1.1 4.0 Inf
eta_list = 0.001 0.0028 0.1
ife_rank = 1 2 3
set_nests = ntaorigin_0.75 workplace_0.75 ntaorigin_0.25 workplace_0.5 residence_0.75 residence_0.5

INPUTS_primitives = $(foreach stub, nyc2010_time nyc2010_dist nyc_pool_2008_2010_time, ../input/primitives_$(stub).jld2) \
					$(foreach stub, nyc_NTA_2010_time nyc_NTA_2010_time_harmonic nyc_NTA_2010_time_weighted, ../input/primitives_$(stub).jld2) \
					$(foreach eta, $(eta_list), ../input/primitives_nyc2010_time_eta_$(eta).jld2) \
					$(foreach sigma, $(sigma_list), ../input/primitives_nyc2010_time_sigma_$(sigma).jld2) \
					$(foreach nest, $(set_nests), ../input/primitives_nyc2010_time_$(nest).jld2)

INPUTS_cont = ../input/primitives_nyc2010_time.jld2
INPUTS_nta = ../input/primitives_nyc_NTA_2010_time.jld2
INPUTS_dist = ../input/primitives_nyc2010_dist.jld2
INPUTS_pool_2008_2010 = ../input/primitives_nyc_pool_2008_2010_time.jld2

OUTPUTS_cont = ../output/baseline_equilibrium_outcomes.jld2
OUTPUTS_ext = $(addprefix ../output/baseline_equilibrium_outcomes_, dist.jld2 pool_2008_2010.jld2 nta.jld2)
OUTPUTS_varsigma = $(foreach sigma, $(sigma_list), ../output/baseline_equilibrium_outcomes_sigma_$(sigma).jld2) 
OUTPUTS_local_inc_returns = $(foreach eta, $(eta_list), ../output/baseline_equilibrium_outcomes_eta_$(eta).jld2) 
OUTPUTS_nested = $(foreach stub, $(set_nests), ../output/baseline_equilibrium_outcomes_$(stub).jld2) 
OUTPUTS_ife = $(foreach rank, $(ife_rank), ../output/baseline_equilibrium_outcomes_ife_$(rank).jld2)

OUTPUTS = $(OUTPUTS_cont) $(OUTPUTS_ext) $(OUTPUTS_varsigma) $(OUTPUTS_local_inc_returns) $(OUTPUTS_nested) $(OUTPUTS_ife)
REPORTS = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(OUTPUTS)))

all: $(OUTPUTS) $(REPORTS)
reports: $(REPORTS)

include ../../generic.make

.NOTPARALLEL:
## OUTPUT RECIPES
../output/baseline_equilibrium_outcomes.jld2: baseline_compute.jl $(INPUTS_cont) $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' baseline_compute.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $@ $(INPUTS_cont)

../output/baseline_equilibrium_outcomes_sigma_%.jld2: baseline_compute_var_sigma.jl ../input/primitives_nyc2010_time_sigma_%.jld2 $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' baseline_compute_var_sigma.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $* ../input/primitives_nyc2010_time_sigma_$*.jld2

../output/baseline_equilibrium_outcomes_eta_%.jld2: baseline_compute_local_inc_returns.jl $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' baseline_compute_local_inc_returns.jl | grep -v 'toml') ../input/primitives_nyc2010_time_eta_%.jld2 | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $* ../input/primitives_nyc2010_time_eta_$*.jld2

$(OUTPUTS_nested): ../output/baseline_equilibrium_outcomes_%.jld2: baseline_compute_nested.jl ../input/primitives_nyc2010_time_%.jld2 $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' baseline_compute_nested.jl | grep -v 'toml') |$(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $(shell echo $* | grep -Eo '[a-z0-9.]+') ../input/primitives_nyc2010_time_$*.jld2

.SECONDEXPANSION:
$(OUTPUTS_ext): ../output/baseline_equilibrium_outcomes_%.jld2: baseline_compute.jl $$(INPUTS_$$*) $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z]*' baseline_compute.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $@ $(INPUTS_$*)

../output/baseline_equilibrium_outcomes_ife_%.jld2: baseline_compute_factor.jl ../input/primitives_nyc2010_time_ife_%.jld2 $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' baseline_compute_factor.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $@ ../input/primitives_nyc2010_time_ife_$*.jld2

## INPUT Recipes
$(INPUTS_primitives) : ../input/%: ../../nyc_baseline_calibrate/output/% | ../input
	ln -sf $< $@

../input/primitives_nyc2010_time_ife_%.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time_ife_%.jld2 | ../input
	ln -sf $< $@
