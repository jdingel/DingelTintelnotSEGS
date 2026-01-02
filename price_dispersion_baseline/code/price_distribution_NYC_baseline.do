// 1. dispersion of prices at baseline (sd of the finite-model commuting equilibrium price across 100,000 simulations divided by the continuum-case rational expectation of that price)

set scheme s2color
// 2. absolute percentage-point deviation of realized finite-model price at baseline from the continuum-case rational expectations
// 3. compare price dispersion across simulation methods at baseline

clear all

// Function
cap program drop output_statistics
cap program define output_statistics
syntax, var(string)
	sum `var',d
	mat mat_`var' = (`r(mean)',`r(p5)',`r(p10)',`r(p25)',`r(p50)',`r(p75)',`r(p90)',`r(p95)')
end


// finite-model
// rent

import delimited "../input/simulation_100k_distribution_orig.csv",clear
gen id=_n
gen dispersion_rent = realrb_std/realrb_cont
hist dispersion_rent, graphregion(color(white)) xtitle("Rent",size(medlarge)) xlabel(,labsize(medlarge)) ylabel(,labsize(medlarge))
graph export "../output/hist_dispersion_rent.eps", replace

sum dispersion_rent,d
foreach i of numlist 5 50 95 {
	local rent_p`i' = string(`r(p`i')',"%4.3f")
	shell echo `rent_p`i''% > ../output/hist_dispersion_rent_p`i'.tex
}

output_statistics, var(dispersion_rent)

gen dev_CCRE_rent_mean = abs(realrb_mean-realrb_cont)*100/realrb_cont
sum dev_CCRE_rent_mean,d
local rent_p50 = string(`r(p50)',"%3.2f")
local rent_p95 = string(`r(p95)',"%3.2f")
shell echo `rent_p50'% > ../output/dev_CCRE_rent_p50.tex
shell echo `rent_p95'% > ../output/dev_CCRE_rent_p95.tex

// wage
import delimited "../input/simulation_100k_distribution_dest.csv",clear
gen id=_n
gen dispersion_wage = realwb_std/realwb_cont
hist dispersion_wage, graphregion(color(white)) xtitle("Wage",size(medlarge)) xlabel(,labsize(medlarge)) ylabel(,labsize(medlarge))
graph export "../output/hist_dispersion_wage.eps", replace

sum dispersion_wage,d
foreach i of numlist 5 50 95 {
	local wage_p`i' = string(`r(p`i')',"%4.3f")
	shell echo `wage_p`i''% > ../output/hist_dispersion_wage_p`i'.tex
}

output_statistics, var(dispersion_wage)

gen dev_CCRE_wage_mean = abs(realwb_mean-realwb_cont)*100/realwb_cont
sum dev_CCRE_wage_mean,d
local wage_p50 = string(`r(p50)',"%3.2f")
local wage_p95 = string(`r(p95)',"%3.2f")
shell echo `wage_p50'% > ../output/dev_CCRE_wage_p50.tex
shell echo `wage_p95'% > ../output/dev_CCRE_wage_p95.tex

// ex post regret simulation
import delimited "../input/dispersion_expost_wage.csv",clear
output_statistics, var(realwage)
import delimited "../input/dispersion_expost_rent.csv",clear
output_statistics, var(realrent)

mat output = mat_dispersion_wage\mat_realwage\mat_dispersion_rent\mat_realrent
frmttable using "../output/compare_dispersion.tex", statmat(output) ///
	ctitle("Simulation count" "mean" "p5" "p10" "p25" "p50" "75" "p90" "p95") ///
	rtitle("100,000"\"10"\"100,000"\"10") ///
	sd(3) tex frag nocenter replace
shell sed -i.bak 's/end{tabular}//g' "../output/compare_dispersion.tex"
rm ../output/compare_dispersion.tex.bak
