clear

// Save user's original PLUS directory
local original_plus "`c(sysdir_plus)'"

// Set new PLUS directory to install packages into
sysdir set PLUS "../../setup_environment/code/Stata_adofiles"

* install ssc2: used for installing specific package versions
capture which ssc2
if _rc==111 net install ssc2, all replace from("https://raw.githubusercontent.com/labordynamicsinstitute/stata-ssc2/master")

// install packages from ssc mirror archive:
local PACKAGES outreg geodist heatplot outreg2 ftools reghdfe ppmlhdfe spmap maptile listtex binscatter estout
foreach package in `PACKAGES' {
    capture which `package'
    if _rc == 111 {
        ssc2 install `package', date(2025-07-01)
    }
}

// gtools 1.7.5 not in ssc mirror (jumps from 1.5.1 -> 1.10.1 between 10Dec2022 and 11Dec2022)
capture which gtools
if _rc== 111{
    net install gtools, from("https://raw.githubusercontent.com/mcaceresb/stata-gtools/061609d90b69239eb3624930bc34959bf56f210f/build") replace
}

// we install locally modified stata packages from setup_environment/code
local LOCAL_PACKAGES save_data
// save_data command originally downloaded from Gentzkow + Shapiro GitHub:
// https://github.com/gslab-econ/gslab_stata/tree/master/gslab_misc
foreach package in `LOCAL_PACKAGES' {
	// overwrite existing packages since local version extends command
	net install `package', from(`"`c(pwd)'/`package'"') replace
}

* install palettes
capture which palettes.hlp
if _rc==111 ssc install palettes

* install colrspace
capture which colrspace.sthlp
if _rc==111 ssc install colrspace

* create ../output/stata_packages.txt
file open myfile using "../output/stata_packages.txt", write replace
file write myfile "Succesfully installed: `PACKAGES' `LOCAL_PACKAGES'"
file close myfile

// Restore original PLUS directory
sysdir set PLUS "`original_plus'"