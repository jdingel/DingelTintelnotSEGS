clear all

do "descriptive_stats_programs.do"

// distance data version
descriptive_stats using "../output/ACS_20062010_dist_within120km.dta", dataset("ACS20062010") 
descriptive_stats using "../output/ACS_20092013_dist_within120km.dta", dataset("ACS20092013") 
descriptive_stats using "../output/ACS_20112015_dist_within120km.dta", dataset("ACS20112015") 
matrix descriptive_stats = stats_ACS20062010\stats_ACS20092013\stats_ACS20112015
frmttable using "../output/descriptive_stats.tex", statmat(descriptive_stats) ///
		 ctitle("Dataset", "Zero Pairs", "Positive Pairs", "MOE \textgreater X (\%) ") rtitle("ACS 2006-2010"\ "ACS 2009-2013" \"ACS 2011-2015")  ///
		 tex frag sd(0) nocenter replace

asymmetriczeros using "../output/ACS_20062010_dist_within120km.dta", output("../output/ACS20062010_asymmetriczeros_120km.tex")
asymmetriczeros using "../output/ACS_20092013_dist_within120km.dta", output("../output/ACS20092013_asymmetriczeros_120km.tex")
asymmetriczeros using "../output/ACS_20112015_dist_within120km.dta", output("../output/ACS20112015_asymmetriczeros_120km.tex")

zero_prev using "../output/ACS_20062010_dist_within120km.dta", output("../output/ACS20062010_zeros_120km_slides.tex")
zero_prev using "../output/ACS_20092013_dist_within120km.dta", output("../output/ACS20092013_zeros_120km_slides.tex")
zero_prev using "../output/ACS_20112015_dist_within120km.dta", output("../output/ACS20112015_zeros_120km_slides.tex")

zero_persist, earlydata("../output/ACS_20062010_dist_within120km.dta") laterdata("../output/ACS_20112015_dist_within120km.dta") ///
 				outputfreq("../output/20062010_20112015_tabulatezeros_frequency.tex") ///
 				outputpct("../output/20062010_20112015_tabulatezeros_pct.tex")

// count fraction of county pairs with <=100 commuters
foreach df in 20062010 20092013 20112015 {
	use if X_ij !=0 using "../output/ACS_`df'_dist_within120km.dta",clear
	count if X_ij<=100
	local commute_lessthan_100 = `r(N)'
	count 
	local tot = `r(N)'
	local frac_lessthan_100 = `commute_lessthan_100'/`tot'
	assert inrange(`frac_lessthan_100',0.5,1)==1
}
shell echo More than half of the non-zero county pairs report fewer than 100 commuters, therefore representing the behavior of five or fewer respondents.% > ../output/ACS_frac_lessthan100.tex
