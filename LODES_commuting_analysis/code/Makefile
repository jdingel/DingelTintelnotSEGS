SHELL=bash
include ../../shell_functions.make

GEO_list = NYC
OUTPUTS = 	$(addprefix ../output/, $(foreach location, $(GEO_list), \
				$(location)_2010_number_tracts.tex) \
				histogram_NYC_2010_positive_w_shares.eps)

all: $(OUTPUTS)
clean:
	rm *.log
include ../../generic.make

#REGULAR RECIPES
$(addprefix ../output/, histogram_%_2010_positive.eps histogram_%_2010_withzeros.eps histogram_%_2010.eps %_2010_zeros_prev.tex %_2010_zeros_prev_slide.tex %_2010_number_tracts.tex histogram_%_2010_topcode.tex): tractpair_histograms.do ../input/lodes_%_2010.dta | $(OOPR)
	$(STATA) $< $* 2010
../output/histogram_%_2010_positive_w_shares.eps: tractpair_histograms_w_shares.do ../input/lodes_%_2010.dta | $(OOPR)
	$(STATA) $< $* 2010

#INPUTS
../input/lodes_NYC_2010.dta: ../../LODES_datapreparation/output/lodes_NYC_2010.dta | ../input
	ln -sf $< $@

