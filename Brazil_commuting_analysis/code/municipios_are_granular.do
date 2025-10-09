clear all

set scheme s2color
local dist_cutoff = 60

//Create all possible pairs
use i lat_i lon_i using "../output/commutematrix_posflows_2010_withdistances.dta", clear
collapse (firstnm) lat_i lon_i, by(i)
tempfile tf_i
save `tf_i'
rename (i lat_i lon_i) (j lat_j lon_j)
cross using `tf_i'
geodist lat_i lon_i lat_j lon_j, gen(dist_ij)
drop lat_i lon_i lat_j lon_j

keep if inrange(dist_ij,-0.1,`dist_cutoff')==1
merge 1:1 i j using "../output/commutematrix_posflows_2010_withdistances.dta", keep(master match) keepusing(X_ij)
recode X_ij .=0 if _merge==1
drop _merge

summarize X_ij
local commuters_total = string(`r(mean)'*`r(N)'/1000000,"%4.0f")
shell echo "there are `commuters_total' million commuters (with commutes less than `dist_cutoff' kilometers).%" > ../output/municipios_total_commuters_fragment.tex
summarize X_ij if i==j
local commuters_diagonal_total = string(`r(mean)'*`r(N)'/1000000,"%4.0f")
summarize X_ij if i!=j
local commuters_offdiagonal_total = string(`r(mean)'*`r(N)'/1000000,"%4.0f")
local commuters_offdiagonal_denom = string(`r(N)',"%7.0fc")
shell echo "There are `commuters_offdiagonal_total' million cross-municipality commuters between `commuters_offdiagonal_denom' pairs of municipalities." > ../output/municipios_are_granular.tex
summarize X_ij if i!=j
local commuters_offdiagonal_mean = string(`r(mean)',"%8.0f")
shell echo "Thus, the average off-diagonal element of the municipality-to-municipality commuting matrix has only `commuters_offdiagonal_mean' commuters." >> ../output/municipios_are_granular.tex

hist X_ij if i!=j, start(0) width(1) graphregion(color(white)) name(histogram1, replace) xtitle(Number of commuters)

qui summarize X_ij if i!=j, d
hist X_ij if i!=j & inrange(X_ij,0,`r(p95)'), start(0) width(1) graphregion(color(white)) name(histogram, replace) xtitle(Number of commuters)

qui summarize X_ij if i!=j, d
hist X_ij if i!=j & inrange(X_ij,1,`r(p95)'), start(0) width(1) graphregion(color(white)) name(histogram1, replace) xtitle(Number of commuters)
graph export "../output/Brazil_2010_histogram_lower95.eps", replace
