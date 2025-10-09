SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_simulation = $(shell seq 1 1 100)
set_sigma = 4.0 Inf
OUTPUTS = $(foreach sigma, $(set_sigma), $(addprefix ../output/simulation_distribution_, orig_sigma_$(sigma).csv dest_sigma_$(sigma).csv) $(addprefix ../output/AHQ2_d_emp_, p5_sigma_$(sigma).tex p95_sigma_$(sigma).tex))

INPUTS = $(foreach sigma, $(set_sigma), $(foreach simulation, $(set_simulation), \
		../input/simulation_fixednu_$(sigma)_$(simulation).jld2))

.INTERMEDIATE: $(foreach sigma, $(set_sigma), ../temp/emp_b_avg_ratio_d_realw_sigma_$(sigma).csv)

all: $(OUTPUTS)
include ../../generic.make

## OUTPUT RECIPES
../output/AHQ2_d_emp_p5_sigma_%.tex: ../output/simulation_distribution_dest_sigma_%.csv #Assumes AHQ2 is tract 1381; first three columns are "id,d_emp_p95,d_emp_p5"
	grep '^1381,' $< | cut -d , -f 3 | awk '{print int($$1+0.5)}' | sed 's/\([0-9]\)\([0-9]\{3\}\)$$/\1,\2/' | tr -d '\n' > $@
../output/AHQ2_d_emp_p95_sigma_%.tex: ../output/simulation_distribution_dest_sigma_%.csv
	grep '^1381,' $< | cut -d , -f 2 | awk '{print int($$1+0.5)}' | sed 's/\([0-9]\)\([0-9]\{3\}\)$$/\1,\2/' | tr -d '\n' > $@
$(addprefix ../output/simulation_distribution_, orig_sigma_%.csv dest_sigma_%.csv): simulation_sumstats.jl $(foreach simulation, $(set_simulation), ../input/simulation_fixednu_%_$(simulation).jld2) $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' simulation_sumstats.jl) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

## INPUT RECIPES
../input/simulation_fixednu%.jld2: ../../Amazon_fixednu_simulate/output/simulation_fixednu%.jld2 | ../input
	ln -sf $< $@

