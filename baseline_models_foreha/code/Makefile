SHELL=bash
include ../../shell_functions.make

set_sigma = 1.1 4.0 Inf

svd_ranks := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 500 1000 1500 2143
ife_ranks = 1 2 3

## INPUTS: baseline data
INPUTS_baseline_data = $(addprefix ../input/nyc, 2010_time_elasticity.csv \
	_pool_2008_2010_time_elasticity.csv _delta_bar.jld2 2010_wage.dta _avg_wage_2008_2010.dta \
	2010_lodes_wzero_wdelta.dta _pool_2008_2010_lodes_wzero_wdelta.dta)
INPUTS_SVD = $(foreach rank, $(svd_ranks), ../input/nyc_2010_levels_tracttotract_approx_svd_$(rank).dta.zip)

# INPUTS: delta bar
INPUT_primitives = $(addprefix ../input/primitives_nyc, 2010_time.jld2)

## INPUTS: baseline equilibrium outcomes
INPUTS_baseline_eqlm := ../input/baseline_equilibrium_outcomes.jld2 \
	../input/baseline_equilibrium_outcomes_dist.jld2 \
	$(foreach sigma, $(set_sigma), ../input/baseline_equilibrium_outcomes_sigma_$(sigma).jld2) \
	$(foreach rank, $(ife_ranks), ../input/baseline_equilibrium_outcomes_ife_$(rank).jld2) \

## OUTPUT
CBM = $(addprefix ../output/model_cbm_, sigma_4.0.jld2 sigma_1.1.jld2 sigma_Inf.jld2)
CSP = $(addprefix ../output/model_csp_, sigma_4.0.jld2 sigma_1.1.jld2 sigma_Inf.jld2)
SVD = $(foreach rank, $(svd_ranks), ../output/model_svd_$(rank).jld2)
IFE = $(foreach rank, $(ife_ranks), ../output/model_ife_$(rank).jld2)

SPECIFICATION_LIST = ../output/specification_list.csv
# deltainf is a statistical procedure instead of an economic model
LIST = cbm_deltainf $(patsubst ../output/model_%.jld2, %, $(CBM) $(CSP) $(SVD) $(IFE))

## REPORT
CBM_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CBM)))
CSP_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(CSP)))
SVD_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(SVD)))
IFE_LOG = $(addsuffix .log, $(patsubst ../output/%, ../report/%, $(IFE)))

REPORTS = $(CBM_LOG) $(CSP_LOG) \
	$(SVD_LOG) $(IFE_LOG)

all: $(SPECIFICATION_LIST) $(CBM) $(CSP) $(SVD) $(REPORTS) $(IFE)
report: $(REPORTS)
include ../../generic.make


## OUTPUT (CBM) RECIPES
../output/specification_list.csv:
	@echo "specification_name" > $@
	@echo $(LIST) | tr ' ' '\n' >> $@

../output/model_cbm_sigma_%.jld2: pack_cbm_models.jl $(shell sed -n '/CBM_sigma begin/,/CBM_sigma end/p' pack_cbm_models.jl | grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*') ../input/baseline_equilibrium_outcomes_sigma_%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< sigma $*

## OUTPUT (CSP) RECIPES
../output/model_csp_sigma_%.jld2: pack_csp_models.jl $(shell sed -n '/CSP_sigma begin/,/CSP_sigma end/p' pack_csp_models.jl | grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*') | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< sigma $*

## OUTPUT (SVD) RECIPES
$(SVD): ../output/model_svd_%.jld2: pack_svd_models.jl $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' pack_svd_models.jl | grep -v 'toml') ../temp/nyc_2010_levels_tracttotract_approx_svd_%.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

## OUTPUT (IFE) RECIPES
../output/model_ife_%.jld2: pack_ife_models.jl $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z2]*' pack_ife_models.jl | grep -v 'toml') ../input/baseline_equilibrium_outcomes_ife_%.jld2 ../input/nyc2010_time_elasticity_ife_%.csv | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

## TEMP (SVD) RECIPES
../temp/nyc_2010_levels_tracttotract_approx_%.dta: ../input/nyc_2010_levels_tracttotract_approx_%.dta.zip | ../temp
	unzip -p $< > $@

## INPUT RECIPES
$(INPUTS_baseline_data): ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
$(INPUTS_baseline_eqlm): ../input/%: ../../nyc_baseline_compute/output/% | ../input
	ln -sf $< $@
../input/nyc2010_time_elasticity_ife_%.csv: ../../interactive_fe_estimation/output/beta_%.csv | ../input
	ln -sf $< $@
$(INPUTS_SVD): ../input/nyc_2010_levels_tracttotract_approx_svd_%.dta.zip: ../../nyc_baseline_data_SVD/output/nyc_2010_levels_tracttotract_approx_svd_%.dta.zip | ../input
	ln -sf $< $@
$(INPUT_primitives): ../input/%: ../../nyc_baseline_calibrate/output/% | ../input
	ln -sf $< $@