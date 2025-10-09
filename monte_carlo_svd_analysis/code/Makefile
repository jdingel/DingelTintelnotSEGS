SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_Lambda := 0
set_pop := 2.488905
set_shock := 1.09
set_event := $(shell seq 1 1 100)
set_mc_rank := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 500 1000 1500 full 
set_es_rank := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 500 1000 1500 2143 

INPUTS_ell = ../input/DGP_continuum_$(set_Lambda)_$(set_shock)_ell.csv

INPUTS_EVENTSTUDY_SVD = $(foreach rank, $(set_es_rank), ../input/slope_int_MSE_all_svd_$(rank).csv)

OUTPUTS := $(foreach Lambda, $(set_Lambda), \
	$(foreach pop, $(set_pop), \
	$(foreach shock, $(set_shock), \
	$(foreach rank, $(set_mc_rank), ../output/sum_continuum_labor_$(Lambda)_$(pop)_$(shock)_$(rank).dta)))) \
	../output/monte_carlo_svd_performance.tex

## RECIPES
all: $(OUTPUTS)
include ../../generic.make

define summarise_simulations
../output/sum_continuum_labor_$(Lambda)_$(pop)_$(shock)_$(rank).dta: sum_labor.do \
	$(foreach event, $(set_event), ../input/prediction_svd_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank)_ell.csv) \
	../input/DGP_continuum_$(Lambda)_$(shock)_ell.csv | \
	$(STATA_OOPR)
	$$(STATA) $$< $(Lambda) $(pop) $(shock) $(rank)
endef

$(foreach Lambda, $(set_Lambda), \
	$(foreach pop, $(set_pop), \
	$(foreach shock, $(set_shock), \
	$(foreach rank, $(set_mc_rank), $(eval $(summarise_simulations))))))

../output/monte_carlo_svd_performance.tex: svd_table_generator.R \
	$(INPUTS_EVENTSTUDY_SVD) \
	monte_carlo_svd_performance_skeleton.tex $(foreach Lambda, $(set_Lambda), \
	$(foreach pop, $(set_pop), \
	$(foreach shock, $(set_shock), \
	$(foreach rank, $(set_mc_rank), ../output/sum_continuum_labor_$(Lambda)_$(pop)_$(shock)_$(rank).dta)))) | $(OOPR)
	$(R) $< $(set_mc_rank)
	
## INPUTS
../input/prediction_svd_%.csv: ../../monte_carlo_svd_predictions/output/prediction_svd_%.csv | ../input
	ln -sf $< $@
$(INPUTS_ell): ../../monte_carlo_continuum_compute/output/DGP_continuum_$(set_Lambda)_$(set_shock)_1_ell.csv | ../input
	ln -sf $< $@
$(INPUTS_EVENTSTUDY_SVD): ../input/%.csv: ../../eventstudy_nyc_counterfactual_analyze/output/%.csv | ../input 
	ln -sf $< $@
