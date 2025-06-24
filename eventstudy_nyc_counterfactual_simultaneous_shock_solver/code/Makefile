SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
svd_ranks := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 500 1000 1500 2143
ife_ranks = 1 2 3

## INPUT
CBM_MODEL = $(addprefix ../input/model_cbm_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf))
CSP_MODEL = $(addprefix ../input/model_csp_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf))
SVD_MODEL = $(foreach rank, $(svd_ranks), ../input/model_svd_$(rank).jld2)
IFE_MODEL = $(foreach rank, $(ife_ranks), ../input/model_ife_$(rank).jld2)

INPUTS_models = $(CBM_MODEL) $(CSP_MODEL) \
	$(SVD_MODEL) $(IFE_MODEL)

INPUTS_obs_changes = $(foreach stub, nyc_2012_2010, ../input/$(stub)_observed_changes_dest_tract.dta) \

INPUTS_data = $(addsuffix lodes_wzero_wdelta.dta, ../input/nyc2010_) \
	$(addprefix ../input/, nyc2012_lodes_wzeros.dta nyc2010_wage.dta nyc_avg_wage_2008_2010.dta)

## OUTPUT
CBM = $(addprefix ../output/simultaneous_shock_cbm_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf))
CSP = $(addprefix ../output/simultaneous_shock_csp_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf))
SVD = $(foreach rank, $(svd_ranks), ../output/simultaneous_shock_svd_$(rank).jld2)
IFE = $(foreach rank, $(ife_ranks), ../output/simultaneous_shock_ife_$(rank).jld2)

OUTPUTS_tract_csp = $(CSP)
OUTPUTS_tract_cbm = $(CBM)
OUTPUTS_tract_approx = $(SVD)

## REPORT
CBM_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CBM)))
CSP_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CSP)))
SVD_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(SVD)))
IFE_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(IFE)))

REPORTS = $(CBM_LOG) $(CSP_LOG) \
	$(SVD_LOG) $(IFE_LOG)

SHOCK_GUESS = $(addprefix ../temp/simultaneous_shock_, cbm.jld2 csp.jld2)

all: $(CBM) $(CSP) $(SVD) $(IFE)
report: $(REPORTS)

include ../../generic.make

# OUTPUT RECIPES
$(OUTPUTS_tract_approx): ../output/simultaneous_shock_%.jld2: find_shocks_tract.jl ../input/model_%.jld2 ../temp/simultaneous_shock_csp.jld2 $(shell grep -o '../[inputoem]*/[A-Za-z_0-9.]*\.[a-z2]*' find_shocks_tract.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $*
$(OUTPUTS_tract_cbm) $(IFE): ../output/simultaneous_shock_%.jld2: find_shocks_tract.jl ../input/model_%.jld2 ../temp/simultaneous_shock_cbm.jld2 $(shell grep -o '../[inputoem]*/[A-Za-z_0-9.]*\.[a-z2]*' find_shocks_tract.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $*
$(OUTPUTS_tract_csp): ../output/simultaneous_shock_%.jld2: find_shocks_tract.jl ../input/model_%.jld2 ../temp/simultaneous_shock_csp.jld2 $(shell grep -o '../[inputoem]*/[A-Za-z_0-9.]*\.[a-z2]*' find_shocks_tract.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $*

# TEMP RECIPES
$(SHOCK_GUESS): ../temp/simultaneous_shock_%.jld2: guess_shocks.jl ../input/model_%_sigma_4.0.jld2 $(shell grep -o '../[inputem]*/[A-Za-z_0-9.]*\.[a-z2]*' guess_shocks.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $*
../temp/treatmentIDS.csv: ../input/nyc_20102012_spikes_list.txt | ../temp
	(echo "id" && cat $<) > $@

#INPUT RECIPES
$(INPUTS_models): ../input/%.jld2 : ../../baseline_models_foreha/output/%.jld2 | ../input 
	ln -sf $< $@
$(INPUTS_obs_changes): ../input/%: ../../eventstudy_nyc_observed_changes/output/% | ../input
	ln -sf $< $@
$(INPUTS_data): ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@
../input/nyc_20102012_spikes_list.txt: ../input/%: ../../LODES_findemploymentspikes/output/% | ../input
	ln -sf $< $@