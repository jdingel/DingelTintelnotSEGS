SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_rank := $(shell seq 1 1 6) $(shell seq 8 2 20) 15 50 100 200 500 1000 1500 2143


## RECIPES
all: $(foreach rank, $(set_rank), ../output/nyc_2010_levels_tracttotract_approx_svd_$(rank).dta.zip ../output/zeros_share_$(rank).txt)

include ../../generic.make

.INTERMEDIATE: $(foreach rank, $(set_rank), ../temp/labor_b_approx_svd_$(rank).csv)


## OUTPUT RECIPE
../output/zeros_share_%.txt ../temp/labor_b_approx_svd_%.csv: labor_approximation.jl $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' labor_approximation.jl) | $(OOPR) $(JULIA_OOPR)
	$(eval arg := $(shell echo $@ | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'))
	$(JULIA) $< $(arg)
$(foreach rank, $(set_rank), ../output/nyc_2010_levels_tracttotract_approx_svd_$(rank).dta.zip): ../output/%.zip: ../temp/%
	zip $@ $<
../temp/nyc_2010_levels_tracttotract_approx_svd_%.dta : ../input/convert_labor_b_to_dta.do ../temp/labor_b_approx_svd_%.csv | $(OOPR)
	 $(STATA) --no-job-name $^ $@


## INPUT RECIPES
../input/nyc2010_lodes_wzero_wdelta.dta: ../input/%.dta: ../../nyc_baseline_data/output/%.dta | ../input
	ln -sf $< $@
../input/SVD_funcs.jl: ../input/%.jl: ../../SVD_functions/code/SVD_funcs.jl | ../input 
	ln -sf $< $@
../input/convert_labor_b_to_dta.do: ../input/%.do: ../../common_scripts/code/%.do | ../input
	ln -sf $< $@
