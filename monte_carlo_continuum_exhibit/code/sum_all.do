clear all

tempfile df
save `df', empty

foreach pop of numlist 2.488905 5 12.5 25 50 125 250 2560 {
	foreach Lambda of numlist 0 0.1 0.25 0.5 1{
		if `Lambda'==0.1 local Lambda="0.1" // otherwise shown as .1 and stata cannot find the file
		if `Lambda'==0.25 local Lambda="0.25" // otherwise shown as .25 and stata cannot find the file
		if `Lambda'==0.5 local Lambda="0.5" // otherwise shown as .5 and stata cannot find the file
		use "../input/results_`Lambda'_`pop'.dta",clear
		gen pop=`pop'
		gen lambda=`Lambda'
		append using `df'
		tempfile df
		save `df'
	}
}
sort lambda pop

// output
// mean
mkmat mean_slope_cbm mean_slope_cs mean_mse_cbm mean_mse_cs, matrix(mat_output_mean)
frmttable using "../output/monte_carlo_result_mean_continuum.tex", statmat(mat_output_mean) ///
	ctitle("$\Lambda$" "\textit{I}" "Covariates-based" "Calibrated-shares" "Covariates-based" "Calibrated-shares") ///
	rtitle("0" "2.5" \ "0" "5" \ "0" "12.5" \ "0" "25" \ "0" "50" \ "0" "125" \ "0" "250" \ "0" "2560" \ ///
	"0.1" "2.5" \ "0.1" "5" \ "0.1" "12.5" \ "0.1" "25" \ "0.1" "50" \ "0.1" "125" \ "0.1" "250" \ "0.1" "2560" \ ///
	"0.25" "2.5" \ "0.25" "5" \ "0.25" "12.5" \ "0.25" "25" \ "0.25" "50" \ "0.25" "125" \ "0.25" "250" \ "0.25" "2560" \ ///
	"0.5" "2.5" \ "0.5" "5" \ "0.5" "12.5" \ "0.5" "25" \ "0.5" "50" \ "0.5" "125" \ "0.5" "250" \ "0.5" "2560" \ ///
	"1" "2.5" \ "1" "5" \ "1" "12.5" \ "1" "25" \ "1" "50" \ "1" "125" \ "1" "250" \ "1" "2560") ///
	sd(4) colj(rrcc) tex frag nocenter replace
shell sed -i '' 's/\\end{tabular}\\\\/\\end{tabular}/g' "../output/monte_carlo_result_mean_continuum.tex"
