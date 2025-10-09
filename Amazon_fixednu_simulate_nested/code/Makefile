SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_zeta = 0.25
set_simulation = $(shell seq 1 1 100)
set_block = $(shell seq 1 1 50)
set_psd_num = 1000000

OUTPUTS = $(foreach zeta, $(set_zeta), $(foreach simulation, $(set_simulation), \
		../output/finite_labor_allocation_$(zeta)_$(simulation)_nested.csv.zip \
		../output/simulation_fixednu_$(zeta)_$(simulation)_nested.jld2))

REPORTS = $(foreach zeta, $(set_zeta), \
            $(foreach simulation, $(set_simulation), \
                $(foreach block, $(set_block), \
                    ../report/granular_$(zeta)_$(simulation)_$(block)_nested.csv.log) \
                ../report/simulation_fixednu_$(zeta)_$(simulation)_nested.jld2.log))
INPUTS_primitives = $(foreach zeta, $(set_zeta), ../input/primitives_nyc2010_time_ntaorigin_$(zeta).jld2)

.INTERMEDIATE: $(foreach zeta,$(set_zeta), \
    $(foreach simulation,$(set_simulation), \
        $(foreach block,$(set_block), \
            ../temp/granular_$(zeta)_$(simulation)_$(block)_nested.csv)))

all: ../temp/log_psd_cdf_$(set_zeta).csv $(OUTPUTS) $(REPORTS)
.PHONY: $(foreach zeta, $(set_zeta), $(foreach sim, $(set_simulation), simulation_array_$(zeta)_$(sim)))
include ../../generic.make

## OUTPUT RECIPES
../output/finite_labor_allocation%.csv.zip: ../temp/finite_labor_allocation%.csv | $(OOPR)
	zip $@ $< -j 

define compute_prices_quantities
../output/simulation_fixednu_$(zeta)_$(simulation)_nested.jld2 ../report/simulation_fixednu_$(zeta)_$(simulation)_nested.jld2.log: finitemodel_simulation_nested.jl $(shell grep -o '../input/[A-Za-z0-9_]*\.[a-z2]*' finitemodel_simulation_nested.jl) $(INPUTS_primitives) ../input/amazon_ctfl_tract_cbm_ntaorigin_$(zeta)_shock.csv ../temp/amazon_ctfl_tract_cbm_ntaorigin_$(zeta)_meanutil.jld2 ../temp/finite_labor_allocation_$(zeta)_$(simulation)_nested.csv | $(OOPR) $(JULIA_OOPR)
	$$(JULIA) $$< $(zeta) $(simulation) 
endef
$(foreach zeta, $(set_zeta), \
	$(foreach simulation, $(set_simulation), $(eval $(compute_prices_quantities))))

define collect_choices
../temp/temp_$(zeta)_$(simulation).csv ../temp/finite_labor_allocation_$(zeta)_$(simulation)_nested.csv: finitemodel_collect_choices_nested.do $(foreach block, $(set_block), ../temp/granular_$(zeta)_$(simulation)_$(block)_nested.csv) ../input/nyc2010_lodes_wzero_wdelta.dta | $(STATA_OOPR)
	$$(STATA) $$< $(zeta) $(simulation) 
endef
$(foreach zeta, $(set_zeta), \
	$(foreach simulation, $(set_simulation), $(eval $(collect_choices))))


define phony_array_simulations
simulation_array_$(zeta)_%: finitemodel_simulate_choices_nested.jl ../temp/amazon_ctfl_tract_cbm_ntaorigin_$(zeta)_meanutil.jld2 $(shell grep -o '../input/[A-Za-z0-9_]*\.[a-z2]*' finitemodel_simulate_choices_nested.jl) ../input/primitives_nyc2010_time_ntaorigin_$(zeta).jld2 ../temp/log_psd_cdf_$(zeta).csv | $(OOPR) $(JULIA_OOPR)
		sbatch -W --export=command1="module load julia/1.9.0",command2="julia finitemodel_simulate_choices_nested.jl $(zeta) $$* " custom.sbatch
endef 
$(foreach zeta, $(set_zeta), $(eval $(phony_array_simulations)))

## TEMP RECIPES
../temp/log_psd_cdf_%.csv: log_psd_draws.r | $(OOPR)
	$(R) $< $* $(set_psd_num)
../temp/amazon_ctfl_tract_cbm_%_meanutil.jld2: compute_meanutil_nested.jl ../input/primitives_nyc2010_time_%.jld2 ../input/model_cbm_%.jld2 $(foreach input, rent wage shock, ../input/amazon_ctfl_tract_cbm_%_$(input).csv) ../input/baseline_equilibrium_outcomes_%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $^ $@
.SECONDEXPANSION:
../temp/granular_%_nested.csv: finitemodel_simulate_choices_nested.jl ../temp/amazon_ctfl_tract_cbm_ntaorigin_$$(firstword $$(subst _, ,$$*))_meanutil.jld2 $(shell grep -o '../input/[A-Za-z0-9_]*\.[a-z2]*' finitemodel_simulate_choices_nested.jl) ../input/primitives_nyc2010_time_ntaorigin_$$(firstword $$(subst _, ,$$*)).jld2 ../temp/log_psd_cdf_$$(firstword $$(subst _, ,$$*)).csv | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $(subst _, ,$*)

## TEMP REPORT RECIPE
../report/granular_%_nested.csv.log: ../temp/granular_%_nested.csv | ../report
ifneq ($(shell command -v md5),)
	cat <(md5 $<) <(echo -n 'Lines:') <(cat $< | wc -l) <(head -3 $<) <(echo '...') <(tail -2 $<) > $@
else
	cat <(md5sum $<) <(echo -n 'Lines:') <(cat $< | wc -l) <(head -3 $<) <(echo '...') <(tail -2 $<) > $@
endif
## INPUT RECIPE
../input/finitemodel_programs.jl: ../../finitemodel_solver/code/finitemodel_programs.jl | ../input
	ln -sf $< $@
../input/shock_tract.jl: ../../common_scripts/code/shock_tract.jl | ../input
	ln -sf $< $@
../input/amazon_%: ../../Amazon_counterfactual_compute/output/amazon_%| ../input 
	ln -sf $< $@
../input/primitives_nyc2010_time_ntaorigin_%.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time_ntaorigin_%.jld2 | ../input
	ln -sf $< $@
../input/baseline_equilibrium_outcomes_%.jld2: ../../nyc_baseline_compute/output/baseline_equilibrium_outcomes_%.jld2 | ../input
	ln -sf $< $@
../input/model_%.jld2: ../../baseline_models_foreha/output/model_%.jld2 | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.dta: ../../nyc_baseline_data/output/nyc2010_lodes_wzero_wdelta.dta | ../input
	ln -sf $< $@


