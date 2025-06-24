# Make setup (see shell_functions for further details)
SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_start := $(shell seq 1 1 200) # Multistart seeds to estimate from
set_commuting_elas_precision = 0.001
set_fe_precision = 0.1
max_rank = 3
set_rank := $(shell seq 0 1 $(max_rank)) # All ranks considered (R = 0 is PPML)
set_rank_ife := $(shell seq 1 1 $(max_rank)) # Only ranks which have nontrivial IFEs
IFE_OUTPUTS = $(foreach rank, $(set_rank), \
			../output/beta_$(rank).csv ../output/fe_i_$(rank).csv \
			../output/fe_j_$(rank).csv ../output/ife_ij_$(rank).csv)

## RECIPES
all: $(IFE_OUTPUTS) 
include ../../generic.make

## OUTPUT RECIPES
# Optimal parameter estimates for rank 0 through 3
$(addprefix ../output/, beta_0.csv fe_i_0.csv fe_j_0.csv ife_ij_0.csv) ../temp/labor_b_approx_ife_0.csv: select_optimal_ests_0.sbatch \
	$(addprefix ../temp/multistarts/2010/, beta_0_1.csv fe_i_0_1.csv fe_j_0_1.csv) | $(OOPR)
	sbatch -W $< 
	rm select_optimal_ests_0.sbatch

$(addprefix ../output/, optimum_seed_%.csv beta_%.csv fe_i_%.csv fe_j_%.csv ife_ij_%.csv) ../temp/labor_b_approx_ife_%.csv: select_optimal_ests_%.sbatch \
	$(addprefix ../temp/multistarts/2010/, $(foreach s, $(set_start), beta_%_$(s).csv fe_i_%_$(s).csv fe_j_%_$(s).csv)) | $(OOPR)
	sbatch -W $<
	rm select_optimal_ests_$*.sbatch

# These lines allow us to call a Matlab script from Make and run via sbatch; due to limitations
# in Matlab's formatting requirements for running from the command line, the simplest way is
# to explicitly construct and fill a new .sbatch file for each job.

# 200 multiple starting points for R >= 1
$(foreach rank, $(set_rank_ife), select_optimal_ests_$(rank).sbatch): select_optimal_ests_%.sbatch:
	cat matlab_slurm_header.sbatch > $@
	echo matlab -batch \"select_optimal_ests_from_multistarts $* 200 2010\" >> $@

# 1 starting point for R = 0
select_optimal_ests_0.sbatch:
	cat matlab_slurm_header.sbatch > $@
	echo matlab -batch \"select_optimal_ests_from_multistarts 0 1 2010\" >> $@


## TEMP RECIPES
# Converted LODES data in .csv format for reading into MATLAB
../temp/nyc2010_lodes.csv: convert_lodes_dta_csv.do ../input/nyc2010_lodes_wzero_wdelta.dta | $(OOPR)
	$(STATA) $<


# Multistart parameter estimates
.PRECIOUS: $(addprefix ../temp/multistarts/2010/,beta_%.csv fe_i_%.csv fe_j_%.csv)
$(addprefix ../temp/multistarts/2010/,beta_%.csv fe_i_%.csv fe_j_%.csv obj_%.csv): int_fe_est_%.sbatch int_fe_est.m ../temp/nyc2010_lodes.csv | $(OOPR) ../temp/multistarts/2010 ../temp/multistarts
	sbatch -W $<

# Argument for int_fe_est.m: rank, seed, MAX_STEPS, precision_beta, precision_FEs, year
int_fe_est_%.sbatch: | matlab_slurm_header.sbatch
	$(eval args := $(shell echo $(@F) | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	cat matlab_slurm_header.sbatch > $@
	echo matlab -batch \"int_fe_est $(args) 10000 $(set_commuting_elas_precision) $(set_fe_precision) 2010\" >> $@

## DIRECTORY RECIPE
../temp/multistarts/2010 ../temp/multistarts: 
	mkdir -p $@

## INPUT RECIPE
../input/nyc2010_lodes_wzero_wdelta.dta: ../input/%.dta: ../../nyc_baseline_data/output/%.dta | ../input
	ln -sf $< $@
	
	
