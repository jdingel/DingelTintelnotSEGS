clear all

set scheme s2color
graph set window fontface "Garamond"
graph set eps fontface "Times"

import delimited using "../temp/AHQ2_Y_fixednu.csv", clear
gen pct_change = (total_real_income_change / total_real_income_before)*100
hist pct_change, graphregion(color(white)) freq lcolor(black) fcolor(none) start(0.38) width(0.005) ///
	xtitle("Predicted Percent Change in Output",size(large)) xlabel(,labsize(mlarge)) ytitle(,size(mlarge)) ylabel(,labsize(mlarge))
graph export "../output/AHQ2_fixednu_output_change_histogram.eps",replace

summarize pct_change, detail
local CI_90_top_string = string(`r(p90)',"%9.2f")
local CI_90_bottom_string = string(`r(p10)',"%9.2f")

shell echo "The 90\% confidence interval for the increase in aggregate output is `CI_90_bottom_string'\% to `CI_90_top_string'\%." > ../output/AHQ2_fixednu_output_change_CI.tex
