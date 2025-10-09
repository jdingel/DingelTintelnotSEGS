SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sigma = 4.0 1.1 Inf
svd_ranks := 16 
ife_ranks = 1
set_zeta = 0.25 0.75

tract_models = $(foreach sigma, $(set_sigma), cbm_sigma_$(sigma) csp_sigma_$(sigma)) \
	$(foreach rank, $(svd_ranks), svd_$(rank)) \
	$(foreach rank, $(ife_ranks), ife_$(rank)) \
	$(foreach zeta, $(set_zeta), cbm_ntaorigin_$(zeta)) \
	csp_2008
nta_models = cbm_nta csp_nta

OUTPUTS_TRACT = $(foreach model, $(tract_models), $(foreach output, ell rent wage shock, ../output/amazon_ctfl_tract_$(model)_$(output).csv))
OUTPUTS_NTA = $(foreach model, $(nta_models), $(foreach output, ell rent wage shock, ../output/amazon_ctfl_$(model)_$(output).csv))
REPORT = $(patsubst ../output/%.csv, ../report/%.csv.log, $(OUTPUTS_TRACT) $(OUTPUTS_NTA))

all: $(OUTPUTS_TRACT) $(OUTPUTS_NTA) $(REPORT)
report: $(REPORT)
include ../../generic.make

## OUTPUT RECIPES
$(foreach output, ell rent wage shock, ../output/amazon_ctfl_tract_csp_2008_$(output).csv): compute_amazon_ctfl_tract.jl ../input/eha_solver.jl ../input/employment_gap_fn.jl ../input/model_csp_2008.jld2 ../input/nyc2008_lodes_wzero_wdelta.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< csp_2008

$(foreach output, ell rent wage shock, ../output/amazon_ctfl_tract_%_$(output).csv): compute_amazon_ctfl_tract.jl ../input/eha_solver.jl ../input/employment_gap_fn.jl ../input/model_%.jld2 ../input/nyc2010_lodes_wzero_wdelta.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

$(foreach output, ell rent wage shock, ../output/amazon_ctfl_%_$(output).csv): compute_amazon_ctfl_nta.jl ../input/eha_solver.jl  ../input/model_%.jld2 ../input/employment_gap_fn.jl ../input/nyc_NTA_2012_2010_observed_changes_origtodest.dta | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

## INPUTS
../input/model%.jld2: ../../baseline_models_foreha/output/model%.jld2 | ../input
	ln -sf $< $@
../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../input/%: ../../nyc_baseline_data/output/% | ../input
	ln -sf $< $@
../input/nyc_NTA_2012_2010_observed_changes_origtodest.dta: ../input/%: ../../eventstudy_nyc_observed_changes/output/% | ../input
	ln -sf $< $@
../input/employment_gap_fn.jl: ../input/%.jl: ../../common_scripts/code/%.jl | ../input
	ln -sf $< $@
../input/nyc2008_lodes_wzero_wdelta.dta: ../../nyc_baseline_data/output/nyc2008_lodes_wzero_wdelta.dta | ../input
	ln -sf $< $@
