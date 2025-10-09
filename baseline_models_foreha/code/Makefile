SHELL=bash
include ../../shell_functions.make

set_sigma = 1.1 4.0 Inf
set_eta = 0.001 0.0028 0.1
set_nests = ntaorigin_0.75 workplace_0.75 ntaorigin_0.25 workplace_0.5 residence_0.75 residence_0.5

svd_ranks := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 500 1000 1500 2143
nnmf_ranks := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50
ife_ranks = 1 2 3

## INPUTS: baseline data
INPUTS_baseline_data = $(addprefix ../input/nyc, 2010_time_elasticity.csv \
	_pool_2008_2010_time_elasticity.csv 2008_time_elasticity.csv _delta_bar.jld2 2010_wage.dta _avg_wage_2008_2010.dta 2008_wage.dta \
	2008_lodes_wzero_wdelta.dta 2010_lodes_wzero_wdelta.dta _pool_2008_2010_lodes_wzero_wdelta.dta)
INPUTS_SVD = $(foreach rank, $(svd_ranks), ../input/nyc_2010_levels_tracttotract_approx_svd_$(rank).dta.zip)

# INPUTS: delta bar
INPUT_primitives = $(addprefix ../input/primitives_nyc, 2008_time.jld2 2010_time.jld2 2010_dist.jld2 _NTA_2010_time.jld2 _pool_2008_2010_time.jld2)

# INPUTS: nests structure
INPUT_nests_primitives = $(foreach stub, $(set_nests), ../input/primitives_nyc2010_time_$(stub).jld2)

# INPUTS: NTA
INPUTS_NYC_NTA = $(addprefix ../input/nyc_NTA_2010, _time_elasticity.csv _lodes_wzero_wdelta.dta)

## INPUTS: baseline equilibrium outcomes
INPUTS_baseline_eqlm := ../input/baseline_equilibrium_outcomes.jld2 \
	../input/baseline_equilibrium_outcomes_pool_2008_2010.jld2 \
	../input/baseline_equilibrium_outcomes_dist.jld2 \
	$(foreach sigma, $(set_sigma), ../input/baseline_equilibrium_outcomes_sigma_$(sigma).jld2) \
	$(foreach eta, $(set_eta), ../input/baseline_equilibrium_outcomes_eta_$(eta).jld2) \
	$(addprefix ../input/baseline_equilibrium_outcomes_nta, .jld2) \
	$(foreach rank, $(ife_ranks), ../input/baseline_equilibrium_outcomes_ife_$(rank).jld2) \
	$(foreach stub, $(set_nests), ../input/baseline_equilibrium_outcomes_$(stub).jld2)

## MODEL names
MODEL_types = CBM CBM_EXT CBM_NL CSP CSP_EXT CSP_NL SVD NNMF IFE

## OUTPUT
CBM = $(addprefix ../output/model_cbm_, sigma_4.0.jld2 sigma_1.1.jld2 sigma_Inf.jld2 eta_0.001.jld2 eta_0.0028.jld2 eta_0.1.jld2)
CBM_EXT = $(addprefix ../output/model_cbm_, dist.jld2 pool_2008_2010.jld2 nta.jld2)
CBM_NL = $(foreach stub, $(set_nests), ../output/model_cbm_$(stub).jld2)
CSP = $(addprefix ../output/model_csp_, sigma_4.0.jld2 sigma_1.1.jld2 sigma_Inf.jld2 eta_0.001.jld2 eta_0.0028.jld2 eta_0.1.jld2)
CSP_2008 = ../output/model_csp_2008.jld2
CSP_EXT = $(addprefix ../output/model_csp_, pool_2008_2010.jld2 nta.jld2)
CSP_NL = $(foreach stub, $(set_nests), ../output/model_csp_$(stub).jld2)
SVD = $(foreach rank, $(svd_ranks), ../output/model_svd_$(rank).jld2)
NNMF = $(foreach rank, $(nnmf_ranks), ../output/model_nnmf_$(rank).jld2)
IFE = $(foreach rank, $(ife_ranks), ../output/model_ife_$(rank).jld2)

SPECIFICATION_LIST = ../output/specification_list.csv
# deltainf is a statistical procedure instead of an economic model
LIST = cbm_deltainf $(patsubst ../output/model_%.jld2, %, $(CBM) $(CBM_EXT) $(CBM_NL) $(CSP) $(CSP_EXT) $(CSP_NL) $(SVD) $(NNMF) $(IFE))

## REPORT
CBM_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CBM)))
CBM_EXT_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CBM_EXT)))
CBM_NL_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CBM_NL)))
CSP_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CSP)))
CSP_EXT_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CSP_EXT)))
CSP_NL_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CSP_NL)))
SVD_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(SVD)))
NNMF_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(NNMF)))
IFE_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(IFE)))

REPORTS = $(CBM_LOG) $(CBM_EXT_LOG) $(CBM_NL_LOG) $(CSP_LOG) $(CSP_EXT_LOG) \
	$(CSP_NL_LOG) $(SVD_LOG) $(NNMF_LOG) $(IFE_LOG)

all: $(SPECIFICATION_LIST) $(CBM) $(CBM_EXT) $(CBM_NL) $(CSP) $(CSP_EXT) $(CSP_NL) $(SVD) $(NNMF) $(REPORTS) $(IFE)
report: $(REPORTS)
include ../../generic.make


