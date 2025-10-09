cap program drop gravity_nests_saveFE_time
cap program define gravity_nests_saveFE_time
syntax , nest_type(string)

    egen z = group(z_o z_d)

    * First stage of nested logit estimation: estimate PPMLE for inner nests
    ppmlhdfe X_ij log_delta, absorb(fe_i_ppml=i fe_j_ppml=j fe_z_ppml=z) d 
    predict X_ij_predicted
    tempfile tf1
    save `tf1'

    * Export epsilon / zeta
    clear
    set obs 1
    gen time_elasticity = _b[log_delta]
    local time_elasticity = _b[log_delta]
    export delimited time_elasticity using "../output/nyc2010_time_elasticity_`nest_type'.csv", replace novarnames

    * Save and normalize inner-nest origin FEs
    use i z_o fe_i_ppml using `tf1', clear
    collapse (firstnm) fe_i_ppml, by(i z_o)
    sort z_o i
    by z_o: gen fe_i_ppml_norm = fe_i_ppml - fe_i_ppml[1] /* rents FEs are estimated in logs */
    tempfile tf_FEi
    save `tf_FEi'
    clear 

    * Save and normalize inner-nest destination FEs
    use j z_d fe_j_ppml using `tf1', clear
    collapse (firstnm) fe_j_ppml, by(j z_d)
    sort z_d j
    by z_d: gen fe_j_ppml_norm = fe_j_ppml - fe_j_ppml[1] /* wages FEs are estimated in logs */
    tempfile tf_FEj
    save `tf_FEj'

    * Aggregate data to the level of nests
    use `tf1', clear
    merge m:1 i z_o using `tf_FEi', assert(master match) nogen
    merge m:1 j z_d using `tf_FEj', assert(master match) nogen

    gen delta_epslam = delta ^ `time_elasticity'
    gen IV_relative = delta_epslam * exp(fe_j_ppml_norm) * exp(fe_i_ppml_norm)
    collapse (sum) IV_relative=IV_relative X_z=X_ij, by(z_o z_d)
    gen log_IV_relative = log(IV_relative)

    * Second stage of nested logit estimation: estimate PPMLE for outer nests
    ppmlhdfe X_z log_IV_relative, absorb(fe_o_ppml=z_o fe_d_ppml=z_d) d 
    predict X_z_predicted
    tempfile tf2
    save `tf2'

    * Export the estimate of zeta
    clear
    set obs 1
    gen zeta = _b[log_IV_relative]
    local zeta _b[log_IV_relative]
    export delimited zeta using "../output/nyc2010_zeta_`nest_type'.csv", replace novarnames

    * Save and normalize outer-nest NTA origin FEs
    use z_o fe_o_ppml using `tf2', clear
    collapse (firstnm) fe_o_ppml, by(z_o)
    replace  fe_o_ppml = fe_o_ppml / `zeta' /* In the second stage, we estimate -(\alpha * \epsilon) * log(r_k). We multiply it by \zeta to make compatible with inner-nest estimates */
    tempfile tf_FEo
    save `tf_FEo'

    * Save and normalize outer-nest NTA destination FEs
    use z_d fe_d_ppml using `tf2', clear
    collapse (firstnm) fe_d_ppml, by(z_d)
    replace  fe_d_ppml = fe_d_ppml / `zeta' /* In the second stage, we estimate \epsilon * log(w_n). We multiply it by \zeta to make compatible with inner-nest estimates */
    tempfile tf_FEd
    save `tf_FEd'

    * Merge outer-nest origin FEs to inner-nest origin FEs
    use `tf_FEi', clear
    merge m:1 z_o using `tf_FEo', assert(master match) nogen
    replace fe_i_ppml = fe_i_ppml_norm + fe_o_ppml /* correct for origin-neighborhood-specific normalization of FEs */
    keep i z_o fe_i_ppml
    tostring i, replace format("%12.0f")
    label var fe_i_ppml "Residence tract fixed effect"
    save_data "../output/nyc2010_orig_time_`nest_type'.dta", key(i) replace log_replace

    * Merge outer-nest destination FEs to inner-nest destination FEs
    use `tf_FEj', clear
    merge m:1 z_d using `tf_FEd', assert(master match) nogen
    replace fe_j_ppml = fe_j_ppml_norm + fe_d_ppml /* correct for destination-neighborhood-specific normalization of FEs */
    keep j z_d fe_j_ppml
    tostring j, replace format("%12.0f")
    label var fe_j_ppml "Workplace tract fixed effect"
    save_data "../output/nyc2010_dest_time_`nest_type'.dta", key(j) replace log_replace

end
