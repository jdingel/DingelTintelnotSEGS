SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_shock := 1.09
set_event = $(shell seq 1 1 100)

OUTPUTS = $(foreach shock, $(set_shock), \
		$(foreach event, $(set_event), \
		$(addprefix ../output/prediction_csp_, $(shock)_$(event)_treated_ell_change_fixednu.csv) \
		$(addprefix ../output/prediction_cbm_, $(shock)_$(event)_treated_ell_change_fixednu.csv)))

## RECIPES
.SECONDARY: $(foreach shock, $(set_shock), \
			$(foreach event, $(set_event), \
			../temp/elasticity_$(shock)_$(event)_fixednu.csv ../temp/fe_i_$(shock)_$(event)_fixednu.dta ../temp/fe_j_$(shock)_$(event)_fixednu.dta \
			../temp/primitives_$(shock)_$(event)_fixednu.jld2 ))

all: $(OUTPUTS)
include ../../generic.make

## OUTPUT
../output/prediction_cbm_%_treated_ell_change_fixednu.csv ../temp/cbm_shock_%_fixednu.jld2: ctfl_cbm_fixednu.jl \
	$(shell grep -o '../[inputem]*/[A-Za-z_0-9]*\.[a-z_0-9]*' ctfl_cbm_fixednu.jl) \
	../temp/elasticity_%_fixednu.csv ../temp/primitives_%_fixednu.jld2 ../temp/fe_i_%_fixednu.dta ../temp/fe_j_%_fixednu.dta ../input/DGP_%_fixednu.csv | $(OOPR) $(JULIA_OOPR)
	$(eval twoargs := $(shell echo $* | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(JULIA) $< $(twoargs)

../output/prediction_csp_%_treated_ell_change_fixednu.csv ../temp/csp_shock_%_fixednu.jld2: ctfl_csp_fixednu.jl \
	$(shell grep -o '../[inputem]*/[A-Za-z_0-9]*\.[a-z_0-9]*' ctfl_csp_fixednu.jl) \
	../input/DGP_continuum_0_1.09_1_w.csv ../temp/primitives_%_fixednu.jld2 ../temp/cbm_shock_%_fixednu.jld2 ../input/DGP_%_fixednu.csv | $(OOPR) $(JULIA_OOPR)
	$(eval twoargs := $(shell echo $* | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(JULIA) $< $(twoargs)

## TEMP
../temp/primitives_%.jld2: ../input/calibrate_main.jl ../input/describe_data.jl ../input/calibrate_function.jl ../temp/elasticity_%.csv  ../temp/fe_i_%.dta ../temp/fe_j_%.dta ../temp/nyc2010_lodes_wzero_wdelta_%.dta | $(JULIA_OOPR) $(OOPR)
	$(JULIA) --no-job-name $< $@ 4.0 ../temp/elasticity_$*.csv  ../temp/fe_i_$*.dta ../temp/fe_j_$*.dta ../temp/nyc2010_lodes_wzero_wdelta_$*.dta

../temp/elasticity_%_fixednu.csv ../temp/fe_i_%_fixednu.dta ../temp/fe_j_%_fixednu.dta ../temp/nyc2010_lodes_wzero_wdelta_%_fixednu.dta: gravity_regression_fixednu.do \
	../input/gravity_saveFE_time.do ../input/nyc2010_lodes_wzero_wdelta.csv ../input/DGP_%_fixednu.csv | $(STATA_OOPR)
	$(eval twoargs := $(shell echo $* | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(STATA) $< $(twoargs)

## INPUT
../input/calibrate_main.jl ../input/calibrate_function.jl: ../input/%.jl: ../../nyc_baseline_calibrate/code/%.jl | ../input
	ln -sf $< $@
../input/gravity_saveFE_time.do: ../../common_scripts/code/gravity_saveFE_time.do | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.csv: ../../monte_carlo_iid_dgp/output/nyc2010_lodes_wzero_wdelta.csv | ../input 
	ln -sf $< $@
../input/nyc2010_time_elasticity.csv: ../../nyc_baseline_data/output/nyc2010_time_elasticity.csv | ../input
	ln -sf $< $@
../input/primitives_nyc2010_time.jld2: ../../nyc_baseline_calibrate/output/primitives_nyc2010_time.jld2 | ../input
	ln -sf $< $@
../input/DGP_%_fixednu.csv: ../../monte_carlo_fixednu_dgp/output/DGP_%_fixednu.csv | ../input 
	ln -sf $< $@
../input/DGP_continuum_0_1.09_1_w.csv: ../../monte_carlo_continuum_compute/output/DGP_continuum_0_1.09_1_w.csv
	ln -sf $< $@

../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@
../input/employment_gap_fn.jl: ../input/%: ../../common_scripts/code/% | ../input
	ln -sf $< $@
../input/baseline_equilibrium_solver.jl: ../../nyc_baseline_compute/code/baseline_equilibrium_solver.jl | ../input
	ln -sf $< $@
