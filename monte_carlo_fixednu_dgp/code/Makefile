SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_shock := 1.09
set_event = $(shell seq 1 1 100)
set_block = $(shell seq 1 1 50)

OUTPUTS_fixednu = $(foreach shock, $(set_shock), ../temp/mean_util_$(shock)_fixednu.csv \
		$(foreach event, $(set_event), ../output/DGP_$(shock)_$(event)_fixednu.csv))
OUTPUTS_labor_allocation = $(foreach shock, $(set_shock), \
                $(foreach event, $(set_event), ../output/DGP_$(shock)_$(event)_fixednu.csv))

.SECONDARY: $(foreach shock, $(set_shock), $(foreach event, $(set_event), $(foreach block, $(set_block), \
		../temp/choices_$(shock)_$(event)_b$(block)_fixednu.csv)))

.INTERMEDIATE: $(foreach shock, $(set_shock), \
	$(foreach event, $(set_event), ../temp/DGP_$(event)_fixednu_$(shock).csv) \
	../temp/mean_util_$(shock)_fixednu.csv)

all: $(OUTPUTS_fixednu) $(OUTPUTS_labor_allocation)
include ../../generic.make

# OUTPUTS
# Tract-pair mean utility given productivity shock
../temp/mean_util_%_fixednu.csv: compute_pre_and_post_mean_util.jl $(shell grep -o '../input/[A-Za-z0-9_]*\.[a-z2]*' compute_pre_and_post_mean_util.jl) | $(OOPR) $(JULIA_OOPR)
	$(eval arg := $(shell echo $@ | grep -Eo '[+-]?[0-9]+([.][0-9]+)'))
	$(JULIA) $< $(arg)
define run_choice_simulation
../temp/choices_$(shock)_$(event)_b$(block)_fixednu.csv: simulate_choices.jl ../temp/mean_util_$(shock)_fixednu.csv | $(OOPR) $(JULIA_OOPR)
	$$(JULIA) $$< $(shock) $(event) $(block)
endef
$(foreach shock, $(set_shock), \
	$(foreach event, $(set_event), \
		$(foreach block, $(set_block), $(eval $(run_choice_simulation)))))

# Aggregate individuals' choices into labor allocation
../output/DGP_%_fixednu.csv : collect_choices_bysim.do $(foreach block, $(set_block), ../temp/choices_%_b$(block)_fixednu.csv) $(foreach shock, $(set_shock), ../temp/mean_util_$(shock)_fixednu.csv) | $(STATA_OOPR)
	$(eval args := $(shell echo $* | sed 's/_/ /g'))
	$(STATA) $< $(args)


# INPUTS
../input/nyc2010_time_elasticity.csv: ../../nyc_baseline_data/output/nyc2010_time_elasticity.csv | ../input
	ln -sf $< $@
../input/primitives_nyc2010_time.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time.jld2 | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../input/%.dta: ../../nyc_baseline_data/output/%.dta | ../input
	ln -sf $< $@
../input/shock_tract.jl: ../input/%.jl: ../../common_scripts/code/%.jl | ../input
	ln -sf $< $@
../input/continuum_iterate_programs.jl: ../input/%.jl: ../../continuum_equilibrium_solver/code/%.jl | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.csv: ../../monte_carlo_iid_dgp/output/nyc2010_lodes_wzero_wdelta.csv | ../input 
	ln -sf $< $@
../input/baseline_equilibrium_solver.jl: ../../nyc_baseline_compute/code/baseline_equilibrium_solver.jl | ../input
	ln -sf $< $@
