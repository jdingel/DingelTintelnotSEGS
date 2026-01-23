SHELL=bash

include ../../shell_functions.make

all: ../output/exhibits_maintext_fast.pdf ../output/exhibits_maintext.pdf ../output/exhibits.pdf ../output/exhibits_table.md ../output/paper.pdf

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

../output/exhibits.pdf: exhibits.tex DT.bib $(shell grep -o '../input/[A-Za-z0-9_\.]*\.[a-z]*' exhibits.tex)  | ../output
	pdflatex -draftmode --shell-escape $<
	bibtex $(basename $<)
	pdflatex -draftmode --shell-escape $<
	pdflatex $<
	rm $(addprefix $(basename $<), .aux .log .out .bbl .blg)
	mv $(notdir $@) $@

../output/exhibits_table.md: exhibit_table.sh exhibits.tex | ../output
	bash exhibit_table.sh

../output/paper.pdf: paper.tex DT.bib $(shell grep -o '\.\./input/[A-Za-z0-9_\.]*\.[a-z]*' paper.tex) | ../output
	pdflatex -draftmode --shell-escape $<
	bibtex $(basename $<)
	bibtex supp
	pdflatex -draftmode --shell-escape $<
	pdflatex $<
	rm $(addprefix $(basename $<), .aux .log .out .bbl .blg)
	rm supp.aux supp.bbl supp.blg
	mv $(notdir $@) $@

.PHONY: clean
clean:
	rm *.log *.aux *.out

## EXHIBITS INPUTS

# Section 3
../input/histogram_NYC_2010_positive_w_shares.eps: ../../LODES_commuting_analysis/output/histogram_NYC_2010_positive_w_shares.eps | ../input
	ln -sf $< $@
../input/NYC_2010_number_tracts.tex: ../input/%.tex: ../../LODES_commuting_analysis/output/%.tex | ../input
	ln -sf $< $@
../input/gravity_comparisons_time_NYC_impute_simple.tex: ../input/%.tex: ../../paper_elements/output/%.tex | ../input
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
../input/correlation_realr_csp_2008_2010.tex: ../../Amazon_counterfactual_compare/output/correlation_realr_csp_2008_2010.tex | ../input/
	ln -sf $< $@
../input/correlation_realw_csp_2008_2010.tex: ../../Amazon_counterfactual_compare/output/correlation_realw_csp_2008_2010.tex | ../input/
	ln -sf $< $@

# Appendices
../input/ACS_20062010_histogram_lower90.eps: ../../ACS_commuting_analysis/output/ACS_20062010_histogram_lower90.eps | ../input
	ln -sf $< $@
../input/heatmap_transition_matrix.eps: ../../ACS_commuting_analysis/output/heatmap_transition_matrix.eps | ../input
	ln -sf $< $@
../input/approx_ell_cbm_ife_1_comparison_scatterplot.eps: ../../Amazon_counterfactual_compare/output/approx_ell_cbm_ife_1_comparison_scatterplot.eps | ../input
	ln -sf $< $@
../input/approx_ell_cbm_svd_16_comparison_scatterplot.eps: ../../Amazon_counterfactual_compare/output/approx_ell_cbm_svd_16_comparison_scatterplot.eps | ../input
	ln -sf $< $@
../input/varsigma_rents_inf_4.0_CBM_notreat_comparison_scatterplot.eps: ../../Amazon_counterfactual_compare/output/varsigma_rents_inf_4.0_CBM_notreat_comparison_scatterplot.eps | ../input
	ln -sf $< $@
../input/varsigma_rents_inf_4.0_CSP_notreat_comparison_scatterplot.eps: ../../Amazon_counterfactual_compare/output/varsigma_rents_inf_4.0_CSP_notreat_comparison_scatterplot.eps | ../input
	ln -sf $< $@
../input/ell_nested_comparison_plots_0.25.eps: ../../Amazon_counterfactual_compare_NL_logit/output/ell_nested_comparison_plots_0.25.eps | ../input
	ln -sf $< $@
../input/map_cont_change_res_nested.png: ../../Amazon_counterfactual_compare_NL_logit/output/map_cont_change_res_nested.png | ../input
	ln -sf $< $@
../input/AHQ2_rent_change_CBM_vs_CSP_polyplot_log.eps: ../../Amazon_counterfactual_dist_exhibits/output/AHQ2_rent_change_CBM_vs_CSP_polyplot_log.eps | ../input
	ln -sf $< $@
