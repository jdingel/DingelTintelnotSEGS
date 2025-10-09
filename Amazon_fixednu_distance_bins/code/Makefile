
SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_simulation = $(shell seq 1 1 100)
set_sigma = 4.0 Inf
INPUTS_compute = $(addprefix ../input/, $(foreach sigma, $(set_sigma), amazon_ctfl_tract_cbm_sigma_$(sigma)_wage.csv amazon_ctfl_tract_cbm_sigma_$(sigma)_rent.csv))
OUTPUTS_distbin = $(foreach sigma, $(set_sigma), $(foreach bit, dest orig,  ../output/simulation_bydistbin_fixednu_$(bit)_$(sigma).csv))

all:  $(OUTPUTS_distbin) 
include ../../generic.make

## OUTPUT RECIPES
../output/simulation_bydistbin_fixednu_orig_%.csv: aggregate_simulation_bydistbin_orig.jl $(foreach s, $(set_simulation), ../input/simulation_fixednu_%_$(s).jld2) ../input/describe_data.jl ../input/amazon_ctfl_tract_cbm_sigma_%_rent.csv ../input/NYC_dist_to_treated.dta | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< $*
../output/simulation_bydistbin_fixednu_dest_%.csv: aggregate_simulation_bydistbin_dest.jl $(foreach s, $(set_simulation), ../input/simulation_fixednu_%_$(s).jld2) ../input/describe_data.jl ../input/amazon_ctfl_tract_cbm_sigma_%_wage.csv ../input/NYC_dist_to_treated.dta | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< $*

## INPUT RECIPE
../input/simulation_fixednu%.jld2: ../../Amazon_fixednu_simulate/output/simulation_fixednu%.jld2 | ../input
	ln -sf $< $@
$(INPUTS_compute): ../input/%: ../../Amazon_counterfactual_compute/output/% | ../input
	ln -sf $< $@
../input/NYC_dist_to_treated.dta: ../../Amazon_compute_dist_to_treated/output/NYC_dist_to_treated.dta | ../input
	ln -sf $< $@


