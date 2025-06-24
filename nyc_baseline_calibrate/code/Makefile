SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sigma = 4.0 1.1 Inf
ife_rank = 1 2 3
set_stats = rent wage productivity landendowment

INPUTS_2010 = $(foreach file, orig_time dest_time lodes_wzero_wdelta, ../input/nyc2010_$(file).dta) ../input/nyc2010_time_elasticity.csv
INPUTS_IFE = $(addprefix rank $(ife_rank), ../input/nyc2010_time_elasticity_ife_$(rank).csv)

OUTPUTS_baseline = ../output/primitives_nyc2010_time.jld2
OUTPUTS_2010_sigmas = $(foreach sigma, $(set_sigma), ../output/primitives_nyc2010_time_sigma_$(sigma).jld2) 
OUTPUTS_IFE = $(foreach rank, $(ife_rank), ../output/primitives_nyc2010_time_ife_$(rank).jld2) 

OUTPUTS = $(OUTPUTS_baseline) $(OUTPUTS_2010_sigmas) \

## REPORT
REPORT = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(OUTPUTS)))
REPORT_IFE = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(OUTPUTS_IFE)))

all: $(OUTPUTS) $(REPORT) $(OUTPUTS_IFE) $(REPORT_IFE)
reports: $(REPORT) $(REPORT_IFE)
include ../../generic.make

# OUTPUT RECIPES
.NOTPARALLEL:
../output/primitives_nyc2010_time.jld2: ../output/primitives_nyc2010_time_sigma_4.0.jld2 | $(OOPR)
	cp -p $< $@

$(OUTPUTS_IFE): ../output/primitives_nyc2010_time_ife_%.jld2: calibrate_main.jl calibrate_function.jl ../input/nyc2010_time_elasticity_ife_%.csv ../input/nyc2010_orig_time_ife_%.dta ../input/nyc2010_dest_time_ife_%.dta ../input/nyc2010_lodes_wzero_wdelta.dta ../input/nyc2010_lambda_ife_%.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $@ 4.0 $(addprefix ../input/, nyc2010_time_elasticity_ife_$*.csv nyc2010_orig_time_ife_$*.dta nyc2010_dest_time_ife_$*.dta nyc2010_lodes_wzero_wdelta.dta nyc2010_lambda_ife_$*.dta )

$(OUTPUTS_2010_sigmas): ../output/primitives_nyc2010_time_sigma_%.jld2: calibrate_main.jl $(INPUTS_2010) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $@ $* $(addprefix ../input/, /nyc2010_time_elasticity.csv nyc2010_orig_time.dta nyc2010_dest_time.dta nyc2010_lodes_wzero_wdelta.dta)

# INPUT RECIPES

$(INPUTS_2010) : ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
../input/nyc2010_time_elasticity_ife_%.csv: ../../interactive_fe_estimation/output/beta_%.csv | ../input
	ln -sf $< $@
../input/nyc2010_orig_time_ife_%.dta: ../../interactive_fe_reformat/output/nyc2010_orig_time_ife_%.dta | ../input
	ln -sf $< $@
../input/nyc2010_dest_time_ife_%.dta: ../../interactive_fe_reformat/output/nyc2010_dest_time_ife_%.dta | ../input
	ln -sf $< $@
../input/nyc2010_lambda_ife_%.dta: ../../interactive_fe_reformat/output/nyc2010_lambda_ife_%.dta | ../input
	ln -sf $< $@