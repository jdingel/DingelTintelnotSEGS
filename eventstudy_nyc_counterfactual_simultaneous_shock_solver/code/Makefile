SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_nests = ntaorigin_0.75 workplace_0.75 ntaorigin_0.25 workplace_0.5 residence_0.75 residence_0.5
svd_ranks := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 500 1000 1500 2143
nnmf_ranks := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50
ife_ranks = 1 2 3

## INPUT
CBM_MODEL = $(addprefix ../input/model_cbm_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf eta_0.001 eta_0.0028 eta_0.1 dist))
CSP_MODEL = $(addprefix ../input/model_csp_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf eta_0.001 eta_0.0028 eta_0.1))
NTA_MODEL = $(foreach model, cbm csp, ../input/model_$(model)_nta.jld2)
POOL_MODEL = $(foreach model, cbm csp, ../input/model_$(model)_pool_2008_2010.jld2)
SVD_MODEL = $(foreach rank, $(svd_ranks), ../input/model_svd_$(rank).jld2)
NNMF_MODEL = $(foreach rank, $(nnmf_ranks), ../input/model_nnmf_$(rank).jld2)
NL_MODEL = $(foreach nest, $(set_nests), $(foreach model, cbm csp, ../input/model_$(model)_$(nest).jld2))
IFE_MODEL = $(foreach rank, $(ife_ranks), ../input/model_ife_$(rank).jld2)

INPUTS_models = $(CBM_MODEL) $(CSP_MODEL) $(NTA_MODEL) $(POOL_MODEL) \
	$(SVD_MODEL) $(NNMF_MODEL) $(NL_MODEL) $(IFE_MODEL)

INPUTS_obs_changes = $(foreach stub, nyc_2012_2010_2008_pool nyc_2012_2010, ../input/$(stub)_observed_changes_dest_tract.dta) \
	../input/nyc_NTA_2012_2010_observed_changes_dest.dta

INPUTS_data_NTA = ../input/nyc_NTA_2010_lodes_wzero_wdelta.dta
INPUTS_data = $(addsuffix lodes_wzero_wdelta.dta, ../input/nyc2010_ ../input/nyc_pool_2008_2010_) \
	$(addprefix ../input/, nyc2012_lodes_wzeros.dta nyc2010_wage.dta nyc_avg_wage_2008_2010.dta)

## OUTPUT
CBM = $(addprefix ../output/simultaneous_shock_cbm_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf eta_0.001 eta_0.0028 eta_0.1 dist))
CSP = $(addprefix ../output/simultaneous_shock_csp_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf eta_0.001 eta_0.0028 eta_0.1))
NTA = $(addprefix ../output/simultaneous_shock_, $(foreach model, cbm csp, $(model)_nta.jld2))
POOL = $(addprefix ../output/simultaneous_shock_, $(foreach model, cbm csp, $(model)_pool_2008_2010.jld2))
SVD = $(foreach rank, $(svd_ranks), ../output/simultaneous_shock_svd_$(rank).jld2)
NNMF = $(foreach rank, $(nnmf_ranks), ../output/simultaneous_shock_nnmf_$(rank).jld2)
CBM_NL = $(foreach nest, $(set_nests), ../output/simultaneous_shock_cbm_$(nest).jld2)
CSP_NL = $(foreach nest, $(set_nests), ../output/simultaneous_shock_csp_$(nest).jld2)
IFE = $(foreach rank, $(ife_ranks), ../output/simultaneous_shock_ife_$(rank).jld2)

OUTPUTS_tract_csp = $(CSP) $(CSP_NL)
OUTPUTS_tract_cbm = $(CBM) $(CBM_NL)
OUTPUTS_tract_approx = $(SVD) $(NNMF)

## REPORT
CBM_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CBM)))
CSP_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CSP)))
NTA_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(NTA)))
POOL_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(POOL)))
SVD_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(SVD)))
NNMF_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(NNMF)))
CBM_NL_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CBM_NL)))
CSP_NL_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CSP_NL)))
IFE_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(IFE)))

