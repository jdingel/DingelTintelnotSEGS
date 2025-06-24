SHELL=bash
include ../../shell_functions.make

all: $(addprefix ../output/,$(addsuffix .tex,  \
	gravity_comparisons_time_NYC_impute_simple \
	sumstats_iid_labor_0_1.09 sumstats_continuum_labor_0_1.09 \
	)) replace

include ../../generic.make
#OUTPUT RECIPES
../output/gravity_comparisons_time_NYC_impute_simple.tex: ../input/NYC2010_gravity_time_impute_simple.tex | ../output
	head -1 $< | sed 's/hline/toprule/' >  ../output/temp.tex
	head -3 $< | tail -1 | sed 's/\&MLE/\&PPML\/MLE/' | sed 's/hline/midrule/' >>  ../output/temp.tex
	head -7 $< | tail -3 >>  ../output/temp.tex
	head -11 $< | tail -3 | sed 's/R-squared/Model fit ($$R^2$$ or pseudo-$$R^2$$)/' | sed 's/hline/bottomrule/' >>  ../output/temp.tex
	tail -1 $< >>  ../output/temp.tex
	mv ../output/temp.tex $@
../output/sumstats_iid_labor_0_1.09.tex ../output/sumstats_continuum_labor_0_1.09.tex: ../output/%: ../input/% | ../output
	sed 's/\\end{tabular}\\\\/\\end{tabular}/' $< > $@

#Phony recipe finds and replaces 'end{tabular}//' with 'end{tabular}' in all output files
.PHONY: replace
replace:
	sed -i '' 's/end{tabular}\\\\/end{tabular}/g' ../output/*.tex
#INPUT RECIPES
../input/NYC2010_gravity_time_impute_simple.tex: ../input/%.tex: ../../LODES_gravity_analysis/output/%.tex | ../input
	ln -sf $< $@
../input/sumstats_continuum_labor_0_1.09.tex: ../input/%.tex: ../../monte_carlo_continuum_exhibit/output/%.tex | ../input
	ln -sf $< $@
../input/sumstats_iid_labor_0_1.09.tex: ../../monte_carlo_iid_exhibit/output/sumstats_iid_labor_0_1.09.tex | ../input
	ln -sf $< $@
