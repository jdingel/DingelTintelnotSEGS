SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sigma = 4.0 1.1 Inf

svd_ranks = $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 500 1000 1500 2143
nnmf_ranks = $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50
ife_ranks = 1 2 3

LODES_2010 = ../input/nyc2010_lodes_wzero_wdelta.dta
LODES_nta = ../input/nyc_NTA_2010_lodes_wzero_wdelta.dta

## INPUT
CBM_MODEL = $(addprefix ../input/model_cbm_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf deltainf))
CSP_MODEL = $(addprefix ../input/model_csp_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf))
SVD_MODEL = $(foreach rank, $(svd_ranks), ../input/model_svd_$(rank).jld2)
IFE_MODEL = $(foreach rank, $(ife_ranks), ../input/model_ife_$(rank).jld2)

INPUTS_models = $(CBM_MODEL) $(CSP_MODEL) \
	$(SVD_MODEL) $(IFE_MODEL)

# "cbm_deltainf" applies the same shock as "cbm_sigma_4.0"
CBM_SHOCKS = $(addprefix ../input/simultaneous_shock_cbm_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf))
CSP_SHOCKS = $(addprefix ../input/simultaneous_shock_csp_, $(addsuffix .jld2, sigma_4.0 sigma_1.1 sigma_Inf))
SVD_SHOCKS = $(foreach rank, $(svd_ranks), ../input/simultaneous_shock_svd_$(rank).jld2)
NL_SHOCKS = $(foreach nest, $(set_nests), $(foreach method, cbm csp, ../input/simultaneous_shock_$(method)_$(nest).jld2))
IFE_SHOCKS = $(foreach rank, $(ife_ranks), ../input/simultaneous_shock_ife_$(rank).jld2)

INPUTS_shocks = $(CBM_SHOCKS) $(CSP_SHOCKS) \
	$(SVD_SHOCKS) $(NNMF_SHOCKS) $(NL_SHOCKS) $(IFE_SHOCKS)

## OUTPUT
CBM = $(foreach stub, sigma_4.0 sigma_1.1 sigma_Inf, ../output/nyc_obs_cbm_$(stub)_all.csv)
CBM_NOEXT_MARGIN = ../output/nyc_obs_cbm_deltainf_all.csv
CSP = $(foreach stub, sigma_4.0 sigma_1.1 sigma_Inf, ../output/nyc_obs_csp_$(stub)_all.csv)
SVD = $(foreach rank, $(svd_ranks), ../output/nyc_obs_svd_$(rank)_all.csv)
NL = $(foreach nest, $(set_nests), $(foreach method, cbm csp, ../output/nyc_obs_$(method)_$(nest)_all.csv))
IFE = $(foreach rank, $(ife_ranks), ../output/nyc_obs_ife_$(rank)_all.csv)

OUTPUT = $(CBM) $(CSP) $(SVD)

all: $(OUTPUT) $(CBM_NOEXT_MARGIN) $(NL) ../output/nyc_obs_ife_1_all.csv
approx: $(SVD)
reports: $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(OUTPUT)))
approx_reports: $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(SVD)))
ife: $(IFE)
include ../../generic.make

# OUTPUT RECIPES
$(OUTPUT) $(NL) $(IFE): ../output/nyc_obs_%_all.csv: compute_counterfactual_eqlm.jl $(shell grep -o '../[inputem]*/[A-Za-z_0-9.]*\.[a-z2]*' compute_counterfactual_eqlm.jl | grep -v 'toml') $(LODES_2010) ../input/simultaneous_shock_%.jld2 ../input/model_%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $* $(LODES_2010)
../output/nyc_obs_cbm_deltainf_all.csv: compute_counterfactual_eqlm_cbm_deltainf.do $(LODES_2010) ../output/nyc_obs_cbm_sigma_4.0_all.csv | $(OOPR)
	$(STATA) $<

# INPUT RECIPES
../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@

$(INPUTS_shocks): ../input/%: ../../eventstudy_nyc_counterfactual_simultaneous_shock_solver/output/% | ../input
	ln -sf $< $@
$(INPUTS_models): ../input/%.jld2 : ../../baseline_models_foreha/output/%.jld2 | ../input 
	ln -sf $< $@
$(LODES_2010): ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
