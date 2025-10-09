clear all

assert inlist(`1', 1.09, 1.18) // Magnitude of productivity shock

// calculate the statistics for both models, among 100 events
local num_sim = 100
set obs `num_sim'

local treated_tract = 1145
gen slope_cbm = .
gen slope_csp = .
gen intercept_cbm = .
gen intercept_csp = .
gen mse_cbm = .
gen mse_csp = .
tempfile df
save `df', replace

foreach idx of numlist 1/`num_sim'{

    import delimited "../input/DGP_`1'_`idx'_fixednu.csv", clear
    // Keep commuting flows to the treated tract 
    keep if id_j == `treated_tract'
    gen d_ell_dgp = x_ij_after - x_ij_before
    sort id_i 

    tempfile df_dgp
    save `df_dgp', replace

    // Load changes in commuting flows in treated pairs
    import delimited "../input/prediction_cbm_`1'_`idx'_treated_ell_change_fixednu.csv", clear
    tempfile df_cbm
    save `df_cbm', replace

    import delimited "../input/prediction_csp_`1'_`idx'_treated_ell_change_fixednu.csv",clear

    merge 1:1 id_i using `df_dgp', assert(match) nogen
    merge 1:1 id_i using `df_cbm', assert(match) keepusing(diff_cbm) nogen

    reg d_ell_dgp diff_cbm

    local slope_cbm = _b[diff_cbm]
    local intercept_cbm = _b[_cons]
    egen MSE_cbm = mean((d_ell_dgp - diff_cbm)^2)
    local mse_cbm = MSE_cbm[1]

    reg d_ell_dgp diff_csp
    local slope_csp = _b[diff_csp]
    local intercept_csp = _b[_cons]
    egen MSE_csp = mean((d_ell_dgp - diff_csp)^2)
    local mse_csp = MSE_csp[1]

    // Save sum stats into dataframe
    use `df', clear
    replace slope_cbm = `slope_cbm' if _n==`idx'
    replace slope_csp = `slope_csp' if _n==`idx'
    replace intercept_cbm = `intercept_cbm' if _n==`idx'
    replace intercept_csp = `intercept_csp' if _n==`idx'
    replace mse_cbm = `mse_cbm' if _n==`idx'
    replace mse_csp = `mse_csp' if _n==`idx'
    tempfile df
    save `df', replace

}

save "../temp/sum_labor_`1'_fixednu.dta", replace