../input/map_ife1_reschange_cutoff.png: ../../Amazon_counterfactual_map_approx/output/map_ife1_reschange_cutoff.png | ../input
	ln -sf $< $@
../input/AHQ2_d_emp_p5_sigma_4.0.tex: ../../Amazon_fixednu_analyze/output/AHQ2_d_emp_p5_sigma_4.0.tex | ../input
	ln -sf $< $@
../input/AHQ2_d_emp_p95_sigma_4.0.tex: ../../Amazon_fixednu_analyze/output/AHQ2_d_emp_p95_sigma_4.0.tex | ../input
	ln -sf $< $@
../input/AHQ2_emp_bydistbin_fixednu_sigma_4.0.eps: ../../Amazon_fixednu_visualize/output/AHQ2_emp_bydistbin_fixednu_sigma_4.0.eps | ../input
	ln -sf $< $@
../input/AHQ2_rents_bydistbin_fixednu_sigma_4.0.eps: ../../Amazon_fixednu_visualize/output/AHQ2_rents_bydistbin_fixednu_sigma_4.0.eps | ../input
	ln -sf $< $@
../input/AHQ2_residents_bydistbin_fixednu_sigma_4.0.eps: ../../Amazon_fixednu_visualize/output/AHQ2_residents_bydistbin_fixednu_sigma_4.0.eps | ../input
	ln -sf $< $@
../input/AHQ2_wages_bydistbin_fixednu_sigma_4.0.eps: ../../Amazon_fixednu_visualize/output/AHQ2_wages_bydistbin_fixednu_sigma_4.0.eps | ../input
	ln -sf $< $@
../input/map_gu_realwchange_fixednu_mean_change_sigma_4.0.png: ../../Amazon_fixednu_visualize/output/map_gu_realwchange_fixednu_mean_change_sigma_4.0.png | ../input
	ln -sf $< $@
../input/report_gu_emp_fixednu_sigma_Inf.tex: ../../Amazon_fixednu_visualize/output/report_gu_emp_fixednu_sigma_Inf.tex | ../input
	ln -sf $< $@
../input/report_gu_realr_fixednu_sigma_Inf.tex: ../../Amazon_fixednu_visualize/output/report_gu_realr_fixednu_sigma_Inf.tex | ../input
	ln -sf $< $@
../input/scatter_gu_emp_simulation_fixednu_sumstats_diff_sigma_Inf.eps: ../../Amazon_fixednu_visualize/output/scatter_gu_emp_simulation_fixednu_sumstats_diff_sigma_Inf.eps | ../input
	ln -sf $< $@
../input/scatter_gu_realr_simulation_fixednu_sumstats_diff_sigma_Inf.eps: ../../Amazon_fixednu_visualize/output/scatter_gu_realr_simulation_fixednu_sumstats_diff_sigma_Inf.eps | ../input
	ln -sf $< $@
../input/scatter_gu_res_simulation_fixednu_sumstats_diff_sigma_Inf.eps: ../../Amazon_fixednu_visualize/output/scatter_gu_res_simulation_fixednu_sumstats_diff_sigma_Inf.eps | ../input
	ln -sf $< $@
../input/scatter_gu_emp_simulation_fixednu_NTA.eps: ../../Amazon_fixednu_visualize_NTA/output/scatter_gu_emp_simulation_fixednu_NTA.eps | ../input
	ln -sf $< $@
../input/scatter_gu_realr_simulation_fixednu_sumstats_diff_NTA.eps: ../../Amazon_fixednu_visualize_NTA/output/scatter_gu_realr_simulation_fixednu_sumstats_diff_NTA.eps | ../input
	ln -sf $< $@
../input/scatter_gu_realw_simulation_fixednu_sumstats_diff_NTA.eps: ../../Amazon_fixednu_visualize_NTA/output/scatter_gu_realw_simulation_fixednu_sumstats_diff_NTA.eps | ../input
	ln -sf $< $@
../input/scatter_gu_res_simulation_fixednu_NTA.eps: ../../Amazon_fixednu_visualize_NTA/output/scatter_gu_res_simulation_fixednu_NTA.eps | ../input
	ln -sf $< $@
../input/scatter_gu_emp_simulation_fixednu_nested.eps: ../../Amazon_fixednu_visualize_nested/output/scatter_gu_emp_simulation_fixednu_nested.eps | ../input
	ln -sf $< $@
