SHELL=bash
include ../../shell_functions.make


all: ../output/demo_confirmation.txt
include ../../generic.make

## OUTPUT
../output/demo_confirmation.txt: granular_demo.jl | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $<
