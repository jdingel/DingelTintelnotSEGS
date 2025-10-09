clear all

* Define datasets and output files
local vars "wage rent"
local base2008 "../input/amazon_ctfl_tract_csp_2008_"
local base2010 "../input/amazon_ctfl_tract_csp_sigma_4.0_"
local output "../output/correlation_real"

foreach v of local vars {
    local l = substr("`v'",1,1)
    clear
    * 2008 data
    import delimited using "`base2008'`v'.csv", clear
    if "`v'" == "wage" drop if j == 36081000700
    rename hat_real`l' `l'2008
    drop hat_*
    tempfile tmp
    save `tmp'

    * 2010 data
    import delimited using "`base2010'`v'.csv", clear
    rename hat_real`l' `l'2010
    drop hat_*

    * merge and compute correlation
    if "`v'" == "wage" {
        merge 1:1 j using `tmp', keep(match) nogen
    }
    else {
        merge 1:1 i using `tmp', keep(match) nogen
    }
    corr `l'2008 `l'2010
    local corr = r(rho)

    * write to output
    file open fh using "`output'`l'_csp_2008_2010.tex", write replace
    file write fh %4.2f (`corr')
    file close fh
}