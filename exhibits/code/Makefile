SHELL=bash

include ../../shell_functions.make

all: ../output/exhibits_maintext_fast.pdf ../output/exhibits_maintext.pdf

include ../../generic.make

../output/exhibits_maintext.pdf: exhibits_maintext.tex $(shell grep -o '../input/[A-Za-z0-9_\.]*\.[a-z]*' exhibits_maintext.tex) | ../output
	pdflatex -draftmode --shell-escape $<
	pdflatex $<
	rm $(addprefix $(basename $(notdir $@)), .aux .log .out)
	mv $(notdir $@) $@

../output/exhibits_maintext_fast.pdf: exhibits_maintext_fast.tex $(shell grep -o '../input/[A-Za-z0-9_\.]*\.[a-z]*' exhibits_maintext_fast.tex)  | ../output
	pdflatex -draftmode --shell-escape $<
	pdflatex $<
	rm $(addprefix $(basename $(notdir $@)), .aux .log .out)
	mv $(notdir $@) $@

.PHONY: clean
clean:
	rm *.log *.aux *.out

# Section 3
../input/histogram_NYC_2010_positive_w_shares.eps: ../../LODES_commuting_analysis/output/histogram_NYC_2010_positive_w_shares.eps | ../input
	ln -sf $< $@
../input/NYC_2010_number_tracts.tex: ../input/%.tex: ../../LODES_commuting_analysis/output/%.tex | ../input
	ln -sf $< $@
../input/gravity_comparisons_time_NYC_impute_simple.tex ../input/monte_carlo_lambdazero_cs_mean.tex: ../input/%.tex: ../../paper_elements/output/%.tex | ../input
	ln -sf $< $@
../input/%_continuum_labor_0_2.488905_1.09.eps: ../../monte_carlo_continuum_exhibit/output/%_continuum_labor_0_2.488905_1.09.eps | ../input
	ln -sf $< $@
../input/sumstats_continuum_%_0_1.09.tex: ../../paper_elements/output/sumstats_continuum_%_0_1.09.tex | ../input
	ln -sf $< $@
../input/sumstats_iid_labor_0_1.09.tex: ../input/%.tex: ../../paper_elements/output/%.tex | ../input
	ln -sf $< $@
../input/cbm_deltainf_vs_csp_sigma_4.0_kdensity_exhibit.eps ../input/cbm_deltainf_vs_csp_sigma_4.0_histogram_exhibit.eps: ../input/%.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/%.eps | ../input
	ln -sf $< $@
../input/cbm_pool_2008_2010_vs_csp_pool_2008_2010_kdensity_exhibit.eps ../input/cbm_pool_2008_2010_vs_csp_pool_2008_2010_histogram_exhibit.eps: ../input/%.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/%.eps | ../input
	ln -sf $< $@
../input/cbm_deltainf_vs_csp_sigma_4.0_kdensity_notes.tex ../input/cbm_pool_2008_2010_vs_csp_pool_2008_2010_kdensity_notes.tex ../input/cbm_nta_vs_csp_nta_kdensity_notes.tex: ../input/%.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/%.tex | ../input
	ln -sf $< $@
../input/cbm_sigma_4.0_vs_svd_%_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_sigma_4.0_vs_svd_%_exhibit.eps | ../input
	ln -sf $< $@
../input/cbm_sigma_4.0_vs_ife_%_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_sigma_4.0_vs_ife_%_exhibit.eps | ../input
	ln -sf $< $@
$(foreach sigma, 4.0, ../input/cbm_sigma_$(sigma)_vs_csp_sigma_$(sigma)_kdensity_exhibit.eps ../input/cbm_sigma_$(sigma)_vs_csp_sigma_$(sigma)_histogram_exhibit.eps ../input/cbm_sigma_$(sigma)_vs_csp_sigma_$(sigma)_kdensity_notes.tex): ../input/%: ../../eventstudy_nyc_counterfactual_exhibit/output/% | ../input
	ln -sf $< $@

# Section 5
../input/map_emp2010.png ../input/map_res2010.png ../input/map_cont_reschange.png ../input/map_cs_changeres.png ../input/map_cont_empchange.png ../input/map_empchange_cs.png: ../input/%.png: ../../Amazon_counterfactual_visualize/output/%.png  | ../input
	ln -sf $< $@
../input/map_cs_hat_realr.png ../input/map_cs_hat_realw.png: ../input/%.png: ../../Amazon_counterfactual_visualize/output/%.png | ../input
	ln -sf $< $@
../input/map_cont_change_realr.png ../input/map_cont_change_realw.png: ../input/%.png: ../../Amazon_counterfactual_visualize/output/%.png | ../input
	ln -sf $< $@
../input/report_gu_%_fixednu_sigma_4.0.tex: ../../Amazon_fixednu_visualize/output/report_gu_%_fixednu_sigma_4.0.tex | ../input
	ln -sf $< $@
../input/map_gu_%_fixednu_sigma_4.0.png: ../../Amazon_fixednu_visualize/output/map_gu_%_fixednu_sigma_4.0.png | ../input
	ln -sf $< $@
../input/AHQ2_d_emp_p%.tex: ../../Amazon_fixednu_analyze/output/AHQ2_d_emp_p%.tex | ../input 
	ln -sf $< $@
../input/outlier_note_gu_emp_fixednu_sigma_4.0.tex: ../../Amazon_fixednu_visualize/output/outlier_note_gu_emp_fixednu_sigma_4.0.tex | ../input 
	ln -sf $< $@
../input/fixednu_puncertainty_scatter_%.eps: ../../Amazon_puncertainty_fixednu_combined_visualize/output/fixednu_puncertainty_scatter_%.eps | ../input
	ln -sf $< $@
