SHELL=bash
include ../../shell_functions.make

all: $(addprefix ../output/,$(addsuffix .tex,  \
	monte_carlo_result_mean monte_carlo_result_mean_continuum gravity_outofsample UScounties_descriptive_stats_120km gravity_comparisons_time_NYC_impute_simple compare_dispersion expost_results \
	sumstats_iid_labor_0_1.09 sumstats_continuum_labor_0_1.09 sumstats_continuum_prices_0_1.09 \
	)) replace

include ../../generic.make
#OUTPUT RECIPES
../output/gravity_outofsample.tex: ../input/gravity_outofsample_NYC.tex ../input/gravity_outofsample_DetroitUA.tex | ../output
	head -1 ../input/gravity_outofsample_DetroitUA.tex >  ../output/temp.tex
	head -2 ../input/gravity_outofsample_DetroitUA.tex | tail -1 | sed 's/hline/toprule/' >>  ../output/temp.tex
	echo '\midrule' >>  ../output/temp.tex
	echo '\textbf{Panel A: Detroit}\\' >>  ../output/temp.tex
	grep -v '{tabular}' ../input/gravity_outofsample_DetroitUA.tex | grep -v 'values' | sed 's/\\hline//'  >>  ../output/temp.tex
	echo '\textbf{Panel B: NYC}\\' >>  ../output/temp.tex
	grep -v '{tabular}' ../input/gravity_outofsample_NYC.tex | grep -v 'values' | sed 's/\\hline//'  >>  ../output/temp.tex
	echo '\bottomrule' >>  ../output/temp.tex
	echo '\end{tabular}' >>  ../output/temp.tex
	mv ../output/temp.tex $@
../output/gravity_comparisons_time_NYC_impute_simple.tex: ../input/NYC2010_gravity_time_impute_simple.tex | ../output
	head -1 $< | sed 's/hline/toprule/' >  ../output/temp.tex
	head -3 $< | tail -1 | sed 's/\&MLE/\&PPML\/MLE/' | sed 's/hline/midrule/' >>  ../output/temp.tex
	head -7 $< | tail -3 >>  ../output/temp.tex
	head -11 $< | tail -3 | sed 's/R-squared/Model fit ($$R^2$$ or pseudo-$$R^2$$)/' | sed 's/hline/bottomrule/' >>  ../output/temp.tex
	tail -1 $< >>  ../output/temp.tex
	mv ../output/temp.tex $@
../output/monte_carlo_result_%.tex: ../input/monte_carlo_result_%.tex | ../output
	sed 's/\\noalign{\\smallskip}//g' $< | awk 'NR==1,/hline/{sub(/hline/, "toprule\n")} 1' | awk 'NR==1,/hline/{sub(/hline/, "midrule\n")} 1' | awk 'NR==1,/hline/{sub(/hline/, "bottomrule")} 1' | sed 's/end{tabular}\\\\/end{tabular}/' > ../output/temp.tex
	awk '/\\toprule/{print;print "& & \\multicolumn{2}{c}{Slope (mean)} & \\multicolumn{2}{c}{MSE (mean)} \\\\";next}1' ../output/temp.tex > ../output/temp2.tex && mv ../output/temp2.tex ../output/temp.tex
	awk 'FNR==NR{ if (/^0 &/) p=NR; next} 1; FNR==p{ print "\\midrule" }' ../output/temp.tex ../output/temp.tex > ../output/temp2.tex && mv ../output/temp2.tex ../output/temp.tex
	awk 'FNR==NR{ if (/^0.1 &/) p=NR; next} 1; FNR==p{ print "\\midrule" }' ../output/temp.tex ../output/temp.tex > ../output/temp2.tex && mv ../output/temp2.tex ../output/temp.tex
	awk 'FNR==NR{ if (/^0.25 &/) p=NR; next} 1; FNR==p{ print "\\midrule" }' ../output/temp.tex ../output/temp.tex > ../output/temp2.tex && mv ../output/temp2.tex ../output/temp.tex
	awk 'FNR==NR{ if (/^0.5 &/) p=NR; next} 1; FNR==p{ print "\\midrule" }' ../output/temp.tex ../output/temp.tex > ../output/temp2.tex && mv ../output/temp2.tex ../output/temp.tex
	sed 's/\\textit{I}/$$I$$/g' ../output/temp.tex > ../output/temp2.tex && mv ../output/temp2.tex ../output/temp.tex
	mv ../output/temp.tex $@
