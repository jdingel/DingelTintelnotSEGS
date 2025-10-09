SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_Lambda := 0
set_pop := 2.488905
set_event := $(shell seq 1 1 100)
set_shock := 1.09
set_rank := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 200 500 1000 1500 full

## RECIPES
all: $(foreach Lambda, $(set_Lambda), \
	$(foreach pop, $(set_pop), \
	$(foreach shock, $(set_shock), \
	$(foreach event, $(set_event), \
	$(foreach rank, $(set_rank), ../output/DGP_approx_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank).csv.zip)))))

include ../../generic.make

## OUTPUT RECIPE
define run_approximation
../output/DGP_approx_$(Lambda)_$(pop)_$(shock)_$(event)_$(rank).csv.zip: apply_SVD_to_simulated_data.jl $(shell grep -o '../[inputem]*/[A-Za-z_0-9]*\.[a-z_0-9]*' apply_SVD_to_simulated_data.jl) ../input/DGP_$(Lambda)_$(pop)_$(shock)_$(event).csv | $(OOPR) $(JULIA_OOPR)
	$$(JULIA) $$< $(Lambda) $(pop) $(shock) $(event) $(rank)
endef
$(foreach Lambda, $(set_Lambda), \
	$(foreach pop, $(set_pop), \
	$(foreach shock, $(set_shock), \
	$(foreach event, $(set_event), \
	$(foreach rank, $(set_rank), $(eval $(run_approximation)))))))

## INPUT RECIPES
../input/SVD_funcs.jl: ../input/%.jl: ../../SVD_functions/code/SVD_funcs.jl | ../input 
	ln -sf $< $@
../input/DGP%.csv: ../../monte_carlo_iid_dgp/output/DGP%.csv | ../input
	ln -sf $< $@
