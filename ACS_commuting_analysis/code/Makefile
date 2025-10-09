SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
INPUTS  = $(foreach yr_range, 20062010 20092013 20112015, ../input/ACS_$(yr_range)_commuting.xlsx) ../input/sf12010countydistance100miles.csv
OUTPUTS = ../output/20062010_20112015_tabulatezeros_frequency.tex ../output/20062010_20112015_tabulatezeros_pct.tex ../output/descriptive_stats.tex \
			../output/ACS_frac_zero_to_pos.tex ../output/ACS_frac_pos_to_zero.tex ../output/ACS_frac_samebin_7190.tex ../output/heatmap_transition_matrix.eps ../output/hist_ACS_arbitrary_bin.eps ../output/heatmap_integer_0_100.eps \
			../output/counties_are_granular.tex \
			$(foreach yr_range, 20062010 20092013 20112015, ../output/ACS$(yr_range)_asymmetriczeros_120km.tex \
			../output/ACS$(yr_range)_zeros_120km_slides.tex ../output/ACS_$(yr_range)_dist_within120km.dta) \
			../output/ACS_frac_lessthan100.tex

## RECIPES
all: $(OUTPUTS)
include ../../generic.make

# GROUPED TARGET
$(foreach yr_range, 20062010 20092013 20112015, ../output/ACS_$(yr_range)_dist_within120km.dta): clean_stats_distance.do clean_stats_programs_distance.do $(INPUTS) | $(STATA_OOPR)
	$(STATA) $<
../output/ACS_frac_zero_to_pos.tex ../output/ACS_frac_pos_to_zero.tex ../output/ACS_frac_samebin_7190.tex ../output/heatmap_transition_matrix.eps ../output/hist_ACS_arbitrary_bin.eps ../output/heatmap_integer_0_100.eps: persistence.do ../output/ACS_20062010_dist_within120km.dta ../output/ACS_20112015_dist_within120km.dta | $(STATA_OOPR)
	$(STATA) $<
../output/counties_are_granular.tex ../output/ACS_20062010_histogram_lower90.eps: counties_are_granular.do ../output/ACS_20062010_dist_within120km.dta | $(STATA_OOPR)
	$(STATA) $<
../output/descriptive_stats.tex ../output/20062010_20112015_tabulatezeros_frequency.tex ../output/20062010_20112015_tabulatezeros_pct.tex $(foreach yr_range, 20062010 20092013 20112015, ../output/ACS$(yr_range)_asymmetriczeros_120km.tex ../output/ACS$(yr_range)_zeros_120km_slides.tex) ../output/ACS_frac_lessthan100.tex: descriptive_stats.do descriptive_stats_programs.do $(foreach yr_range, 20062010 20092013 20112015, ../output/ACS_$(yr_range)_dist_within120km.dta) | $(STATA_OOPR)
	$(STATA) $<
	
../input/ACS_%_commuting.xlsx: ../../initialdata/output/ACS_%_commuting.xlsx | ../input
	ln -sf $< $@
../input/sf12010countydistance100miles.csv: ../../initialdata/output/sf12010countydistance100miles.csv | ../input
	ln -sf $< $@