../input/scatter_gu_realr_simulation_fixednu_sumstats_diff_nested.eps: ../../Amazon_fixednu_visualize_nested/output/scatter_gu_realr_simulation_fixednu_sumstats_diff_nested.eps | ../input
	ln -sf $< $@
../input/scatter_gu_realw_simulation_fixednu_sumstats_diff_nested.eps: ../../Amazon_fixednu_visualize_nested/output/scatter_gu_realw_simulation_fixednu_sumstats_diff_nested.eps | ../input
	ln -sf $< $@
../input/scatter_gu_res_simulation_fixednu_nested.eps: ../../Amazon_fixednu_visualize_nested/output/scatter_gu_res_simulation_fixednu_nested.eps | ../input
	ln -sf $< $@
../input/CDP_2001_2002_migration_transition_matrix.tex: ../../CDP_replication/output/CDP_2001_2002_migration_transition_matrix.tex | ../input
	ln -sf $< $@
../input/histogram_state_migration_2001.eps: ../../CDP_replication/output/histogram_state_migration_2001.eps | ../input
	ln -sf $< $@
../input/DetroitUA_2013_2014_transition_matrix.tex: ../../LODES_commuting_analysis/output/DetroitUA_2013_2014_transition_matrix.tex | ../input
	ln -sf $< $@
../input/DetroitUA_2014_number_tracts.tex: ../../LODES_commuting_analysis/output/DetroitUA_2014_number_tracts.tex | ../input
	ln -sf $< $@
../input/MSP_2014_number_tracts.tex: ../../LODES_commuting_analysis/output/MSP_2014_number_tracts.tex | ../input
	ln -sf $< $@
../input/NYC_2013_2014_transition_matrix.tex: ../../LODES_commuting_analysis/output/NYC_2013_2014_transition_matrix.tex | ../input
	ln -sf $< $@
../input/histogram_DetroitUA_2014_positive_w_shares.eps: ../../LODES_commuting_analysis/output/histogram_DetroitUA_2014_positive_w_shares.eps | ../input
	ln -sf $< $@
../input/histogram_DetroitUA_2014_topcode.tex: ../../LODES_commuting_analysis/output/histogram_DetroitUA_2014_topcode.tex | ../input
	ln -sf $< $@
../input/histogram_MSP_2014_positive_w_shares.eps: ../../LODES_commuting_analysis/output/histogram_MSP_2014_positive_w_shares.eps | ../input
	ln -sf $< $@
../input/histogram_MSP_2014_topcode.tex: ../../LODES_commuting_analysis/output/histogram_MSP_2014_topcode.tex | ../input
	ln -sf $< $@
../input/tract_employmentcountsOD_36061005800.eps: ../../LODES_findemploymentspikes/output/tract_employmentcountsOD_36061005800.eps | ../input
	ln -sf $< $@
../input/tract_employmentcountsOD_36061008300.eps: ../../LODES_findemploymentspikes/output/tract_employmentcountsOD_36061008300.eps | ../input
	ln -sf $< $@
../input/tract_employmentcountsOD_notes.tex: ../../LODES_findemploymentspikes/output/tract_employmentcountsOD_notes.tex | ../input
	ln -sf $< $@
../input/scatter_destFE_NYC_2010_impute.eps: ../../LODES_gravity_analysis/output/scatter_destFE_NYC_2010_impute.eps | ../input
	ln -sf $< $@
../input/lodes_svd_normalized_scree_25.png: ../../commuting_matrix_visualization/output/lodes_svd_normalized_scree_25.png | ../input
	ln -sf $< $@
../input/lodes_visualizations_legend.png: ../../commuting_matrix_visualization/output/lodes_visualizations_legend.png | ../input
	ln -sf $< $@
../input/lodes_cbm_visualization.png: ../../downsize_PNGs/output/lodes_cbm_visualization.png | ../input
	ln -sf $< $@
../input/lodes_ife_1_visualization.png: ../../downsize_PNGs/output/lodes_ife_1_visualization.png | ../input
	ln -sf $< $@
../input/lodes_svd_16_visualization.png: ../../downsize_PNGs/output/lodes_svd_16_visualization.png | ../input
	ln -sf $< $@
../input/lodes_svd_200_visualization.png: ../../downsize_PNGs/output/lodes_svd_200_visualization.png | ../input
	ln -sf $< $@
