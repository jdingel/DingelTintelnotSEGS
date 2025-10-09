SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_rank_nnmf = $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50

all: ../output/eventstudy_nnmf_performance.tex
include ../../generic.make

../output/eventstudy_nnmf_performance.tex: nnmf_table_generator.R $(foreach rank, $(set_rank_nnmf), ../input/slope_int_MSE_all_nnmf_$(rank).csv) \
	eventstudy_nnmf_performance_skeleton.tex | $(OOPR)
	$(R) $< $(set_rank_nnmf)


../input/slope_int_MSE_all_nnmf_%.csv: ../../eventstudy_nyc_counterfactual_analyze/output/slope_int_MSE_all_nnmf_%.csv | ../input 
	ln -sf $< $@

