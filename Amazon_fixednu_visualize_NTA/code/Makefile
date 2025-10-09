SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
OUTPUTS_pricediff = $(foreach var, realr realw, ../output/scatter_gu_$(var)_simulation_fixednu_sumstats_diff_NTA.eps)
OUTPUTS_emp_res   = $(foreach var, res emp, ../output/scatter_gu_$(var)_simulation_fixednu_NTA.eps ../output/report_gu_$(var)_sigfchange_fixednu_NTA.tex)
OUTPUTS_report    = $(foreach var, realr realw, ../output/report_gu_$(var)_fixednu_NTA.tex)
OUTPUTS_report_AHQ2 = ../output/AHQ2_d_emp_p5_treatedNTA.tex ../output/AHQ2_d_emp_p95_treatedNTA.tex ../output/report_gu_NTA_sigchange_realr_p5_wrt_city_mean.tex ../output/report_gu_NTA_sigchange_realr_p95_wrt_city_mean.tex
all: $(OUTPUTS_pricediff) $(OUTPUTS_emp_res) $(OUTPUTS_report) $(OUTPUTS_report_AHQ2)
include ../../generic.make


## OUTPUT RECIPES
$(OUTPUTS_emp_res) $(OUTPUTS_pricediff) $(OUTPUTS_report) $(OUTPUTS_report_AHQ2): plot_granular_uncertainty_NTA.do $(shell grep -o '../input/[A-Za-z_0-9]*\.[a-z]*' plot_granular_uncertainty_NTA.do) | $(STATA_OOPR)
	$(STATA) $< $*

## INPUT RECIPES
../input/simulation_distribution_%.csv: ../../Amazon_fixednu_analyze_NTA/output/simulation_distribution_%.csv | ../input 
	ln -sf $< $@
../input/NTA_commutingflows_2010.dta: ../../nyc_NTA_employment_data/output/NTA_commutingflows_2010.dta | ../input
	ln -sf $< $@
