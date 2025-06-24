SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_Lambda := 0 0.1 0.25 0.5 1
set_pop := 2.488905 5 12.5 25 50 125 250 2560
set_shock := 1.09 
set_event = $(shell seq 1 1 100)
set_quadruplet = $(foreach Lambda, $(set_Lambda),$(foreach pop, $(set_pop), $(foreach shock, $(set_shock), $(foreach event, $(set_event),$(Lambda)_$(pop)_$(shock)_$(event)))))
set_quadruplet_short = $(foreach Lambda, $(set_Lambda),$(foreach pop, $(set_pop), $(foreach shock, $(set_shock), $(foreach event, 1 2 3, $(Lambda)_$(pop)_$(shock)_$(event)))))
set_triplet = $(foreach pop, $(set_pop), $(foreach shock, $(set_shock), $(foreach event, $(set_event), $(pop)_$(shock)_$(event))))

INPUTS_deterministic_w = $(foreach stub, $(set_triplet), ../input/DGP_continuum_0_$(stub)_w.csv)
INPUTS_deterministic_ell = $(foreach stub, $(set_triplet), ../input/DGP_continuum_0_$(stub)_ell.csv)
INPUTS_varying = $(foreach Lambda, 0.1 0.25 0.5 1, $(foreach stub, $(set_triplet), \
	../input/DGP_continuum_$(Lambda)_$(stub)_w.csv ../input/DGP_continuum_$(Lambda)_$(stub)_ell.csv))

OUTPUTS = $(addprefix ../output/, $(foreach quadruplet,$(set_quadruplet), \
		cbm_shock_$(quadruplet).jld2 $(addprefix prediction_cbm_$(quadruplet), _ell.csv _w.csv _r.csv) \
		csp_shock_$(quadruplet).jld2 $(addprefix prediction_csp_$(quadruplet), _ell.csv _w.csv _r.csv)))

REPORTS = $(addprefix ../report/, $(foreach quadruplet, $(set_quadruplet_short), \
		cbm_shock_$(quadruplet).jld2.log csp_shock_$(quadruplet).jld2.log))

## RECIPES
.SECONDARY: $(addprefix ../input/,$(foreach quadruplet,$(set_quadruplet), \
			elasticity_$(quadruplet).csv primitives_$(quadruplet).jld2 ))

all: $(OUTPUTS) $(REPORTS)
report: $(REPORTS)
include ../../generic.make


.SECONDEXPANSION:
# Intentionally created symbolic links for continuum wages with population in the filenames
../output/csp_shock_%.jld2 $(addprefix ../output/prediction_csp_, %_ell.csv %_w.csv %_r.csv): ctfl_csp.jl \
	$(shell grep -o '../[inputem]*/[A-Za-z_0-9]*\.[a-z_0-9]*' ctfl_csp.jl) \
	../input/DGP_%.csv ../input/DGP_continuum_%_w.csv ../input/DGP_continuum_%_ell.csv ../output/cbm_shock_%.jld2 $$(addprefix ../input/, elasticity_$$*.csv primitives_$$*.jld2) | $(OOPR) $(JULIA_OOPR)
	$(eval fourargs := $(shell echo $@ | sed 's/\.jld2//g' | grep -Eo '[+-]?[0-9]+(\.[0-9]+)?'))
	$(JULIA) $< $(fourargs)
../output/cbm_shock_%.jld2 $(addprefix ../output/prediction_cbm_, %_ell.csv %_w.csv %_r.csv): ctfl_cbm.jl \
	$(shell grep -o '../[inputem]*/[A-Za-z_0-9]*\.[a-z_0-9]*' ctfl_cbm.jl) \
	../input/DGP_%.csv ../input/DGP_continuum_%_ell.csv $$(addprefix ../input/, elasticity_$$*.csv primitives_$$*.jld2) | $(OOPR) $(JULIA_OOPR)
	$(eval fourargs := $(shell echo $@ | sed 's/\.jld2//g' | grep -Eo '[+-]?[0-9]+(\.[0-9]+)?'))
	$(JULIA) $< $(fourargs)

# INPUT RECIPES
../input/primitives_nyc2010_time.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time.jld2 | ../input
	ln -sf $< $@
../input/elasticity_%.csv: ../../monte_carlo_iid_predictions/output/elasticity_%.csv | ../input 
	ln -sf $< $@ 
../input/primitives_%.jld2: ../../monte_carlo_iid_predictions/output/primitives_%.jld2 | ../input 
	ln -sf $< $@
../input/hat_P.jl ../input/employment_gap_fn.jl: ../input/%.jl: ../../common_scripts/code/%.jl | ../input
	ln -sf $< $@	
../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@

../input/baseline_equilibrium_solver.jl: ../../nyc_baseline_compute/code/baseline_equilibrium_solver.jl | ../input
	ln -sf $< $@
$(INPUTS_deterministic_w): ../../monte_carlo_continuum_compute/output/DGP_continuum_0_1.09_1_w.csv | ../input
	ln -sf $< $@
$(INPUTS_deterministic_ell): ../../monte_carlo_continuum_compute/output/DGP_continuum_0_1.09_1_ell.csv | ../input
	ln -sf $< $@
.SECONDEXPANSION:
$(INPUTS_varying): ../input/DGP_continuum_%.csv: ../../monte_carlo_continuum_compute/output/DGP_continuum_$$(shell echo $$* | sed 's/_[^_]*//1').csv | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.csv: ../../monte_carlo_iid_dgp/output/nyc2010_lodes_wzero_wdelta.csv | ../input 
	ln -sf $< $@
$(addprefix ../input/, $(foreach stub, $(set_quadruplet), DGP_$(stub).csv)): ../input/%.csv: ../../monte_carlo_iid_dgp/output/%.csv | ../input
	ln -sf $< $@