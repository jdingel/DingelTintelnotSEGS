SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sims = $(shell seq 1 1 100)
INPUTS = $(foreach sim, $(set_sims), $(foreach file,bilat_predicted_time orig_time dest_time wage lodes_wzeros lodes_wzero_wdelta,../input/nyc2010_$(file)_puncertainty_$(sim).dta ) ../input/nyc2010_time_elasticity_puncertainty_$(sim).csv) 
OUTPUTS = $(foreach sim, $(set_sims), ../output/primitives_nyc2010_time_puncertainty_$(sim).jld2)
REPORTS = $(foreach sim, 1 2 3, ../report/primitives_nyc2010_time_puncertainty_$(sim).jld2.log)

all: $(OUTPUTS) $(REPORTS)
report: $(REPORTS)
include ../../generic.make
.NOTPARALLEL:
#OUTPUT RECIPES
$(OUTPUTS): ../output/primitives_nyc2010_time_puncertainty_%.jld2: ../input/calibrate_main.jl ../input/describe_data.jl ../input/calibrate_function.jl ../input/nyc2010_time_elasticity_puncertainty_%.csv ../input/nyc2010_orig_time_puncertainty_%.dta ../input/nyc2010_dest_time_puncertainty_%.dta ../input/nyc2010_lodes_wzero_wdelta_puncertainty_%.dta | $(JULIA_OOPR) $(OOPR)
	$(JULIA) --no-job-name $< $@ 4.0 ../input/nyc2010_time_elasticity_puncertainty_$*.csv ../input/nyc2010_orig_time_puncertainty_$*.dta ../input/nyc2010_dest_time_puncertainty_$*.dta ../input/nyc2010_lodes_wzero_wdelta_puncertainty_$*.dta


#INPUT RECIPES
../input/calibrate_main.jl ../input/calibrate_function.jl: ../input/%.jl: ../../nyc_baseline_calibrate/code/%.jl | ../input
	ln -sf $< $@

#DATA INPUT RECIPES
$(INPUTS) : ../input/%: ../../Amazon_puncertainty_gravity/output/% | ../input
	ln -sf $< $@