## OUTPUT (CBM) RECIPES
../output/specification_list.csv: | $(OOPR)
	@echo "specification_name" > $@
	@echo $(LIST) | tr ' ' '\n' >> $@

../output/model_cbm_sigma_%.jld2: pack_cbm_models.jl $(shell sed -n '/CBM_sigma begin/,/CBM_sigma end/p' pack_cbm_models.jl | grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*') ../input/baseline_equilibrium_outcomes_sigma_%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< sigma $*
../output/model_cbm_eta_%.jld2: pack_cbm_models.jl $(shell sed -n '/CBM_eta begin/,/CBM_eta end/p' pack_cbm_models.jl | grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*') ../input/baseline_equilibrium_outcomes_eta_%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< eta $*
.SECONDEXPANSION:
$(CBM_EXT): ../output/model_cbm_%.jld2: pack_cbm_models.jl $$(shell sed -n '/CBM_$$* begin/,/CBM_$$* end/p' pack_cbm_models.jl | grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*') ../input/baseline_equilibrium_outcomes_%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $* 

## OUTPUT (CSP) RECIPES
../output/model_csp_sigma_%.jld2: pack_csp_models.jl $(shell sed -n '/CSP_sigma begin/,/CSP_sigma end/p' pack_csp_models.jl | grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*') | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< sigma $*
../output/model_csp_eta_%.jld2: pack_csp_models.jl $(shell sed -n '/CSP_eta begin/,/CSP_eta end/p' pack_csp_models.jl | grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*') | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< eta $*
.SECONDEXPANSION:
$(CSP_EXT): ../output/model_csp_%.jld2: pack_csp_models.jl $$(shell sed -n '/CSP_$$* begin/,/CSP_$$* end/p' pack_csp_models.jl | grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*') ../input/baseline_equilibrium_outcomes_%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $* 

../output/model_csp_2008.jld2: pack_csp_models.jl $(shell sed -n '/CSP_2008 begin/,/CSP_2008 end/p' pack_csp_models.jl | grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*') | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< 2008

## OUTPUT (SVD) RECIPES
$(SVD): ../output/model_svd_%.jld2: pack_svd_models.jl $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' pack_svd_models.jl | grep -v 'toml') ../temp/nyc_2010_levels_tracttotract_approx_svd_%.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

## OUTPUT (NNMF) RECIPES
../output/model_nnmf_%.jld2: pack_nnmf_models.jl $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' pack_nnmf_models.jl | grep -v 'toml') ../temp/nyc_2010_levels_tracttotract_approx_nnmf_%.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

## OUTPUT (NL) RECIPES
$(CBM_NL): ../output/model_cbm_%.jld2: pack_cbm_nested_logit_models.jl $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' pack_cbm_nested_logit_models.jl | grep -v 'toml') ../input/baseline_equilibrium_outcomes_%.jld2 ../input/primitives_nyc2010_time_%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $(shell echo $* | grep -Eo '[a-z0-9.]+')
$(CSP_NL): ../output/model_csp_%.jld2: pack_csp_nested_logit_models.jl $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' pack_csp_nested_logit_models.jl | grep -v 'toml') ../input/primitives_nyc2010_time_%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $(shell echo $* | grep -Eo '[a-z0-9.]+')

## OUTPUT (IFE) RECIPES
../output/model_ife_%.jld2: pack_ife_models.jl $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' pack_ife_models.jl | grep -v 'toml') ../input/baseline_equilibrium_outcomes_ife_%.jld2 ../input/nyc2010_time_elasticity_ife_%.csv | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

## TEMP (SVD, NNMF) RECIPES
../temp/nyc_2010_levels_tracttotract_approx_%.dta: ../input/nyc_2010_levels_tracttotract_approx_%.dta.zip | ../temp
	unzip -p $< > $@

## INPUT RECIPES
$(INPUTS_baseline_data): ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
$(INPUTS_baseline_eqlm): ../input/%: ../../nyc_baseline_compute/output/% | ../input
	ln -sf $< $@
../input/nyc2010_time_elasticity_dist.csv: ../../distance_based_delta_baseline_data/output/nyc2010_time_elasticity_dist.csv | ../input
	ln -sf $< $@
../input/NTA_avg_wages_2010.dta: ../input/%: ../../nyc_NTA_aggregate_baseline_wages/output/% | ../input
	ln -sf $< $@
$(INPUTS_NYC_NTA): ../input/%: ../../nyc_baseline_data_NTA/output/% | ../input
	ln -sf $< $@
../input/nyc2010_time_elasticity_ife_%.csv: ../../interactive_fe_estimation/output/beta_%.csv | ../input
	ln -sf $< $@
$(INPUTS_SVD): ../input/nyc_2010_levels_tracttotract_approx_svd_%.dta.zip: ../../nyc_baseline_data_SVD/output/nyc_2010_levels_tracttotract_approx_svd_%.dta.zip | ../input
	ln -sf $< $@
../input/nyc_2010_levels_tracttotract_approx_nnmf_%.dta.zip: ../../nyc_baseline_data_nnmf/output/nyc_2010_levels_tracttotract_approx_nnmf_%.dta.zip | ../input
	ln -sf $< $@
$(INPUT_primitives): ../input/%: ../../nyc_baseline_calibrate/output/% | ../input
	ln -sf $< $@
$(INPUT_nests_primitives): ../input/%: ../../nyc_baseline_calibrate/output/% | ../input
	ln -sf $< $@
