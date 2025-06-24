clear all

set scheme s2color
graph set window fontface "Garamond"
graph set eps fontface "Times"
// making graphmaker program that takes in two variables, legend labels, 
run plotting_functions.do 
cap program drop histogrammaker
program define histogrammaker

syntax , ratio(varname) x_axis_title(string) filename(string)
if strpos("`filename'", "cbm_deltainf_vs_csp_sigma_4.0") > 0 | strpos("`filename'", "cbm_sigma_4.0_vs_csp_sigma_4.0") > 0{
    histogram `ratio', lcolor(black) fcolor(none) xscale(range(0.1 1.3)) width(0.05) fraction ///
    graphregion(color(white)) ///
    xlabel(#13,labsize(large)) ylabel(,labsize(large)) ///
    xtitle("`x_axis_title'", size(large)) ytitle(,size(large)) legend(off)
}
else{
    egen min_ratio = min(`ratio')
    local floor = 0.1 * floor(min_ratio/0.1)
    sum `ratio', d
    local xmax = ceil(`r(max)'*10)/10
    local xmin = floor(`r(min)'*10)/10
    local stepsize = round((`xmax' - `xmin')/20, .025)
    if `stepsize' == 0 {
        local stepsize = 0.025
    }
    if inrange(`stepsize', 0.06,.14) { //round to 0.1 if appropriate
        local stepsize = 0.1
    }
    twoway (hist `ratio', lcolor(black) fcolor(none) start(`floor')  ///
        width(`stepsize') fraction), graphregion(color(white)) ///
        xlabel(#13,labsize(large)) ylabel(,labsize(large)) ///
        xtitle("`x_axis_title'", size(large)) ytitle(,size(large)) legend(off)
}

graph export "`filename'", replace as(eps) //Stata cannot detect file type when name contains periods.

end
// creating histogram with histogrammaker program
import delimited using `1', clear
rename (slope intercept mse) (baseline_slope baseline_intercept baseline_mse) 
tempfile temporary
save `temporary'
import delimited using `2', clear
rename (slope intercept mse) (comparison_slope comparison_intercept comparison_mse)
merge m:1 j using `temporary', assert(match) nogen
gen MSE_ratio = baseline_mse / comparison_mse
// extracting file stubs from file names
local prefile_stub = subinstr("`3'", "_histogram_exhibit.eps", "", .)
local file_stub = subinstr("`prefile_stub'", "../output/", "", .)
local baseline_stub = regexr("`file_stub'", "_vs_.*", "")
local comparison_stub = regexr("`file_stub'", ".*_vs_", "")
// using stubs to create graph titles
stub_to_title, stub("`comparison_stub'")
local model_2 = "`r(title)'"
display "baseline_stub is `baseline_stub'"
stub_to_title, stub("`baseline_stub'")
local model_1 = "`r(title)'"
local xaxistitle = "`model_1' MSE / `model_2' MSE"

histogrammaker, ratio(MSE_ratio) x_axis_title(`xaxistitle') filename(`3')
