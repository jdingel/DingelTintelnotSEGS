SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_Lambda := 0
set_pop := 2.488905
set_event := $(shell seq 1 1 100)
set_shock := 1.09
set_rank := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 200 500 1000 1500 full 
set_stub = $(foreach shock, $(set_shock), $(foreach event, $(set_event), $(shock)_$(event)))
INPUTS_deterministic_w = $(foreach stub, $(set_stub), ../input/DGP_continuum_0_$(stub)_w.csv)
INPUTS_deterministic_ell = $(foreach stub, $(set_stub), ../input/DGP_continuum_0_$(stub)_ell.csv)


## RECIPES
OUTPUTS = $(foreach Lambda, $(set_Lambda), \
	$(foreach pop, $(set_pop), \
	$(foreach shock, $(set_shock), \
	$(foreach event, $(set_event), \
	$(foreach rank, $(set_rank), ../output/prediction_svd_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank)_ell.csv)))))

REPORTS = $(foreach Lambda, $(set_Lambda), \
	$(foreach pop, $(set_pop), \
	$(foreach shock, $(set_shock), \
	$(foreach event, 1 2 3, \
	$(foreach rank, $(set_rank), ../report/svd_shock_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank).jld2.log)))))

.INTERMEDIATE: $(foreach Lambda, $(set_Lambda), \
	$(foreach pop, $(set_pop), \
	$(foreach shock, $(set_shock), \
	$(foreach event, $(set_event), \
	$(foreach rank, $(set_rank), ../temp/DGP_approx_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank).csv)))))

all: $(OUTPUTS) $(REPORTS)
reports: $(REPORTS)
include ../../generic.make

define compute_counterfactuals
../output/prediction_svd_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank)_ell.csv \
../output/svd_shock_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank).jld2: ctfl_svd.jl \
	../temp/DGP_approx_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank).csv \
	$(shell grep -o '../[inputem]*/[A-Za-z_0-9]*\.[a-z_0-9]*' ctfl_svd.jl) \
	../input/elasticity_$(Lambda)_$(pop)_$(shock)_$(event).csv \
	../input/fe_i_$(Lambda)_$(pop)_$(shock)_$(event).dta \
	../input/fe_j_$(Lambda)_$(pop)_$(shock)_$(event).dta \
	../input/DGP_continuum_$(Lambda)_$(shock)_$(event)_ell.csv \
	../input/DGP_continuum_$(Lambda)_$(shock)_$(event)_w.csv | $(OOPR) $(JULIA_OOPR) 
	$$(JULIA) $$< $(Lambda) $(pop) $(shock) $(event) $(rank)
endef

$(foreach Lambda, $(set_Lambda), \
	$(foreach pop, $(set_pop), \
	$(foreach shock, $(set_shock), \
	$(foreach event, $(set_event), \
	$(foreach rank, $(set_rank), $(eval $(compute_counterfactuals)))))))

## TEMP
../temp/DGP_approx_%.csv: | ../input/DGP_approx_%.csv.zip
	unzip ../input/DGP_approx_$*.csv.zip -d ../temp

## INPUTS
../input/DGP_approx_%.csv.zip: ../../monte_carlo_SVD_approx/output/DGP_approx_%.csv.zip | ../input
	ln -sf $< $@
$(INPUTS_deterministic_w): ../../monte_carlo_continuum_compute/output/DGP_continuum_0_1.09_1_w.csv | ../input
	ln -sf $< $@
$(INPUTS_deterministic_ell): ../../monte_carlo_continuum_compute/output/DGP_continuum_0_1.09_1_ell.csv | ../input
	ln -sf $< $@
../input/nyc2010_lodes_wzero_wdelta.csv: ../../monte_carlo_iid_dgp/output/nyc2010_lodes_wzero_wdelta.csv | ../input 
	ln -sf $< $@
../input/nyc2010_time_elasticity.csv: ../../nyc_baseline_data/output/nyc2010_time_elasticity.csv | ../input
	ln -sf $< $@
../input/elasticity_%.csv: ../../monte_carlo_iid_predictions/output/elasticity_%.csv | ../input
	ln -sf $< $@
../input/fe_%.dta: ../../monte_carlo_iid_predictions/output/fe_%.dta | ../input
	ln -sf $< $@

../input/eha_solver.jl: ../../eha_solver/code/eha_solver.jl | ../input
	ln -sf $< $@
../input/employment_gap_fn.jl: ../input/%: ../../common_scripts/code/% | ../input
	ln -sf $< $@
