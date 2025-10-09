SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
OUTPUTS_pricediff = $(foreach var, realr realw, ../output/scatter_gu_$(var)_simulation_fixednu_sumstats_diff_nested.eps)
OUTPUTS_emp_res   = $(foreach var, res emp, ../output/scatter_gu_$(var)_simulation_fixednu_nested.eps)
OUTPUTS_report    = $(foreach var, realr realw, ../output/report_gu_$(var)_fixednu_nested.tex)
OUTPUTS_report_AHQ2 = ../output/AHQ2_d_emp_p5_treated_nested.tex ../output/AHQ2_d_emp_p95_treated_nested.tex ../output/report_gu_sigchange_realr_p5_wrt_city_mean.tex ../output/report_gu_sigchange_realr_p95_wrt_city_mean.tex


all: $(OUTPUTS_pricediff) $(OUTPUTS_emp_res) $(OUTPUTS_report) $(OUTPUTS_report_AHQ2)
include ../../generic.make


## OUTPUT RECIPES
$(OUTPUTS_emp_res) $(OUTPUTS_pricediff) $(OUTPUTS_report) $(OUTPUTS_report_AHQ2): plot_granular_uncertainty_nested.do $(addprefix ../input/simulation_distribution_, orig_nested.csv dest_nested.csv) ../input/nyc2010_lodes_wzero_wdelta.dta | $(STATA_OOPR)
	$(STATA) $< $*

## INPUT RECIPE
../input/nyc2010_lodes_wzero_wdelta.dta: ../../nyc_baseline_data/output/nyc2010_lodes_wzero_wdelta.dta | ../input 
	ln -sf $< $@
../input/simulation_distribution_%.csv: ../../Amazon_fixednu_analyze_nested/output/simulation_distribution_%.csv | ../input
	ln -sf $< $@
