SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sigma = 4.0 1.1 Inf
set_eta = 0.001 0.0028 0.1
ife_rank = 1 2 3
set_zeta = 0.125 0.25 0.5 0.75
set_nests = $(foreach zeta, $(set_zeta), residence_$(zeta) workplace_$(zeta) ntaorigin_$(zeta)) ntapair countypair

INPUTS_2010 = $(foreach file, orig_time dest_time lodes_wzero_wdelta, ../input/nyc2010_$(file).dta) ../input/nyc2010_time_elasticity.csv
INPUTS_2008 = $(foreach file, orig_time dest_time lodes_wzero_wdelta, ../input/nyc2008_$(file).dta) ../input/nyc2008_time_elasticity.csv
INPUTS_NTA = $(foreach file, dest_FE orig_FE lodes_wzero_wdelta, ../input/nyc_NTA_2010_$(file).dta) ../input/nyc_NTA_2010_time_elasticity.csv
INPUTS_DIST = $(foreach file, orig dest lodes_wzeros, ../input/nyc2010_$(file)_dist.dta) ../input/nyc2010_time_elasticity_dist.csv ../input/nyc2010_lodes_wzero_wdistdelta.dta 
INPUTS_2008_2010_pool = ../input/nyc_pool_2008_2010_time_elasticity.csv ../input/nyc_pool_2008_2010_orig_time.dta ../input/nyc_pool_2008_2010_dest_time.dta ../input/nyc_pool_2008_2010_lodes_wzero_wdelta.dta

INPUTS_nested = $(addprefix ../input/nyc2010_, $(foreach nest, ntapair countypair, \
	time_elasticity_$(nest).csv zeta_$(nest).csv orig_time_$(nest).dta dest_time_$(nest).dta)) \
	../input/nyc2010_census_tabulation.dta

OUTPUTS_baseline = ../output/primitives_nyc2010_time.jld2
OUTPUTS_NYC_2008 = ../output/primitives_nyc2008_time.jld2
OUTPUTS_2008_2010_pool = ../output/primitives_nyc_pool_2008_2010_time.jld2
OUTPUTS_2010_NTA = ../output/primitives_nyc_NTA_2010_time.jld2
OUTPUTS_2010_sigmas = $(foreach sigma, $(set_sigma), ../output/primitives_nyc2010_time_sigma_$(sigma).jld2) 
OUTPUTS_2010_etas = $(foreach eta, $(set_eta), ../output/primitives_nyc2010_time_eta_$(eta).jld2) 
OUTPUTS_2010_DIST = ../output/primitives_nyc2010_dist.jld2
OUTPUTS_NL = $(foreach nest, $(set_nests), ../output/primitives_nyc2010_time_$(nest).jld2)
OUTPUTS_IFE = $(foreach rank, $(ife_rank), ../output/primitives_nyc2010_time_ife_$(rank).jld2) 

OUTPUTS = $(OUTPUTS_baseline) $(OUTPUTS_2008_2010_pool) $(OUTPUTS_2010_NTA) $(OUTPUTS_2010_sigmas) \
	$(OUTPUTS_2010_etas) $(OUTPUTS_2010_DIST) $(OUTPUTS_NL) $(OUTPUTS_IFE) $(OUTPUTS_NYC_2008)

## REPORT
REPORT = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(OUTPUTS)))
REPORT_IFE = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(OUTPUTS_IFE)))

all: $(OUTPUTS) $(REPORT) $(REPORT_IFE)
reports: $(REPORT) $(REPORT_IFE)
include ../../generic.make

# OUTPUT RECIPES
.NOTPARALLEL:
../output/primitives_nyc2010_time.jld2: ../output/primitives_nyc2010_time_sigma_4.0.jld2 | $(OOPR)
	cp -p $< $@
../output/primitives_nyc_pool_2008_2010_time.jld2: calibrate_main.jl calibrate_function.jl ../input/nyc_pool_2008_2010_time_elasticity.csv ../input/nyc_pool_2008_2010_orig_time.dta ../input/nyc_pool_2008_2010_dest_time.dta ../input/nyc_pool_2008_2010_lodes_wzero_wdelta.dta | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< $@ 4.0 ../input/nyc_pool_2008_2010_time_elasticity.csv ../input/nyc_pool_2008_2010_orig_time.dta ../input/nyc_pool_2008_2010_dest_time.dta ../input/nyc_pool_2008_2010_lodes_wzero_wdelta.dta