../input/lodes_svd_5_visualization.png: ../../downsize_PNGs/output/lodes_svd_5_visualization.png | ../input
	ln -sf $< $@
../input/lodes_visualization.png: ../../downsize_PNGs/output/lodes_visualization.png | ../input
	ln -sf $< $@
../input/map_svd16_reschange_cutoff.png: ../../downsize_PNGs/output/map_svd16_reschange_cutoff.png | ../input
	ln -sf $< $@
../input/Chi2_parametric_dist.eps: ../../empirical_dist_multinomial_test/output/Chi2_parametric_dist.eps | ../input
	ln -sf $< $@
../input/Chi2_stat_value_cbmfit.tex: ../../empirical_dist_multinomial_test/output/Chi2_stat_value_cbmfit.tex | ../input
	ln -sf $< $@
../input/Chi2_stat_value_ifefit_1.tex: ../../empirical_dist_multinomial_test/output/Chi2_stat_value_ifefit_1.tex | ../input
	ln -sf $< $@
../input/Chi2_stat_value_ifefit_2.tex: ../../empirical_dist_multinomial_test/output/Chi2_stat_value_ifefit_2.tex | ../input
	ln -sf $< $@
../input/Chi2_stat_value_ifefit_3.tex: ../../empirical_dist_multinomial_test/output/Chi2_stat_value_ifefit_3.tex | ../input
	ln -sf $< $@
../input/MSE_parametric_dist.eps: ../../empirical_dist_multinomial_test/output/MSE_parametric_dist.eps | ../input
	ln -sf $< $@
../input/MSE_stat_value_svdfit_100.tex: ../../empirical_dist_multinomial_test/output/MSE_stat_value_svdfit_100.tex | ../input
	ln -sf $< $@
../input/MSE_stat_value_svdfit_16.tex: ../../empirical_dist_multinomial_test/output/MSE_stat_value_svdfit_16.tex | ../input
	ln -sf $< $@
../input/MSE_stat_value_svdfit_200.tex: ../../empirical_dist_multinomial_test/output/MSE_stat_value_svdfit_200.tex | ../input
	ln -sf $< $@
../input/MSE_stat_value_svdfit_500.tex: ../../empirical_dist_multinomial_test/output/MSE_stat_value_svdfit_500.tex | ../input
	ln -sf $< $@
../input/MSE_histogram_cont_cs_NTA.eps: ../../eventstudy_nyc_counterfactual_analyze_NTA/output/MSE_histogram_cont_cs_NTA.eps | ../input
	ln -sf $< $@
../input/density_slope_NTA_cont_cs.eps: ../../eventstudy_nyc_counterfactual_analyze_NTA/output/density_slope_NTA_cont_cs.eps | ../input
	ln -sf $< $@
../input/cbm_nta_vs_csp_nta_histogram_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_nta_vs_csp_nta_histogram_exhibit.eps | ../input
	ln -sf $< $@
../input/cbm_nta_vs_csp_nta_kdensity_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_nta_vs_csp_nta_kdensity_exhibit.eps | ../input
	ln -sf $< $@
../input/cbm_ntaorigin_0.25_vs_csp_ntaorigin_0.25_histogram_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_ntaorigin_0.25_vs_csp_ntaorigin_0.25_histogram_exhibit.eps | ../input
	ln -sf $< $@
../input/cbm_ntaorigin_0.25_vs_csp_ntaorigin_0.25_kdensity_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_ntaorigin_0.25_vs_csp_ntaorigin_0.25_kdensity_exhibit.eps | ../input
	ln -sf $< $@
../input/cbm_ntaorigin_0.75_vs_csp_ntaorigin_0.75_histogram_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_ntaorigin_0.75_vs_csp_ntaorigin_0.75_histogram_exhibit.eps | ../input
	ln -sf $< $@
../input/cbm_ntaorigin_0.75_vs_csp_ntaorigin_0.75_kdensity_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_ntaorigin_0.75_vs_csp_ntaorigin_0.75_kdensity_exhibit.eps | ../input
	ln -sf $< $@
../input/cbm_sigma_4.0_vs_ife_2_histogram_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_sigma_4.0_vs_ife_2_histogram_exhibit.eps | ../input
	ln -sf $< $@
../input/cbm_sigma_4.0_vs_ife_2_kdensity_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_sigma_4.0_vs_ife_2_kdensity_exhibit.eps | ../input
	ln -sf $< $@
