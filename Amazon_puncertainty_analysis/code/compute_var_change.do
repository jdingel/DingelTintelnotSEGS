clear all

local AHQ = 36081000700

// "collapse_counterfactuals" produces common outputs
cap program drop collapse_counterfactuals
program define collapse_counterfactuals

    local var = "`1'"
    assert inlist("`var'", "emp", "res", "wage", "rent")
    if inlist("`var'", "res", "rent") local key = "i"
    if inlist("`var'", "emp", "wage") local key = "j"

    // reformat
    forvalues i = 1/100 {
        if inlist("`var'", "emp", "res"){
            import delimited using "../input/cont_`var'_puncertainty_`i'.csv", clear
            gen `var'_change = `var'_a - `var'_b
        }

        if inlist("`var'", "wage", "rent"){
            local abbr = substr("`var'",1,1)
            import delimited using "../input/cont_`var'_puncertainty_`i'.csv", clear
            keep `key' real_`abbr'b real_`abbr'a
            gen `var'_change = 100 * (real_`abbr'a - real_`abbr'b) / real_`abbr'b
        }

        gen sim = `i'
        tempfile cont_`var'_puncertainty_`i'
        save `cont_`var'_puncertainty_`i'', replace
    }

    // append
    use `cont_`var'_puncertainty_1', clear
    forvalues i = 2/100 {
        append using `cont_`var'_puncertainty_`i''
    }

    collapse (p5) `var'_change_p5=`var'_change (p95) `var'_change_p95=`var'_change (mean) `var'_change_mean=`var'_change, by(`key') 
    keep `key' `var'_change_p5 `var'_change_p95 `var'_change_mean
    export delimited "../output/cont_`var'_puncertainty_pctile.csv", replace
end 


// prices
foreach price in "rent" "wage" {

    collapse_counterfactuals "`price'"

    * count significantly positive changes
    count if `price'_change_p5 > 0
    local count_pos_changes = string(`r(N)')
    shell echo "`count_pos_changes'" > "../output/cont_`price'_puncertainty_pos_changes.txt"
}


// quantities
foreach quant in "res" "emp" {

    collapse_counterfactuals "`quant'"

    * count insignificant changes
    count if `quant'_change_p5 <= 0 & `quant'_change_p95 >= 0
    local count_zero_CI = string(`r(N)')
    shell echo "`count_zero_CI'" > "../output/cont_`quant'_puncertainty_zero_in_ci_dest_count.txt"
}