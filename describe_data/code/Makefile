SHELL=bash
include ../../shell_functions.make

## DEFINITIONS

#RECIPES
all: $(addsuffix .jld2.log, $(addprefix ../report/,\
	primitives_nyc2010_time \
	$(foreach stub, _pool_2008_2010, baseline_equilibrium_outcomes$(stub)))) \
	../report/named_tuple_mwe.jld2.log

include ../../generic.make


../report/%.log: describe_data_script.jl ../input/describe_data.jl ../input/% | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< ../input/$*
../report/named_tuple_mwe.jld2.log: ../report/%.log: describe_data_script.jl ../input/describe_data.jl ../output/% | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< ../output/$*

#OUTPUT RECIPE
../output/named_tuple_mwe.jld2: prep_named_tuple.jl | $(JULIA_OOPR) $(OOPR)
	$(JULIA) $< 

#INPUT RECIPES
../input/baseline_equilibrium_outcomes%.jld2: ../../nyc_baseline_compute/output/baseline_equilibrium_outcomes%.jld2 | ../input
	ln -sf $< $@
../input/primitives_nyc2010_time.jld2: ../input/%: ../../nyc_baseline_calibrate/output/% | ../input
	ln -sf $< $@