$(OUTPUTS_NYC_2008): ../output/primitives_nyc%_time.jld2: calibrate_main.jl calibrate_function.jl ../input/nyc%_time_elasticity.csv ../input/nyc%_orig_time.dta ../input/nyc%_dest_time.dta ../input/nyc%_lodes_wzero_wdelta.dta | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< $@ 4.0 ../input/nyc$*_time_elasticity.csv ../input/nyc$*_orig_time.dta ../input/nyc$*_dest_time.dta ../input/nyc$*_lodes_wzero_wdelta.dta

../output/primitives_nyc2010_dist.jld2: calibrate_main.jl calibrate_function.jl ../input/nyc2010_time_elasticity_dist.csv ../input/nyc2010_orig_dist.dta ../input/nyc2010_dest_dist.dta ../input/nyc2010_lodes_wzero_wdistdelta.dta | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< $@ 4.0 ../input/nyc2010_time_elasticity_dist.csv ../input/nyc2010_orig_dist.dta ../input/nyc2010_dest_dist.dta ../input/nyc2010_lodes_wzero_wdistdelta.dta
	
../output/primitives_nyc_NTA_2010_time.jld2: ../output/primitives_nyc_%_time.jld2: calibrate_main.jl calibrate_function.jl $(INPUTS_NTA)| $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $@ 4.0 ../input/nyc_NTA_2010_time_elasticity.csv ../input/nyc_NTA_2010_orig_FE.dta ../input/nyc_NTA_2010_dest_FE.dta ../input/nyc_NTA_2010_lodes_wzero_wdelta.dta

$(OUTPUTS_NL): ../output/primitives_nyc2010_time_%.jld2: calibrate_nested.jl calibrate_function.jl $(INPUTS_2010) ../input/nyc2010_census_tabulation.dta $(INPUTS_nested) | $(OOPR) $(JULIA_OOPR)
	$(eval twoargs := $(shell echo $* | grep -Eo '[a-z0-9.]+'))
	$(JULIA) $< $(twoargs)

$(OUTPUTS_IFE): ../output/primitives_nyc2010_time_ife_%.jld2: calibrate_main.jl calibrate_function.jl ../input/nyc2010_time_elasticity_ife_%.csv ../input/nyc2010_orig_time_ife_%.dta ../input/nyc2010_dest_time_ife_%.dta ../input/nyc2010_lodes_wzero_wdelta.dta ../input/nyc2010_lambda_ife_%.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $@ 4.0 $(addprefix ../input/, nyc2010_time_elasticity_ife_$*.csv nyc2010_orig_time_ife_$*.dta nyc2010_dest_time_ife_$*.dta nyc2010_lodes_wzero_wdelta.dta nyc2010_lambda_ife_$*.dta )

$(OUTPUTS_2010_sigmas): ../output/primitives_nyc2010_time_sigma_%.jld2: calibrate_main.jl $(INPUTS_2010) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $@ $* $(addprefix ../input/, /nyc2010_time_elasticity.csv nyc2010_orig_time.dta nyc2010_dest_time.dta nyc2010_lodes_wzero_wdelta.dta)

$(OUTPUTS_2010_etas): ../output/primitives_nyc2010_time_eta_%.jld2: calibrate_main.jl $(INPUTS_2010) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $@ 4.0 $(addprefix ../input/, nyc2010_time_elasticity.csv nyc2010_orig_time.dta nyc2010_dest_time.dta nyc2010_lodes_wzero_wdelta.dta) $*

# INPUT RECIPES

$(INPUTS_2010) $(INPUTS_2008) $(INPUTS_2008_2010_pool): ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
$(INPUTS_nested): ../input/%: ../../nyc_baseline_data_nests/output/% | ../input
	ln -sf $< $@
../input/nyc2010_time_elasticity_ife_%.csv: ../../interactive_fe_estimation/output/beta_%.csv | ../input
	ln -sf $< $@
../input/nyc2010_orig_time_ife_%.dta: ../../interactive_fe_reformat/output/nyc2010_orig_time_ife_%.dta | ../input
	ln -sf $< $@
../input/nyc2010_dest_time_ife_%.dta: ../../interactive_fe_reformat/output/nyc2010_dest_time_ife_%.dta | ../input
	ln -sf $< $@
../input/nyc2010_lambda_ife_%.dta: ../../interactive_fe_reformat/output/nyc2010_lambda_ife_%.dta | ../input
	ln -sf $< $@
$(INPUTS_NTA): ../input/%: ../../nyc_baseline_data_NTA/output/% | ../input
	ln -sf $< $@
$(INPUTS_DIST): ../input/%: ../../distance_based_delta_baseline_data/output/% | ../input
	ln -sf $< $@
