clear all
graph set window fontface "Garamond"
graph set eps fontface "Times"
local prefile_stub = subinstr("`3'", "_kdensity_exhibit.eps", "", .)
local prefile_stub2 = subinstr("`prefile_stub'", "_kdensity_notes.tex", "", .)
local temp1_stub = subinstr("`prefile_stub2'", "_slope", "", .)
local temp2_stub = subinstr("`temp1_stub'", "_intercept", "", .)
local file_stub = subinstr("`temp2_stub'", "../output/", "", .)
local baseline_stub = regexr("`file_stub'", "_vs_.*", "")
local comparison_stub = regexr("`file_stub'", ".*_vs_", "")
// making graphmaker program that takes in two variables, legend labels, 
run plotting_functions.do 
import delimited using `1', clear

rename (slope intercept mse) (baseline_slope baseline_intercept baseline_mse) 
tempfile temporary
save `temporary'
import delimited using `2', clear
rename (slope intercept mse) (comparison_slope comparison_intercept comparison_mse)

merge m:1 j using `temporary', assert(match) nogen

// turning stubs into figure titles
stub_to_title, stub("`comparison_stub'")
local model_2 = "`r(title)'"
stub_to_title, stub("`baseline_stub'")
local model_1 = "`r(title)'"

// counting outliers
local lowerlim = -3.0
local upperlim = 3.0
local lowerlim_int = -4.0
local upperlim_int = 4.0
foreach object in baseline comparison {
        count if inrange(`object'_slope,`lowerlim', `upperlim')==0
        local outliers_`object'_slope = `r(N)'
    }
foreach object in baseline comparison {
        count if inrange(`object'_intercept,`lowerlim_int', `upperlim_int')==0
        local outliers_`object'_intercept = `r(N)'
    }
local graph_fixedargs = "xlab_left(`lowerlim') xlab_right(`upperlim') fig_size(6) legend_pos(11)"

slope_kdensitymaker, prime_slope(baseline_slope) comparison_slope(comparison_slope) prime_legend(`model_1') comparison_legend(`model_2') `graph_fixedargs' filename("../output/`baseline_stub'_vs_`comparison_stub'_slope_kdensity_exhibit.eps") bounds(`lowerlim' ,`upperlim')

int_kdensitymaker,  prime_intercept(baseline_intercept) comparison_intercept(comparison_intercept) prime_legend(`model_1') comparison_legend(`model_2') `graph_fixedargs' filename("../output/`baseline_stub'_vs_`comparison_stub'_intercept_kdensity_exhibit.eps") bounds(`lowerlim_int' ,`upperlim_int') 

local model_1_lower = ustrlower("`model_1'")
local model_2_lower = ustrlower("`model_2'")
file open kdensitynote using "../output/`file_stub'_kdensity_notes.tex", write replace
if `outliers_baseline_slope'!=0 & `outliers_baseline_intercept'!=0 {
    file write kdensitynote "`outliers_baseline_slope' slope and `outliers_baseline_intercept' intercept coefficients are not depicted for the `model_1_lower' model."_n
}
if `outliers_baseline_slope'>1 & `outliers_baseline_intercept'==0 {
    file write kdensitynote "`outliers_baseline_slope' slope coefficients are not depicted for the `model_1_lower' model."_n
}
if `outliers_baseline_slope'==1 & `outliers_baseline_intercept'==0 {
    file write kdensitynote "One slope coefficient is not depicted for the `model_1_lower' model."_n
}
if `outliers_baseline_slope'==0 & `outliers_baseline_intercept'>1 {
    file write kdensitynote "`outliers_baseline_intercept' intercept coefficients are not depicted for the `model_1_lower' model."_n
}
if `outliers_baseline_slope'==0 & `outliers_baseline_intercept'==1 {
    file write kdensitynote "One intercept coefficient is not depicted for the `model_1_lower' model."_n
} 
if `outliers_comparison_slope'!=0 & `outliers_comparison_intercept'!=0 {
    file write kdensitynote "`outliers_comparison_slope' slope and `outliers_comparison_intercept' intercept coefficients are not depicted for the `model_2_lower' procedure."
}
if `outliers_comparison_slope'>1 & `outliers_comparison_intercept'==0 {
    file write kdensitynote "`outliers_comparison_slope' slope coefficients are not depicted for the `model_2_lower' procedure."
}
if `outliers_comparison_slope'==1 & `outliers_comparison_intercept'==0 {
    file write kdensitynote "One slope coefficient is not depicted for the `model_2_lower' procedure."
}
if `outliers_comparison_slope'==0 & `outliers_comparison_intercept'>1 {
    file write kdensitynote "`outliers_comparison_intercept' intercept coefficients are not depicted for the `model_2_lower' procedure."
}
if `outliers_comparison_slope'==0 & `outliers_comparison_intercept'==1 {
    file write kdensitynote "One intercept coefficient is not depicted for the `model_2_lower' procedure."
}
file close kdensitynote