SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
simulation_set := $(shell seq 1 1 10)
block_set := $(shell seq 1 1 100)

TEMP = $(foreach s, $(simulation_set), $(foreach b, $(block_set), ../temp/individuals_choices_s$(s)_b$(b).csv)) \
	$(foreach s, $(simulation_set), ../temp/realized_commuting_flows_s$(s).dta) \
	$(foreach s, $(simulation_set), $(foreach b, $(block_set), ../temp/expost_individuals_choices_s$(s)_b$(b).csv)) 

OUTPUTS = $(addprefix ../output/, dispersion_expost_wage.csv dispersion_expost_rent.csv expost_results.tex text_expost_regret.tex text_intro_expost_regret.tex)

all: $(OUTPUTS)
include ../../generic.make

## OUTPUT
../output/expost_results.tex ../output/text_expost_regret.tex ../output/text_intro_expost_regret.tex: calculate_regret_magnitude.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' calculate_regret_magnitude.do) $(foreach s, $(simulation_set), $(foreach b, $(block_set), ../temp/expost_individuals_choices_s$(s)_b$(b).csv)) | $(STATA_OOPR)
	$(STATA) $<
../output/dispersion_expost_wage.csv ../output/dispersion_expost_rent.csv: expost_dispersion.jl $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' expost_dispersion.jl) $(foreach s, $(simulation_set), ../temp/realized_commuting_flows_s$(s).dta) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $<

## TEMP
.PRECIOUS: $(TEMP)
../temp/realized_commuting_flows_s%.dta: aggregate_choices.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' aggregate_choices.do) $(foreach b, $(block_set), ../temp/individuals_choices_s%_b$(b).csv) | $(STATA_OOPR)
	$(STATA) $< $*

../temp/individuals_choices_s%.csv: simulate_individuals_choices.jl calculate_util.jl $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' simulate_individuals_choices.jl) | $(OOPR) $(JULIA_OOPR)
	$(eval twoargs := $(shell echo $@ | sed -e 's/[^0-9]/ /g' -e 's/^ *//g' | tr -s ' ')) 
	$(JULIA) $< $(twoargs)

.SECONDEXPANSION:
../temp/expost_individuals_choices_s%.csv: find_individuals_expost_optimal_choices.jl $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' find_individuals_expost_optimal_choices.jl) calculate_util.jl ../temp/individuals_choices_s%.csv  ../temp/realized_commuting_flows_s$$(firstword $$(subst _, , $$*)).dta | $(OOPR) $(JULIA_OOPR)
	$(eval twoargs := $(shell echo $* | sed 's/[a-zA-Z_]/ /g' | tr -s ' ')) 
	$(JULIA) $< $(twoargs)

## INPUT
../input/nyc2010_time_elasticity.csv: ../../nyc_baseline_data/output/nyc2010_time_elasticity.csv | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../../nyc_baseline_data/output/nyc2010_lodes_wzero_wdelta.dta | ../input
	ln -sf $< $@
../input/primitives_nyc2010_time.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time.jld2 | ../input
	ln -sf $< $@
../input/finitemodel_programs.jl: ../../finitemodel_solver/code/finitemodel_programs.jl | ../input
	ln -sf $< $@
../input/baseline%: ../../nyc_baseline_compute/output/baseline% | ../input
	ln -sf $< $@
