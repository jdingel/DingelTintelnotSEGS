SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sigma = 4.0 1.1 Inf
svd_ranks := 16 
ife_ranks = 1 #1 2 3

tract_models = $(foreach sigma, $(set_sigma), cbm_sigma_$(sigma) csp_sigma_$(sigma)) \
	$(foreach rank, $(svd_ranks), svd_$(rank)) \
	$(foreach rank, $(ife_ranks), ife_$(rank))

OUTPUTS_TRACT = $(foreach model, $(tract_models), $(foreach output, ell rent wage shock, ../output/amazon_ctfl_tract_$(model)_$(output).csv))
REPORT = $(patsubst ../output/%.csv, ../report/%.csv.log, $(OUTPUTS_TRACT))

all: $(OUTPUTS_TRACT) $(REPORT)
report: $(REPORT)
include ../../generic.make

## OUTPUT Recipes
$(foreach output, ell rent wage shock, ../output/amazon_ctfl_tract_%_$(output).csv): compute_amazon_ctfl_tract.jl ../input/eha_solver.jl ../input/employment_gap_fn.jl ../input/model_%.jld2 ../input/nyc2010_lodes_wzero_wdelta.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

## INPUTS
../input/model%.jld2: ../../baseline_models_foreha/output/model%.jld2 | ../input
	ln -sf $< $@
../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
../input/employment_gap_fn.jl: ../input/%.jl: ../../common_scripts/code/%.jl | ../input
	ln -sf $< $@
