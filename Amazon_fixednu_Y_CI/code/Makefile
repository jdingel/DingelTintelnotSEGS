SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_simulation = $(shell seq 1 1 100) 
all: ../output/AHQ2_fixednu_output_change_histogram.eps ../output/AHQ2_fixednu_output_change_CI.tex
include ../../generic.make

.INTERMEDIATE: $(foreach sim, $(set_simulation), ../temp/finite_labor_allocation_s$(sim).csv)
.SECONDARY: ../temp/AHQ2_Y_fixednu.csv $(foreach sim, $(set_simulation), ../temp/AHQ2_Y_fixednu_sim_$(sim).csv) ../temp
## OUTPUT RECIPES
../output/AHQ2_fixednu_output_change_histogram.eps ../output/AHQ2_fixednu_output_change_CI.tex: plot_Y_histogram.do ../temp/AHQ2_Y_fixednu.csv | $(STATA_OOPR)
	$(STATA) $<
## TEMP RECIPES
../temp/AHQ2_Y_fixednu.csv: $(foreach sim, $(set_simulation), ../temp/AHQ2_Y_fixednu_sim_$(sim).csv) | ../temp
	awk '(NR == 1) || (FNR > 1)' $(foreach sim, $(set_simulation), ../temp/AHQ2_Y_fixednu_sim_$(sim).csv) > $@
../temp/AHQ2_Y_fixednu_sim_%.csv: compute_Y_fixednu.jl ../input/primitives_nyc2010_time.jld2 ../input/simulation_fixednu_4.0_%.jld2 ../temp/finite_labor_allocation_s%.csv | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $* $@
../temp/finite_labor_allocation_s%.csv: ../input/finite_labor_allocation_4.0_%.csv.zip | ../temp
	unzip -p $< > $@
## INPUT RECIPES
../input/simulation_fixednu_4.0_%.jld2: ../../Amazon_fixednu_simulate/output/simulation_fixednu_4.0_%.jld2 | ../input
	ln -sf $< $@
../input/finite_labor_allocation_4.0_%.csv.zip: ../../Amazon_fixednu_simulate/output/finite_labor_allocation_4.0_%.csv.zip | ../input
	ln -sf $< $@
../input/primitives_nyc2010_time.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time.jld2 | ../input
	ln -sf $< $@


