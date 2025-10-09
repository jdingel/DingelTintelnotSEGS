clear all

set scheme s2color
use "../output/commutematrix_posflows_2010_withdistances.dta", clear
tempfile tf0
save `tf0'

//Look for asymmetric zeros
use `tf0', clear
rename (i j X_ij) (j i X_ji)
merge 1:1 i j using `tf0', keep(using match)
recode X_ji .=0 if _merge==2
drop _merge
count if X_ji==0 & X_ij!=0
local X_ji_zero  = `r(N)'
count if X_ij!=0
local obs  = `r(N)'
local X_ji_zero_rate = string(100*`X_ji_zero'/`obs',"%2.0f")
display "$ \ell_{nk}=0$ for `X_ji_zero_rate'\% of municipio pairs with $ \ell_{kn}>0$."
file open outputfile using "../output/Brazil_commute_2010_asymmetriczeros.tex", write replace
file write outputfile "$ \ell_{nk}=0$ for `X_ji_zero_rate'\% of municipio pairs with $ \ell_{kn}>0$." _n
file close outputfile

//Create all possible pairs
use i lat_i lon_i using `tf0', clear
collapse (firstnm) lat_i lon_i, by(i)
tempfile tf_i
save `tf_i'
rename (i lat_i lon_i) (j lat_j lon_j)
cross using `tf_i'
geodist lat_i lon_i lat_j lon_j, gen(dist_ij)
drop lat_i lon_i lat_j lon_j

keep if inrange(dist_ij,-0.1,120)==1
merge 1:1 i j using `tf0', keep(master match) keepusing(X_ij)
recode X_ij .=0 if _merge==1

gen X_log_ij = log(X_ij)
gen dist_log_ij = log(dist_ij)

//What distance cutoff to use? Create "MRR Figure B.5" for Brazil.

cap program drop makegraphs
program define makegraphs

	syntax, dcut(integer)
	confirm variable i j X_ij_iszero X_log_ij dist_log_ij dist_ij

reghdfe dist_log_ij if dist_ij<`dcut' & i!=j, absorb(i j) resid
predict dist_log_resid_ij if dist_ij<`dcut', resid
reghdfe X_log_ij if dist_ij<`dcut' & i!=j, absorb(i j) resid
predict X_log_resid_ij if dist_ij<`dcut', resid
twoway (scatter X_log_resid_ij dist_log_resid_ij if dist_ij<`dcut' & i!=j, msize(tiny)) (lpoly X_log_resid_ij dist_log_resid_ij if dist_ij<`dcut' & i!=j, lpattern(dash)) (lfit X_log_resid_ij dist_log_resid_ij if dist_ij<`dcut' & i!=j, lpattern(dot)), graphregion(color(white)) name(Brazil_MRRfigB5_`dcut'km) xtitle(Log distance residual) ytitle(Log commuters residual) legend(off) subtitle(Non-zero commuting flows [<`dcut'km])
twoway (lpolyci X_ij_iszero dist_log_resid_ij if dist_ij<`dcut' & i!=j ), graphregion(color(white)) name(zero_prevalence_`dcut'km) subtitle("Share of municipio pairs with zero commuters") xtitle(Log distance residual) legend(off) note(Pairs less than `dcut'km apart)
twoway (lpolyci X_ij_iszero dist_log_ij if dist_ij<`dcut' & i!=j) (kdensity dist_log_ij if dist_ij<`dcut' & i!=j, yaxis(2) color(red)) (kdensity dist_log_ij if dist_ij<`dcut' & i!=j & X_ij_iszero!=1, yaxis(2) color(blue)), graphregion(color(white)) name(zero_prev_rawdist_kd_`dcut'km, replace) ytitle("Share of municipio pairs") ytitle("Density of municipio pairs", axis(2)) xtitle(Log distance) legend(order(2 "Share with zero" 3 "Density: All pairs" 4 "Density: Non-zero pairs")) note(Pairs less than `dcut'km apart) 
drop dist_log_resid_ij X_log_resid_ij

end

cap program drop zeros_prevalence
program define zeros_prevalence

	syntax, dcut(integer)
	confirm variable i j X_ij_iszero X_log_ij dist_log_ij dist_ij

	count if dist_ij<`dcut' & i!=j
	local denom = r(N)
	local denom_str = string(`denom',"%9.0gc")
	file open outputfile using "../output/Brazil_zeros_prev_`dcut'km.tex", write replace
	file write outputfile "There are `denom_str' municipio pairs with a distance less than `dcut' kilometers." _n
	file close outputfile
	
	count if X_ij_iszero == 1 & dist_ij<`dcut' & i!=j
	local numer = r(N)
	local numer_str = string(`numer',"%9.0gc")
	file open outputfile using "../output/Brazil_zeros_prev_`dcut'km.tex", write append
	file write outputfile "Of those pairs, `numer_str' have zero commuters between them." _n
	file close outputfile
	
	count if X_ij_iszero == 0 & dist_ij<`dcut' & i!=j
	local nonzero_str = string(r(N),"%9.0gc")
	file open outputfile using "../output/Brazil_zeros_prev_`dcut'km.tex", write append
	file write outputfile "Only `nonzero_str' have non-zero commuting flows." _n
	file close outputfile
	
	local percent = string(100*`numer'/`denom',"%3.0f")
	file open outputfile using "../output/Brazil_zeros_prev_`dcut'km_slide.tex", write replace
	file write outputfile "`percent'\% of municipio pairs within `dcut' km have zero commuters between them." _n
	file close outputfile

end

gen byte X_ij_iszero = (X_ij == 0)

foreach dcut in 45 60 120 {
	zeros_prevalence, dcut(`dcut')
	makegraphs, dcut(`dcut')
	graph combine Brazil_MRRfigB5_`dcut'km zero_prevalence_`dcut'km zero_prev_rawdist_kd_`dcut'km, graphregion(color(white))
	graph export "../output/Brazil_gravity_and_zeros_`dcut'.eps", replace
}

graph display zero_prev_rawdist_kd_60km
graph export "../output/Brazil_pairdensities_60.eps", replace

