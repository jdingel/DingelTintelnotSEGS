cap program drop gravity_saveFE_time
cap program define gravity_saveFE_time
syntax using/, time_elasticity(string) [bilat_predict(string)] fe_i(string) fe_j(string)

// prepare data 
use `using',clear

/* // create dummies for different i=i
egen same_group = group(i)
replace same_group = 0 if i!=j
 */

// PPML regression
ppmlhdfe X_ij log_delta, absorb(fe_i_ppml=i fe_j_ppml=j) vce(cluster i j) d 
predict X_ij_predicted
tempfile tf0
save `tf0'

// Output
// time elasticity
clear
set obs 1
gen time_elasticity = _b[log_delta]
export delimited time_elasticity using `time_elasticity', replace novarnames
// FEs
if "`bilat_predict'"!= "" use i j delta X_ij_predicted fe_i_ppml fe_j_ppml using `tf0', clear
if "`bilat_predict'"!= "" save `bilat_predict', replace
use i fe_i_ppml using `tf0', clear
collapse (firstnm) fe_i_ppml, by(i) 
label var fe_i_ppml "Residence tract fixed effect"
compress
save_data `fe_i',key(i) replace log_replace
use j fe_j_ppml using `tf0', clear
collapse (firstnm) fe_j_ppml, by(j)
label var fe_j_ppml "Workplace tract fixed effect"
compress
save_data `fe_j',key(j) replace log_replace
end
