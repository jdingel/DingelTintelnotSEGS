SHELL=bash
include ../../shell_functions.make

set_sigma = 4.0 1.1 Inf
OUTPUTS_svd = ../output/approx_ell_cbm_svd_16_comparison_scatterplot.eps
OUTPUTS_ife = ../output/approx_ell_cbm_ife_1_comparison_scatterplot.eps
OUTPUTS_varsigma = $(foreach comp, 1.1_4.0 inf_4.0, $(foreach model, CBM CSP, ../output/varsigma_rents_$(comp)_$(model)_notreat_comparison_scatterplot.eps ../output/varsigma_rents_$(comp)_$(model)_wtreat_comparison_scatterplot.eps))
OUTPUTS_statement = $(foreach var, r w, ../output/correlation_real$(var)_csp_2008_2010.tex)

INPUTS_varsigma_rent = $(foreach sigma, $(set_sigma), $(foreach model, cbm csp, ../input/amazon_ctfl_tract_$(model)_sigma_$(sigma)_rent.csv))
INPUTS_varsigma_ell = $(foreach sigma, $(set_sigma), $(foreach model, cbm csp, ../input/amazon_ctfl_tract_$(model)_sigma_$(sigma)_ell.csv))

all: $(OUTPUTS_svd) $(OUTPUTS_ife) $(OUTPUTS_varsigma) $(OUTPUTS_statement)
include ../../generic.make

# Approx Output Recipes
../output/approx_ell_cbm_%_comparison_scatterplot.eps: compare_ell_predict_approx.do ../input/amazon_ctfl_tract_%_ell.csv ../input/amazon_ctfl_tract_cbm_sigma_4.0_ell.csv | $(STATA_OOPR)
	$(STATA) $^ $* $@

# 2008-2010 Comparison Recipes
../output/correlation_realr_csp_2008_2010.tex ../output/correlation_realw_csp_2008_2010.tex: compare_csp_2008_2010.do ../input/amazon_ctfl_tract_csp_2008_rent.csv ../input/amazon_ctfl_tract_csp_2008_wage.csv ../input/amazon_ctfl_tract_csp_sigma_4.0_rent.csv ../input/amazon_ctfl_tract_csp_sigma_4.0_wage.csv | $(STATA_OOPR)
	$(STATA) $^

# Varsigma Output Recipes
../output/varsigma_rents_%_comparison_scatterplot.eps: compare_rent_predict_varsigma.do  $(INPUTS_varsigma_rent) | $(STATA_OOPR)
	$(STATA) $< $(shell echo $* | tr '_' ' ') $@

#INPUT RECIPES
../input/amazon_%.csv: ../../Amazon_counterfactual_compute/output/amazon_%.csv | ../input
	ln -sf $< $@