../input/cbm_sigma_4.0_vs_ife_3_histogram_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_sigma_4.0_vs_ife_3_histogram_exhibit.eps | ../input
	ln -sf $< $@
../input/cbm_sigma_4.0_vs_ife_3_kdensity_exhibit.eps: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_sigma_4.0_vs_ife_3_kdensity_exhibit.eps | ../input
	ln -sf $< $@
../input/eventstudy_nnmf_performance.tex: ../../eventstudy_nyc_counterfactual_exhibit_SVD/output/eventstudy_nnmf_performance.tex | ../input
	ln -sf $< $@
../input/slope_eta_0.0028_csp_comparison_scatterplot.eps: ../../eventstudy_nyc_counterfactual_exhibit_local_inc_returns/output/slope_eta_0.0028_csp_comparison_scatterplot.eps | ../input
	ln -sf $< $@
../input/slope_eta_0.1_csp_comparison_scatterplot.eps: ../../eventstudy_nyc_counterfactual_exhibit_local_inc_returns/output/slope_eta_0.1_csp_comparison_scatterplot.eps | ../input
	ln -sf $< $@
../input/slope_1.1_4.0_comparison_scatterplot.eps: ../../eventstudy_nyc_counterfactual_varsigma_comparison/output/slope_1.1_4.0_comparison_scatterplot.eps | ../input
	ln -sf $< $@
../input/slope_inf_4.0_comparison_scatterplot.eps: ../../eventstudy_nyc_counterfactual_varsigma_comparison/output/slope_inf_4.0_comparison_scatterplot.eps | ../input
	ln -sf $< $@
../input/gravity_time_NYC_IFE.tex: ../../interactive_fe_estimation/output/gravity_time_NYC_IFE.tex | ../input
	ln -sf $< $@
../input/wage_deviation_density_winsorized.eps: ../../jensen_gap_exhibit/output/wage_deviation_density_winsorized.eps | ../input
	ln -sf $< $@
../input/MSE_ratio_histogram_continuum_prices_0_2.488905_1.09.eps: ../../monte_carlo_continuum_exhibit/output/MSE_ratio_histogram_continuum_prices_0_2.488905_1.09.eps | ../input
	ln -sf $< $@
../input/slopes_intercepts_densities_continuum_prices_0_2.488905_1.09.eps: ../../monte_carlo_continuum_exhibit/output/slopes_intercepts_densities_continuum_prices_0_2.488905_1.09.eps | ../input
	ln -sf $< $@
../input/montecarlo_MSE_ratio_histogram_1.09_fixednu.eps: ../../monte_carlo_fixednu_analysis/output/montecarlo_MSE_ratio_histogram_1.09_fixednu.eps | ../input
	ln -sf $< $@
../input/montecarlo_slopes_intercepts_densities_1.09_fixednu.eps: ../../monte_carlo_fixednu_analysis/output/montecarlo_slopes_intercepts_densities_1.09_fixednu.eps | ../input
	ln -sf $< $@
../input/MSE_ratio_histogram_iid_labor_0_2.488905_1.09.eps: ../../monte_carlo_iid_exhibit/output/MSE_ratio_histogram_iid_labor_0_2.488905_1.09.eps | ../input
	ln -sf $< $@
../input/slopes_intercepts_densities_iid_labor_0_2.488905_1.09.eps: ../../monte_carlo_iid_exhibit/output/slopes_intercepts_densities_iid_labor_0_2.488905_1.09.eps | ../input
	ln -sf $< $@
../input/monte_carlo_svd_performance.tex: ../../monte_carlo_svd_analysis/output/monte_carlo_svd_performance.tex | ../input
	ln -sf $< $@
../input/UScounties_descriptive_stats_120km.tex: ../../paper_elements/output/UScounties_descriptive_stats_120km.tex | ../input
	ln -sf $< $@
../input/compare_dispersion.tex: ../../paper_elements/output/compare_dispersion.tex | ../input
	ln -sf $< $@
../input/expost_results.tex: ../../paper_elements/output/expost_results.tex | ../input
	ln -sf $< $@
../input/gravity_outofsample.tex: ../../paper_elements/output/gravity_outofsample.tex | ../input
	ln -sf $< $@
../input/monte_carlo_result_mean.tex: ../../paper_elements/output/monte_carlo_result_mean.tex | ../input
	ln -sf $< $@
