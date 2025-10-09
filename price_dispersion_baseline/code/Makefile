SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
OUTPUTS = ../output/hist_dispersion_rent.eps ../output/hist_dispersion_rent_p5.tex ../output/hist_dispersion_rent_p50.tex ../output/hist_dispersion_rent_p95.tex \
		../output/hist_dispersion_wage.eps ../output/hist_dispersion_wage_p5.tex ../output/hist_dispersion_wage_p50.tex ../output/hist_dispersion_wage_p95.tex \
		../output/dev_CCRE_rent_p50.tex ../output/dev_CCRE_rent_p95.tex \
		../output/dev_CCRE_wage_p50.tex ../output/dev_CCRE_wage_p95.tex \
		../output/compare_dispersion.tex

## RECIPES
all: $(OUTPUTS)
include ../../generic.make

## OUTPUTS
$(OUTPUTS): price_distribution_NYC_baseline.do $(shell grep -o '[\\.]*/input/[A-Za-z0-9_\\.]*' price_distribution_NYC_baseline.do) | $(STATA_OOPR)
	$(STATA) $<

## INPUTS
../input/simulation_100k_distribution_orig.csv ../input/simulation_100k_distribution_dest.csv: ../input/%.csv: ../../Amazon_counterfactual_dispersion_simulation/output/%.csv | ../input
	ln -sf $< $@
../input/dispersion_expost_rent.csv ../input/dispersion_expost_wage.csv: ../input/%.csv: ../../ex_post_regret/output/%.csv | ../input
	ln -sf $< $@

