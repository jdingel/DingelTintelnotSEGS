clear

//warning: at one point, gtools had to be compiled manually for M1 Macs
//see https://github.com/mcaceresb/stata-gtools/issues/73#issuecomment-803444445

// install packages from ssc
local PACKAGES outreg geodist heatplot outreg2 ftools reghdfe ppmlhdfe spmap maptile listtex binscatter estout
foreach package in `PACKAGES' {
	capture which `package'
	if _rc==111 ssc install `package'
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

file open myfile using "../output/stata_packages.txt", write replace
file write myfile "Succesfully installed: `PACKAGES' `LOCAL_PACKAGES'"
file close myfile
