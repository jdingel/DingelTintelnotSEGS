FUNCTIONS = $(shell cat ../../shell_functions.sh)
STATA = @$(FUNCTIONS); stata_with_flag
JULIA = @$(FUNCTIONS); julia_pc_and_slurm
R = @$(FUNCTIONS); R_pc_and_slurm
MATLAB = @$(FUNCTIONS); matlab_pc_and_slurm
WIPECLEAN = @$(FUNCTIONS); clean_task

#If 'make -n' option is invoked
ifneq (,$(findstring n,$(MAKEFLAGS)))
STATA := STATA
JULIA := JULIA
R := R
MATLAB := MATLAB
WIPECLEAN := WIPECLEAN
endif