../output/expost_results.tex: ../input/expost_results.tex | ../output
	head -1 ../input/expost_results.tex >  ../output/temp.tex 
	echo '\\toprule' >>  ../output/temp.tex
	echo '& & \\multicolumn{5}{c}{Unconditional} & \\multicolumn{2}{c}{Conditional} \\\\' >>  ../output/temp.tex
	echo '& Share with & \\multicolumn{5}{c}{\\uline{\\hfill distribution \\hfill}} & \\multicolumn{2}{c}{\\uline{\\hfill distribution \\hfill}} \\\\' >>  ../output/temp.tex 
	echo ' $$s$$ & regret & p95 & p96 & p97 & p98 & p99 & Mean & Median \\\\' >>  ../output/temp.tex 
	echo '\\midrule' >>  ../output/temp.tex 
	head -2 ../input/expost_results.tex | tail -1 | sed 's/\\hline \\noalign{\\smallskip}/ /'  >>  ../output/temp.tex 
	head -11 ../input/expost_results.tex | tail -9 >>  ../output/temp.tex 
	echo '\\midrule' >>  ../output/temp.tex
	tail -2  ../input/expost_results.tex | head -1 >>  ../output/temp.tex
	tail -1 ../input/expost_results.tex | sed 's/\\noalign{\\smallskip}\\hline/\\bottomrule /' | sed 's/\\\\/ /' >> ../output/temp.tex 
	mv ../output/temp.tex $@
../output/compare_dispersion.tex: ../input/compare_dispersion.tex | ../output
	head -2 ../input/compare_dispersion.tex | sed 's/\\hline \\noalign{\\smallskip}/\\toprule /' >  ../output/temp.tex 
	echo '\\midrule' >>  ../output/temp.tex 
	echo 'Wage \\\' >>  ../output/temp.tex 
	head -4 ../input/compare_dispersion.tex | tail -2 | sed 's/\\noalign{\\smallskip}\\hline \\noalign{\\smallskip}/ /'  >>  ../output/temp.tex 
	echo '\\midrule' >>  ../output/temp.tex 
	echo 'Rent \\\' >>  ../output/temp.tex 
	tail -3 ../input/compare_dispersion.tex | sed 's/\\noalign{\\smallskip}\\hline/\\bottomrule /'>>  ../output/temp.tex 
	mv ../output/temp.tex $@
../output/UScounties_descriptive_stats_120km.tex: ../input/descriptive_stats.tex | ../output
	head -2 ../input/descriptive_stats.tex | sed 's/\\hline \\noalign{\\smallskip}/\\toprule /' >  ../output/temp.tex
	echo '\midrule' >>  ../output/temp.tex
	head -5 ../input/descriptive_stats.tex | tail -3 | sed 's/\\noalign{\\smallskip}\\hline \\noalign{\\smallskip}/ /' >>  ../output/temp.tex
	echo '\bottomrule' >>  ../output/temp.tex
	tail -1 ../input/descriptive_stats.tex | sed 's/\\noalign{\\smallskip}\\hline/ /' | sed 's/\\\\/ /' >>  ../output/temp.tex
	mv ../output/temp.tex $@
../output/sumstats_iid_labor_0_1.09.tex ../output/sumstats_continuum_labor_0_1.09.tex ../output/sumstats_continuum_prices_0_1.09.tex: ../output/%: ../input/% | ../output
	sed 's/\\end{tabular}\\\\/\\end{tabular}/' $< > $@

#phoney recipe finds and replaces 'end{tabular}//' with 'end{tabular}' in all output files
.PHONY: replace
replace:
	sed -i '' 's/end{tabular}\\\\/end{tabular}/g' ../output/*.tex
#INPUT RECIPES
../input/gravity_outofsample_NYC.tex ../input/gravity_outofsample_DetroitUA.tex: ../input/%.tex: ../../LODES_gravity_analysis/output/%.tex | ../input
	ln -sf $< $@
../input/descriptive_stats.tex: ../input/%.tex: ../../ACS_commuting_analysis/output/%.tex | ../input
	ln -sf $< $@
../input/NYC2010_gravity_time_impute_simple.tex: ../input/%.tex: ../../LODES_gravity_analysis/output/%.tex | ../input
	ln -sf $< $@
../input/monte_carlo_result_mean.tex: ../input/%.tex: ../../monte_carlo_iid_exhibit/output/%.tex | ../input
	ln -sf $< $@
../input/monte_carlo_result_mean_continuum.tex ../input/sumstats_continuum_labor_0_1.09.tex ../input/sumstats_continuum_prices_0_1.09.tex: ../input/%.tex: ../../monte_carlo_continuum_exhibit/output/%.tex | ../input
	ln -sf $< $@
../input/sumstats_iid_labor_0_1.09.tex: ../../monte_carlo_iid_exhibit/output/sumstats_iid_labor_0_1.09.tex | ../input
	ln -sf $< $@
../input/expost_results.tex: ../input/%.tex: ../../ex_post_regret/output/%.tex | ../input
	ln -sf $< $@
../input/compare_dispersion.tex: ../../price_dispersion_baseline/output/compare_dispersion.tex | ../input
	ln -sf $< $@
