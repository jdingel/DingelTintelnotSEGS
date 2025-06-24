SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_Lambda := 0 0.1 0.25 0.5 1
set_pop := 2.488905 5 12.5 25 50 125 250 2560
set_shock := 1.09 
set_event = $(shell seq 1 1 100)
set_quadruplet = $(foreach Lambda, $(set_Lambda),$(foreach pop, $(set_pop), $(foreach shock, $(set_shock), $(foreach event, $(set_event),$(Lambda)_$(pop)_$(shock)_$(event)))))
set_triplet = $(foreach pop, $(set_pop), $(foreach shock, $(set_shock), $(foreach event, $(set_event), $(pop)_$(shock)_$(event))))

INPUTS_deterministic = $(foreach stub, $(set_triplet), ../input/DGP_continuum_0_$(stub)_w.csv)
INPUTS_varying = $(foreach Lambda, 0.1 0.25 0.5 1, $(foreach stub, $(set_triplet), ../input/DGP_continuum_$(Lambda)_$(stub)_w.csv))

OUTPUTS = $(addprefix ../output/, $(foreach quadruplet,$(set_quadruplet), \
		cbm_shock_$(quadruplet).jld2 $(addprefix prediction_cbm_$(quadruplet), .csv _ell.csv) \
		csp_shock_$(quadruplet).jld2 $(addprefix prediction_csp_$(quadruplet), .csv _ell.csv)))

## REPORT
REPORTS = $(foreach stub, $(foreach Lambda, $(set_Lambda), $(foreach pop, $(set_pop), $(foreach shock, $(set_shock), $(foreach event, 1 2, $(Lambda)_$(pop)_$(shock)_$(event))))), \
	../report/primitives_$(stub).jld2.log \
	../report/cbm_shock_$(stub).jld2.log \
	../report/csp_shock_$(stub).jld2.log \
	../report/nyc2010_lodes_wzero_wdelta_$(stub).dta.log)

.SECONDARY: $(addprefix ../output/,$(foreach quadruplet,$(set_quadruplet), \
			elasticity_$(quadruplet).csv fe_i_$(quadruplet).dta fe_j_$(quadruplet).dta primitives_$(quadruplet).jld2 ))

all: $(OUTPUTS) $(REPORTS)
report: $(REPORTS)
elasticities: $(foreach quadruplet, $(set_quadruplet), ../output/elasticity_$(quadruplet).csv)
include ../../generic.make

.SECONDEXPANSION:
# Intentionally created symbolic links for continuum wages with population in the filenames
../output/csp_shock_%.jld2 $(addprefix ../output/prediction_csp_, %.csv %_ell.csv %_w.csv %_r.csv %_P.jld2): ctfl_csp.jl \
	$(shell grep -o '../[inputem]*/[A-Za-z_0-9]*\.[a-z_0-9]*' ctfl_csp.jl) \
	../input/DGP_%.csv ../input/DGP_continuum_%_w.csv $$(addprefix ../output/, elasticity_$$*.csv primitives_$$*.jld2 fe_i_$$*.dta fe_j_$$*.dta cbm_shock_$$*.jld2) | $(OOPR) $(JULIA_OOPR)
	$(eval fourargs := $(shell echo $@ | sed 's/\.jld2//g' | grep -Eo '[+-]?[0-9]+(\.[0-9]+)?'))
	$(JULIA) $< $(fourargs)
../output/cbm_shock_%.jld2 $(addprefix ../output/prediction_cbm_, %.csv %_ell.csv %_w.csv %_r.csv %_P.jld2): ctfl_cbm.jl \
	../input/DGP_%.csv $(shell grep -o '../[inputem]*/[A-Za-z_0-9]*\.[a-z_0-9]*' ctfl_cbm.jl) $$(addprefix ../output/, elasticity_$$*.csv primitives_$$*.jld2 fe_i_$$*.dta fe_j_$$*.dta) | $(OOPR) $(JULIA_OOPR)
	$(eval fourargs := $(shell echo $@ | sed 's/\.jld2//g' | grep -Eo '[+-]?[0-9]+(\.[0-9]+)?'))
	$(JULIA) $< $(fourargs)


../output/primitives_%.jld2: ../input/calibrate_main.jl ../input/describe_data.jl ../input/calibrate_function.jl ../output/elasticity_%.csv  ../output/fe_i_%.dta ../output/fe_j_%.dta ../output/nyc2010_lodes_wzero_wdelta_%.dta | $(JULIA_OOPR) $(OOPR)
	$(JULIA) --no-job-name $< $@ 4.0 ../output/elasticity_$*.csv ../output/fe_i_$*.dta ../output/fe_j_$*.dta ../output/nyc2010_lodes_wzero_wdelta_$*.dta
../output/elasticity_%.csv ../output/fe_i_%.dta ../output/fe_j_%.dta ../output/nyc2010_lodes_wzero_wdelta_%.dta: gravity_regression.do \
	$(shell grep -o '../[inputem]*/[A-Za-z_0-9]*\.[a-z_0-9]*' gravity_regression.do) ../input/DGP_%.csv | $(OOPR)
	$(eval fourargs := $(subst _, ,$*))
	$(STATA) $< $(fourargs)

## INPUT
../input/calibrate_main.jl ../input/calibrate_function.jl: ../input/%.jl: ../../nyc_baseline_calibrate/code/%.jl | ../input
	ln -sf $< $@
../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.csv: ../../monte_carlo_iid_dgp/output/nyc2010_lodes_wzero_wdelta.csv | ../input 
	ln -sf $< $@
../input/primitives_nyc2010_time.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time.jld2 | ../input
	ln -sf $< $@
../input/DGP_%.csv : ../../monte_carlo_iid_dgp/output/DGP_%.csv | ../input
	ln -sf $< $@
../input/granular_programs.jl: ../../granular_equilibrium_solver/code/granular_programs.jl | ../input
	ln -sf $< $@
../input/gravity_saveFE_time.do: ../../common_scripts/code/gravity_saveFE_time.do | ../input
	ln -sf $< $@
../input/baseline_equilibrium_solver.jl: ../../nyc_baseline_compute/code/baseline_equilibrium_solver.jl | ../input
	ln -sf $< $@
$(INPUTS_deterministic): ../../monte_carlo_continuum_compute/output/DGP_continuum_0_1.09_1_w.csv | ../input
	ln -sf $< $@
.SECONDEXPANSION:
$(INPUTS_varying): ../input/DGP_continuum_%.csv: ../../monte_carlo_continuum_compute/output/DGP_continuum_$$(shell echo $$* | sed 's/_[^_]*//1').csv | ../input
	ln -sf $< $@
../input/employment_gap_fn.jl ../input/hat_P.jl: ../input/%: ../../common_scripts/code/% | ../input
	ln -sf $< $@
