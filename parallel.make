SHELL=bash
THREADS = 56

all:
	echo Running using $(THREADS) parallel threads for intensive tasks.
	$(MAKE) -C CDP_replication/code
	$(MAKE) -C ACS_commuting_analysis/code
	$(MAKE) -C Amazon_compute_dist_to_treated/code
	$(MAKE) -C Brazil_commuting_analysis/code
	$(MAKE) -C nyc_NTA_crosswalk/code
	$(MAKE) -C LODES_datapreparation/code -j $(THREADS)
	$(MAKE) -C nyc_baseline_data/code
	$(MAKE) -C LODES_commuting_analysis/code
	$(MAKE) -C LODES_findemploymentspikes/code
	$(MAKE) -C LODES_gravity_dataprep/code
	$(MAKE) -C nyc_NTA_aggregate_baseline_wages/code
	$(MAKE) -C nyc_NTA_employment_data/code
	$(MAKE) -C Amazon_puncertainty_baseline_data/code -j $(THREADS)
	$(MAKE) -C distance_based_delta_baseline_data/code
	$(MAKE) -C nyc_baseline_data_nests/code
	$(MAKE) -C nyc_baseline_data_nnmf/code -j $(THREADS)
	$(MAKE) -C nyc_baseline_data_SVD/code -j $(THREADS)
	$(MAKE) -C LODES_gravity_analysis/code
	$(MAKE) -C nyc_baseline_data_NTA/code
	$(MAKE) -C eventstudy_nyc_NTA_findemploymentspikes/code
	$(MAKE) -C eventstudy_nyc_observed_changes/code
	$(MAKE) -C Amazon_puncertainty_gravity/code -j $(THREADS)
	$(MAKE) -C svd_zeros/code
	$(MAKE) -C interactive_fe_estimation/code -j $(THREADS)
	$(MAKE) -C Amazon_puncertainty_calibrate/code -j $(THREADS)
	$(MAKE) -C commuting_matrix_visualization/code
	$(MAKE) -C interactive_fe_reformat/code
	$(MAKE) -C Amazon_puncertainty_compute/code -j $(THREADS)
	$(MAKE) -C empirical_dist_multinomial_test/code -j $(THREADS)
	$(MAKE) -C nyc_baseline_calibrate/code -j $(THREADS)
	$(MAKE) -C monte_carlo_iid_dgp/code -j $(THREADS)
	$(MAKE) -C nyc_baseline_calibrate_exhibits/code
	$(MAKE) -C nyc_baseline_compute/code
	$(MAKE) -C monte_carlo_continuum_compute/code -j $(THREADS)
	$(MAKE) -C monte_carlo_SVD_approx/code -j $(THREADS)
	$(MAKE) -C baseline_models_foreha/code -j $(THREADS)
	$(MAKE) -C ex_post_regret/code -j $(THREADS)
	$(MAKE) -C jensen_gap_simulate/code -j $(THREADS)
	$(MAKE) -C monte_carlo_dgp_filter_to_only_treated/code -j $(THREADS)
	$(MAKE) -C monte_carlo_iid_predictions/code -j $(THREADS)
	$(MAKE) -C monte_carlo_fixednu_predictions/code -j $(THREADS)
	$(MAKE) -C Amazon_counterfactual_compute/code -j $(THREADS)
	$(MAKE) -C eventstudy_nyc_counterfactual_simultaneous_shock_solver/code ../temp/simultaneous_shock_cbm.jld2 ../temp/simultaneous_shock_csp.jld2
	$(MAKE) -C eventstudy_nyc_counterfactual_simultaneous_shock_solver/code -j $(THREADS)
	$(MAKE) -C jensen_gap_exhibit/code
	$(MAKE) -C monte_carlo_iid_dgp_statistics/code
	$(MAKE) -C monte_carlo_continuum_predictions/code -j $(THREADS)
	$(MAKE) -C monte_carlo_iid_analysis/code
	$(MAKE) -C monte_carlo_svd_predictions/code -j $(THREADS)
	$(MAKE) -C monte_carlo_fixednu_analysis/code
	$(MAKE) -C Amazon_counterfactual_dist_exhibits/code
	$(MAKE) -C Amazon_counterfactual_compare/code
	$(MAKE) -C Amazon_counterfactual_compare_NL_logit/code
	$(MAKE) -C Amazon_counterfactual_compute_prob/code
	$(MAKE) -C Amazon_counterfactual_dispersion_simulation/code -j $(THREADS)
	$(MAKE) -C Amazon_counterfactual_map_approx/code
	$(MAKE) -C Amazon_fixednu_simulate/code -j $(THREADS)
	$(MAKE) -C Amazon_fixednu_simulate_nested/code -j $(THREADS)
	$(MAKE) -C Amazon_fixednu_simulate_NTA/code -j $(THREADS)
	$(MAKE) -C Amazon_puncertainty_analysis/code
	$(MAKE) -C eventstudy_nyc_counterfactual_compute_simultaneous/code -j $(THREADS)
	$(MAKE) -C monte_carlo_continuum_analysis/code -j $(THREADS)
	$(MAKE) -C monte_carlo_iid_exhibit/code
	$(MAKE) -C Amazon_counterfactual_visualize/code
	$(MAKE) -C price_dispersion_baseline/code
	$(MAKE) -C downsize_PNGs/code
	$(MAKE) -C Amazon_fixednu_Y_CI/code -j $(THREADS)
	$(MAKE) -C Amazon_fixednu_analyze_nested/code
	$(MAKE) -C Amazon_fixednu_analyze_NTA/code
	$(MAKE) -C eventstudy_nyc_counterfactual_analyze/code
	$(MAKE) -C eventstudy_nyc_counterfactual_analyze_NTA/code
	$(MAKE) -C monte_carlo_continuum_exhibit/code
	$(MAKE) -C Amazon_puncertainty_fixednu_combined_visualize/code
	$(MAKE) -C Amazon_fixednu_visualize/code
	$(MAKE) -C Amazon_fixednu_visualize_nested/code
	$(MAKE) -C Amazon_fixednu_visualize_NTA/code
	$(MAKE) -C eventstudy_nyc_counterfactual_exhibit/code
	$(MAKE) -C eventstudy_nyc_counterfactual_exhibit_local_inc_returns/code
	$(MAKE) -C eventstudy_nyc_counterfactual_exhibit_SVD/code
	$(MAKE) -C eventstudy_nyc_counterfactual_varsigma_comparison/code
	$(MAKE) -C monte_carlo_svd_analysis/code -j $(THREADS)
	$(MAKE) -C paper_elements/code
	$(MAKE) -C exhibits/code