../input/monte_carlo_result_mean_continuum.tex: ../../paper_elements/output/monte_carlo_result_mean_continuum.tex | ../input
	ln -sf $< $@
../input/sumstats_continuum_prices_0_1.09.tex: ../../paper_elements/output/sumstats_continuum_prices_0_1.09.tex | ../input
	ln -sf $< $@
../input/hist_dispersion_rent.eps: ../../price_dispersion_baseline/output/hist_dispersion_rent.eps | ../input
	ln -sf $< $@
../input/hist_dispersion_rent_p5.tex: ../../price_dispersion_baseline/output/hist_dispersion_rent_p5.tex | ../input
	ln -sf $< $@
../input/hist_dispersion_rent_p50.tex: ../../price_dispersion_baseline/output/hist_dispersion_rent_p50.tex | ../input
	ln -sf $< $@
../input/hist_dispersion_rent_p95.tex: ../../price_dispersion_baseline/output/hist_dispersion_rent_p95.tex | ../input
	ln -sf $< $@
../input/hist_dispersion_wage.eps: ../../price_dispersion_baseline/output/hist_dispersion_wage.eps | ../input
	ln -sf $< $@
../input/hist_dispersion_wage_p5.tex: ../../price_dispersion_baseline/output/hist_dispersion_wage_p5.tex | ../input
	ln -sf $< $@
../input/hist_dispersion_wage_p50.tex: ../../price_dispersion_baseline/output/hist_dispersion_wage_p50.tex | ../input
	ln -sf $< $@
../input/hist_dispersion_wage_p95.tex: ../../price_dispersion_baseline/output/hist_dispersion_wage_p95.tex | ../input
	ln -sf $< $@
../input/svd_zeros.tex: ../../svd_zeros/output/svd_zeros.tex | ../input
	ln -sf $< $@

## WITHIN-TEXT INPUTS
../input/ACS_2001_data_cleaning_details.tex: ../../CDP_replication/output/ACS_2001_data_cleaning_details.tex | ../input
	ln -sf $< $@
$(addprefix ../input/, ACS20062010_asymmetriczeros_120km.tex ACS_frac_lessthan100.tex ACS_frac_pos_to_zero.tex ACS_frac_samebin_7190.tex ACS_frac_zero_to_pos.tex): ../input/%.tex: ../../ACS_commuting_analysis/output/%.tex | ../input
	ln -sf $< $@
../input/ACS_migration_2001_belowmean.tex: ../../CDP_replication/output/ACS_migration_2001_belowmean.tex | ../input
	ln -sf $< $@
../input/ACS_migration_2001_offdiag_mean.tex: ../../CDP_replication/output/ACS_migration_2001_offdiag_mean.tex | ../input
	ln -sf $< $@
../input/ACS_migration_2001_zeros.tex: ../../CDP_replication/output/ACS_migration_2001_zeros.tex | ../input
	ln -sf $< $@
../input/AHQ2_fixednu_output_change_CI.tex: ../../Amazon_fixednu_Y_CI/output/AHQ2_fixednu_output_change_CI.tex | ../input
	ln -sf $< $@
../input/Brazil_commute_2010_asymmetriczeros.tex: ../../Brazil_commuting_analysis/output/Brazil_commute_2010_asymmetriczeros.tex | ../input
	ln -sf $< $@
../input/DetroitUA_%.tex: ../../LODES_commuting_analysis/output/DetroitUA_%.tex | ../input
	ln -sf $< $@
../input/MSP_%.tex: ../../LODES_commuting_analysis/output/MSP_%.tex | ../input
	ln -sf $< $@
../input/NTA_boom_count_12.5pct.tex: ../../eventstudy_nyc_NTA_findemploymentspikes/output/NTA_boom_count_12.5pct.tex | ../input
	ln -sf $< $@
../input/NYC_2010_share5.tex: ../../LODES_commuting_analysis/output/NYC_2010_share5.tex | ../input
	ln -sf $< $@
../input/NYC_2010_times_imputed.tex: ../../LODES_gravity_dataprep/output/NYC_2010_times_imputed.tex | ../input
	ln -sf $< $@
../input/NYC_2010_zeros_prev_slide.tex: ../../LODES_commuting_analysis/output/NYC_2010_zeros_prev_slide.tex | ../input
	ln -sf $< $@
../input/NYC_outliers_Columbia_footnote.tex: ../../LODES_gravity_analysis/output/NYC_outliers_Columbia_footnote.tex | ../input
	ln -sf $< $@
