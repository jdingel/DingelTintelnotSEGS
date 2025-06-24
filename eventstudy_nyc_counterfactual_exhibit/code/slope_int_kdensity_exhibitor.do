clear all
graph set window fontface "Garamond"
graph set eps fontface "Times"
local prefile_stub = subinstr("`3'", "_kdensity_exhibit.eps", "", .)
local file_stub = subinstr("`prefile_stub'", "../output/", "", .)
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
display "comparison_stub is `comparison_stub'"
stub_to_title, stub("`comparison_stub'")
local model_2 = "`r(title)'"
display "baseline_stub is `baseline_stub'"
stub_to_title, stub("`baseline_stub'")
local model_1 = "`r(title)'"

// counting outliers
local lowerlim = -3.0
local upperlim = 3.0
foreach coefficient in slope intercept {
    foreach object in baseline comparison {
        count if inrange(`object'_`coefficient',`lowerlim', `upperlim')==0
        local outliers_`object'_`coefficient' = `r(N)'
    }
}
local graph_fixedargs = "xlab_left(`lowerlim') xlab_right(`upperlim') fig_size(6) legend_pos(11)"

kdensitymaker, prime_slope(baseline_slope) prime_intercept(baseline_intercept) ///
    comparison_slope(comparison_slope) comparison_intercept(comparison_intercept) ///
    prime_legend(`model_1') comparison_legend(`model_2') `graph_fixedargs' ///
    filename(`3') bounds(`lowerlim' ,`upperlim') 

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
    file write kdensitynote "`outliers_comparison_intercept' intercept coefficients are not depicted for the `model_1_lower' model."_n
} 
if `outliers_comparison_slope'==0 & `outliers_baseline_intercept'==1 {
    file write kdensitynote "One intercept coefficient is not depicted for the `model_1_lower' model."_n
} 
file close kdensitynote