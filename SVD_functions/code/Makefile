SHELL=bash
include ../../shell_functions.make

all: run_test
run_test: SVD_funcs_test.jl SVD_funcs.jl $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z]*' SVD_funcs_test.jl)
	$(JULIA) SVD_funcs_test.jl
	
include ../../generic.make
