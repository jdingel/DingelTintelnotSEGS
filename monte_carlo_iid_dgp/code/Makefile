SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_Lambda := 0 0.1 0.25 0.5 1 
set_pop := 2.488905 5 12.5 25 50 125 250 2560
set_shock := 1.09 
set_event = $(shell seq 1 1 100)
set_triplet = $(foreach pop, $(set_pop), $(foreach shock, $(set_shock), $(foreach event, $(set_event),$(pop)_$(shock)_$(event))))

# set Λ = 0, Â = 1.00
OUTPUTS_NO_SHOCK = $(foreach event, $(shell seq 1 1 100), ../output/DGP_0_2.488905_1.00_$(event).csv)

.INTERMEDIATE: ../temp/nyc2010_lodes_wzero_wdelta.csv

## RECIPES
all: $(foreach Lambda, $(set_Lambda), $(foreach triplet, $(set_triplet), ../output/DGP_$(Lambda)_$(triplet).csv)) \
	../output/nyc2010_lodes_wzero_wdelta.csv
outputs_no_shock: $(OUTPUTS_NO_SHOCK)
include ../../generic.make

## OUTPUT
../output/DGP_%.csv: DGP.jl $(shell grep -o '../[inputem]*/[A-Za-z_0-9]*\.[a-z_0-9]*' DGP.jl) | $(OOPR) $(JULIA_OOPR)
	$(eval fourargs := $(shell echo $@ | sed 's/\.jld2//g' | grep -Eo '[+-]?[0-9]+(\.[0-9]+)?'))
	$(JULIA) $< $(fourargs)
../output/nyc2010_lodes_wzero_wdelta.csv: ../temp/nyc2010_lodes_wzero_wdelta.csv | $(OOPR)
	cp -p $< $@

## TEMP
../temp/nyc2010_lodes_wzero_wdelta.csv: data_prep.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' data_prep.do) | $(STATA_OOPR)
	$(STATA) $< 

## INPUT
../input/nyc2010_time_elasticity.csv: ../../nyc_baseline_data/output/nyc2010_time_elasticity.csv | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../../nyc_baseline_data/output/nyc2010_lodes_wzero_wdelta.dta | ../input
	ln -sf $< $@
../input/primitives_nyc2010_time.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time.jld2 | ../input
	ln -sf $< $@
../input/finitemodel_programs.jl: ../../finitemodel_solver/code/finitemodel_programs.jl | ../input
	ln -sf $< $@
../input/gravity_saveFE_time.do: ../../common_scripts/code/gravity_saveFE_time.do | ../input
	ln -sf $< $@
../input/baseline_equilibrium_solver.jl: ../../nyc_baseline_compute/code/baseline_equilibrium_solver.jl | ../input
	ln -sf $< $@