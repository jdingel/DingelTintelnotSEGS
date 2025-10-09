SHELL=bash
include ../../shell_functions.make


all: ../output/demo_confirmation.txt
include ../../generic.make

## OUTPUT
../output/demo_confirmation.txt: finitemodel_demo.jl | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $<
finitemodel_demo.jl: finitemodel_programs.jl