REPORTS = $(CBM_LOG) $(CSP_LOG) $(NTA_LOG) $(POOL_LOG) \
	$(SVD_LOG) $(NNMF_LOG) $(CBM_NL_LOG) $(CSP_NL_LOG) $(IFE_LOG)

SHOCK_GUESS = $(addprefix ../temp/simultaneous_shock_, cbm.jld2 csp.jld2)

all: $(CBM) $(CSP) $(NTA) $(POOL) $(SVD) $(NNMF) $(CBM_NL) $(CSP_NL) $(IFE)
report: $(REPORTS)

include ../../generic.make

# OUTPUT RECIPES
$(OUTPUTS_tract_approx): ../output/simultaneous_shock_%.jld2: find_shocks_tract.jl ../input/model_%.jld2 ../temp/simultaneous_shock_csp.jld2 $(shell grep -o '../[inputoem]*/[A-Za-z_0-9.]*\.[a-z2]*' find_shocks_tract.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $*
$(OUTPUTS_tract_cbm) $(IFE): ../output/simultaneous_shock_%.jld2: find_shocks_tract.jl ../input/model_%.jld2 ../temp/simultaneous_shock_cbm.jld2 $(shell grep -o '../[inputoem]*/[A-Za-z_0-9.]*\.[a-z2]*' find_shocks_tract.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $*
$(OUTPUTS_tract_csp): ../output/simultaneous_shock_%.jld2: find_shocks_tract.jl ../input/model_%.jld2 ../temp/simultaneous_shock_csp.jld2 $(shell grep -o '../[inputoem]*/[A-Za-z_0-9.]*\.[a-z2]*' find_shocks_tract.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $*
$(POOL): ../output/simultaneous_shock_%_pool_2008_2010.jld2: find_shocks_pool.jl ../input/model_%_pool_2008_2010.jld2 ../temp/simultaneous_shock_%.jld2 $(shell grep -o '../[inputoem]*/[A-Za-z_0-9.]*\.[a-z2]*' find_shocks_pool.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $*
$(NTA): ../output/simultaneous_shock_%.jld2: find_shocks_nta.jl ../input/model_%.jld2 $(shell grep -o '../[inputoem]*/[A-Za-z_0-9.]*\.[a-z2]*' find_shocks_nta.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $*

# TEMP RECIPES
$(SHOCK_GUESS): ../temp/simultaneous_shock_%.jld2: guess_shocks.jl ../input/model_%_sigma_4.0.jld2 $(shell grep -o '../[inputem]*/[A-Za-z_0-9.]*\.[a-z2]*' guess_shocks.jl | grep -v 'toml') | $(OOPR) $(JULIA_OOPR) 
	$(JULIA) $< $*
../temp/treatmentIDS.csv: ../input/nyc_20102012_spikes_list.txt | ../temp
	(echo "id" && cat $<) > $@
../temp/treatmentIDS_NTA.csv: ../input/NTA_spikes_list_12.5pct.csv | ../temp
	sed 's/"//g; s/NTA_code/id/' $< > $@

#INPUT RECIPES
$(INPUTS_models): ../input/%.jld2 : ../../baseline_models_foreha/output/%.jld2 | ../input 
	ln -sf $< $@
$(INPUTS_obs_changes): ../input/%: ../../eventstudy_nyc_observed_changes/output/% | ../input
	ln -sf $< $@
$(INPUTS_data_NTA) : ../input/%: ../../nyc_baseline_data_NTA/output/% | ../input
	ln -sf $< $@
$(INPUTS_data): ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@

../input/nyc_20102012_spikes_list.txt: ../input/%: ../../LODES_findemploymentspikes/output/% | ../input
	ln -sf $< $@
../input/NTA_spikes_list_12.5pct.csv : ../input/%: ../../eventstudy_nyc_NTA_findemploymentspikes/output/% | ../input
	ln -sf $< $@
