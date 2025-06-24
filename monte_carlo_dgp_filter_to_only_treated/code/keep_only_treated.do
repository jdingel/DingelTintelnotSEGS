clear all

import delimited using "`1'", clear
bys id_i: egen res = sum(x_ij_before)
bys id_j: egen emp = sum(x_ij_before)
keep if id_j == `2'
keep if res * emp != 0
gen d_ell_dgp = x_ij_after - x_ij_before

save_data "`3'", key(id_i) replace log_replace