../input/cbm_events_median_coefficients.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/cbm_events_median_coefficients.tex | ../input
	ln -sf $< $@
../input/cbm_mse_mean_fixednu_labor_1.09_fixednu.tex: ../../monte_carlo_fixednu_analysis/output/cbm_mse_mean_fixednu_labor_1.09_fixednu.tex | ../input
	ln -sf $< $@
../input/cbm_mse_mean_iid_labor_0_2.488905_1.09.tex: ../../monte_carlo_iid_exhibit/output/cbm_mse_mean_iid_labor_0_2.488905_1.09.tex | ../input
	ln -sf $< $@
../input/commuting_elasticity_ntaorigin_0.25.tex: ../../nyc_baseline_calibrate_exhibits/output/commuting_elasticity_ntaorigin_0.25.tex | ../input
	ln -sf $< $@
../input/commuting_elasticity_ntaorigin_0.75.tex: ../../nyc_baseline_calibrate_exhibits/output/commuting_elasticity_ntaorigin_0.75.tex | ../input
	ln -sf $< $@
../input/correlation_landendowment_ntaorigin_0.25.tex: ../../nyc_baseline_calibrate_exhibits/output/correlation_landendowment_ntaorigin_0.25.tex | ../input
	ln -sf $< $@
../input/correlation_landendowment_ntaorigin_0.75.tex: ../../nyc_baseline_calibrate_exhibits/output/correlation_landendowment_ntaorigin_0.75.tex | ../input
	ln -sf $< $@
../input/counties_are_granular.tex: ../../ACS_commuting_analysis/output/counties_are_granular.tex | ../input
	ln -sf $< $@
../input/csp_events_median_coefficients.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/csp_events_median_coefficients.tex | ../input
	ln -sf $< $@
../input/csp_mse_mean_fixednu_labor_1.09_fixednu.tex: ../../monte_carlo_fixednu_analysis/output/csp_mse_mean_fixednu_labor_1.09_fixednu.tex | ../input
	ln -sf $< $@
../input/csp_mse_mean_iid_labor_0_2.488905_1.09.tex: ../../monte_carlo_iid_exhibit/output/csp_mse_mean_iid_labor_0_2.488905_1.09.tex | ../input
	ln -sf $< $@
../input/csp_slope_median_continuum_labor_0_2.488905_1.09.tex: ../../monte_carlo_continuum_exhibit/output/csp_slope_median_continuum_labor_0_2.488905_1.09.tex | ../input
	ln -sf $< $@
../input/csp_slope_median_continuum_prices_0_2.488905_1.09.tex: ../../monte_carlo_continuum_exhibit/output/csp_slope_median_continuum_prices_0_2.488905_1.09.tex | ../input
	ln -sf $< $@
../input/csp_slope_median_fixednu_labor_1.09_fixednu.tex: ../../monte_carlo_fixednu_analysis/output/csp_slope_median_fixednu_labor_1.09_fixednu.tex | ../input
	ln -sf $< $@
../input/dev_CCRE_%.tex: ../../jensen_gap_exhibit/output/dev_CCRE_%.tex | ../input
	ln -sf $< $@
../input/ife_1_events_median_slope.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/ife_1_events_median_slope.tex | ../input
	ln -sf $< $@
../input/mse_ratio_median_continuum_labor_0_2.488905_1.09.tex: ../../monte_carlo_continuum_exhibit/output/mse_ratio_median_continuum_labor_0_2.488905_1.09.tex | ../input
	ln -sf $< $@
../input/mse_ratio_median_continuum_prices_0_2.488905_1.09.tex: ../../monte_carlo_continuum_exhibit/output/mse_ratio_median_continuum_prices_0_2.488905_1.09.tex | ../input
	ln -sf $< $@
../input/mse_ratio_median_fixednu_labor_1.09_fixednu.tex: ../../monte_carlo_fixednu_analysis/output/mse_ratio_median_fixednu_labor_1.09_fixednu.tex | ../input
	ln -sf $< $@
../input/MSE_stat_value_svdfit_%.tex : ../../empirical_dist_multinomial_test/output/MSE_stat_value_svdfit_%.tex | ../input
	ln -sf $< $@
../input/municipios_are_granular.tex: ../../Brazil_commuting_analysis/output/municipios_are_granular.tex | ../input
	ln -sf $< $@
