SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_sigma = 4.0 Inf
OUTPUTS_varsigma = $(foreach sigma, $(set_sigma), ../output/amazon_ctfl_tract_cbm_sigma_$(sigma)_prob.csv)

all: $(OUTPUTS_varsigma)
include ../../generic.make

## OUTPUT RECIPES
../output/amazon_ctfl_tract_cbm_%_prob.csv: amazon_ctfl_compute_cbm_prob.jl ../input/primitives_nyc2010_time_%.jld2 ../input/model_cbm_%.jld2 $(foreach input, rent wage shock, ../input/amazon_ctfl_tract_cbm_%_$(input).csv) ../input/baseline_equilibrium_outcomes_%.jld2 | $(OOPR) $(JULIA_OOPR) ../input/finitemodel_programs.jl
	$(JULIA) $^ $@

## INPUTS
../input/model%.jld2: ../../baseline_models_foreha/output/model%.jld2 | ../input
	ln -sf $< $@
../input/baseline_equilibrium%: ../../nyc_baseline_compute/output/baseline_equilibrium% | ../input
	ln -sf $< $@
../input/primitives_nyc2010_time_%.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time_%.jld2| ../input
	ln -sf $< $@
../input/amazon_%: ../../Amazon_counterfactual_compute/output/amazon_% | ../input
	ln -sf $< $@
../input/finitemodel_programs.jl: ../../finitemodel_solver/code/finitemodel_programs.jl | ../input
	ln -sf $< $@