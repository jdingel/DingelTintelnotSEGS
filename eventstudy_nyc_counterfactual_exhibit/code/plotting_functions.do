cap program drop kdensitymaker

set scheme s2color
program define kdensitymaker

syntax, prime_slope(varname) prime_intercept(varname) comparison_slope(varname) comparison_intercept(varname) prime_legend(string) comparison_legend(string) ///
	xlab_left(numlist) xlab_right(numlist) fig_size(numlist) legend_pos(numlist) ///
	filename(string) bounds(string)
qui sum `prime_slope', d
local median_prime = `r(p50)'
qui sum `comparison_slope', d
local median_comparison = `r(p50)'
twoway	(kdensity `prime_slope' if inrange(`prime_slope', `bounds'), xline(`median_prime',lcolor(blue) lwidth(vthin)) xlab(`xlab_left'(1)`xlab_right',labsize(large)) lcol(blue)) ///
	(kdensity `prime_intercept' if inrange(`prime_intercept', `bounds'), lcol(blue) lpattern(dash)) ///
	(kdensity `comparison_slope' if inrange(`comparison_slope', `bounds'), xline(`median_comparison',lcolor(red) lwidth(vthin)) lcol(red)) ///
	(kdensity `comparison_intercept' if inrange(`comparison_intercept', `bounds'), lcol(red) lpattern(dash)) ///
	, graphregion(color(white)) legend(region(lstyle(none)) label(1 "`prime_legend': slope") label(2 "`prime_legend': intercept") label(3 "`comparison_legend': slope") label(4 "`comparison_legend': intercept")) ///
	legend(pos(`legend_pos') ring(0) col(1) size(medium) region(fcolor(none))) ///
	ytitle("Density",size(vlarge)) ylabel(0(0.5)2,gmax labsize(large)) xtitle("") xsize(`fig_size')
graph export "`filename'", replace as(eps) //Stata cannot detect file type when name contains periods.
end

cap program drop slope_kdensitymaker
program define slope_kdensitymaker

syntax, prime_slope(varname) comparison_slope(varname) prime_legend(string) comparison_legend(string) ///
	xlab_left(numlist) xlab_right(numlist) fig_size(numlist) legend_pos(numlist) ///
	filename(string) bounds(string)
qui sum `prime_slope', d
local median_prime = `r(p50)'
qui sum `comparison_slope', d
local median_comparison = `r(p50)'
twoway (kdensity `prime_slope' if inrange(`prime_slope', `bounds'), xline(`median_prime',lcolor(blue) lwidth(vthin)) xlab(`xlab_left'(1)`xlab_right',labsize(large)) lcol(blue)) ///
	(kdensity `comparison_slope' if inrange(`comparison_slope', `bounds'), xline(`median_comparison',lcolor(red) lwidth(vthin)) lcol(red)) ///
	, graphregion(color(white)) legend(region(lstyle(none)) label(1 "`prime_legend': slope") label(2 "`prime_legend': intercept") label(3 "`comparison_legend': slope") label(4 "`comparison_legend': intercept")) ///
	legend(pos(`legend_pos') ring(0) col(1) size(small) region(fcolor(none))) ///
	ytitle("Density",size(vlarge)) ylabel(0(0.5)2,gmax labsize(large)) xtitle("") xsize(`fig_size')
graph export "`filename'", replace as(eps) //Stata cannot detect file type when name contains periods.
end

cap program drop int_kdensitymaker
program define int_kdensitymaker
syntax, prime_intercept(varname) comparison_intercept(varname) prime_legend(string) comparison_legend(string) ///
	xlab_left(numlist) xlab_right(numlist) fig_size(numlist) legend_pos(numlist) ///
	filename(string) bounds(string)
qui sum `prime_intercept', d
local median_prime = `r(p50)'
qui sum `comparison_intercept', d
local median_comparison = `r(p50)'
twoway (kdensity `prime_intercept' if inrange(`prime_intercept', `bounds'), xline(`median_prime',lcolor(blue) lwidth(vthin)) lcol(blue) lpattern(dash)) ///
	(kdensity `comparison_intercept' if inrange(`comparison_intercept', `bounds'), xline(`median_comparison',lcolor(red) lwidth(vthin)) lcol(red) lpattern(dash)) ///
	, graphregion(color(white)) legend(region(lstyle(none)) label(1 "`prime_legend': intercept") label(2 "`comparison_legend': intercept")) ///
	legend(pos(`legend_pos') ring(0) col(1) size(small) region(fcolor(none))) ///
	ytitle("Density",size(vlarge)) ylabel(0(0.125)0.5,gmax labsize(large)) xtitle("") xsize(`fig_size')
graph export "`filename'", replace as(eps) //Stata cannot detect file type when name contains periods.
end

cap program drop stub_to_title
program define stub_to_title, rclass
syntax , stub(string)
if "`stub'" == "cbm_deltainf" {
	local title = "No extensive margin"
}
else if index("`stub'", "cbm_dist")!=0 {
	local title = "Distance Covariates-based"
}
else if index("`stub'", "cbm")!=0 {
	local title = "Covariates-based"
}
else if index("`stub'", "csp")!=0 {
	local title = "Calibrated-shares"
}
else if index("`stub'", "svd_diag")!=0 {
	local title = "diagonal-preserving SVD"
}
else if index("`stub'", "svd")!=0 {
	local title = "Low-rank SVD-based"
}
else if index("`stub'", "nnmf")!=0 {
	local title = "Low-rank NNMF-based"
}
else if index("`stub'", "ife_1")!=0 {
	local title = "Rank 1 IFE"
}
else if index("`stub'", "ife_2")!=0 {
	local title = "Rank 2 IFE"
}
else if index("`stub'", "ife_3")!=0 {
	local title = "Rank 3 IFE"
}
return local title = "`title'"
end