../input/nyc2010_stddev_epslndelta.tex: ../../nyc_baseline_data/output/nyc2010_stddev_epslndelta.tex | ../input
	ln -sf $< $@
../input/NTA_boom_count_12.5pct_num.tex: ../../eventstudy_nyc_NTA_findemploymentspikes/output/NTA_boom_count_12.5pct_num.tex | ../input
	ln -sf $< $@
../input/municipios_total_commuters_fragment.tex: ../../Brazil_commuting_analysis/output/municipios_total_commuters_fragment.tex | ../input
	ln -sf $< $@
../input/optimal_rank_3_2010.txt: ../../interactive_fe_estimation/output/optimal_rank_3_2010.txt | ../input
	ln -sf $< $@
../input/predictions_contrast_slopes_intercepts_pool.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/predictions_contrast_slopes_intercepts_pool.tex | ../input
	ln -sf $< $@
../input/report_gu_%.tex: ../../Amazon_fixednu_visualize/output/report_gu_%.tex | ../input
	ln -sf $< $@
../input/report_gu_res_sigfchange_fixednu_NTA.tex: ../../Amazon_fixednu_visualize_NTA/output/report_gu_res_sigfchange_fixednu_NTA.tex | ../input
	ln -sf $< $@
../input/sd_montecarlo_fixednu_emp_changes_1.09.tex: ../../monte_carlo_fixednu_analysis/output/sd_montecarlo_fixednu_emp_changes_1.09.tex | ../input
	ln -sf $< $@
../input/sd_montecarlo_iid_empchanges_1.09.tex: ../../monte_carlo_iid_dgp_statistics/output/sd_montecarlo_iid_empchanges_1.09.tex | ../input
	ln -sf $< $@
../input/summary_MSE_NTA.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/summary_MSE_NTA.tex | ../input
	ln -sf $< $@
../input/summary_MSE_NTA_post_aggregated.tex: ../../eventstudy_nyc_counterfactual_analyze_NTA/output/summary_MSE_NTA_post_aggregated.tex | ../input
	ln -sf $< $@
../input/svd_16_events_median_slope.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/svd_16_events_median_slope.tex | ../input
	ln -sf $< $@
../input/text_Amazon_CBM_rent_topdecile.tex: ../../Amazon_counterfactual_visualize/output/text_Amazon_CBM_rent_topdecile.tex | ../input
	ln -sf $< $@
../input/text_Amazon_cs_rent_5pct.tex: ../../Amazon_counterfactual_visualize/output/text_Amazon_cs_rent_5pct.tex | ../input
	ln -sf $< $@
../input/text_Amazon_cs_rent_topdecile.tex: ../../Amazon_counterfactual_visualize/output/text_Amazon_cs_rent_topdecile.tex | ../input
	ln -sf $< $@
../input/text_CBM_win.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/text_CBM_win.tex | ../input
	ln -sf $< $@
../input/text_count_pop_pair_DetroitUA_2014.tex: ../../LODES_commuting_analysis/output/text_count_pop_pair_DetroitUA_2014.tex | ../input
	ln -sf $< $@
../input/text_count_pop_pair_MSP_2014.tex: ../../LODES_commuting_analysis/output/text_count_pop_pair_MSP_2014.tex | ../input
	ln -sf $< $@
../input/text_csp_pool_2008_2010_pos_frac.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/text_csp_pool_2008_2010_pos_frac.tex | ../input
	ln -sf $< $@
../input/text_expost_regret.tex: ../../ex_post_regret/output/text_expost_regret.tex | ../input
	ln -sf $< $@
../input/text_ife_1_vs_cbm_sigma_4.0_closest_to_1.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/text_ife_1_vs_cbm_sigma_4.0_closest_to_1.tex | ../input
	ln -sf $< $@
../input/text_ife_1_vs_cbm_sigma_4.0_lower_MSE.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/text_ife_1_vs_cbm_sigma_4.0_lower_MSE.tex | ../input
	ln -sf $< $@
../input/text_num_event.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/text_num_event.tex | ../input
	ln -sf $< $@
../input/text_pool_CBM_win.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/text_pool_CBM_win.tex | ../input
	ln -sf $< $@
../input/text_svd_16_vs_cbm_sigma_4.0_closest_to_1.tex: ../../eventstudy_nyc_counterfactual_exhibit/output/text_svd_16_vs_cbm_sigma_4.0_closest_to_1.tex | ../input
	ln -sf $< $@
