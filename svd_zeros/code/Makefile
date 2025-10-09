SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
svd_ranks := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 500 1000 1500 2143
nnmf_ranks := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50

## RECIPES
all: ../output/svd_zeros.tex
include ../../generic.make

## OUTPUT RECIPES
../output/svd_zeros.tex: svd_zeros_table_generator.R svd_zeros_skeleton.tex\
	$(foreach rank, $(svd_ranks), ../input/zeros_share_$(rank).txt) \
	$(foreach rank, $(nnmf_ranks), ../input/zeros_share_nnmf_$(rank).txt) | $(OOPR)
	$(R) $< $(svd_ranks) 50

## INPUT RECIPES
../input/zeros_share_nnmf_%.txt: ../../nyc_baseline_data_nnmf/output/zeros_share_nnmf_%.txt | ../input
	ln -sf $< $@
../input/zeros_share_%.txt: ../../nyc_baseline_data_SVD/output/zeros_share_%.txt | ../input
	ln -sf $< $@

