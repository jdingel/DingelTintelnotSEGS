SHELL=bash
include ../../shell_functions.make

all:   ./Stata_adofiles ../output/stata_packages.txt ../output/julia_packages.txt ../output/R_packages.txt

../output/stata_packages.txt: install_packages.do | ../output ./Stata_adofiles
	$(STATA) $<
./Stata_adofiles:
	mkdir -p $@
../output/julia_packages.txt: packages.jl ../output/Project.toml ../output/Manifest.toml | ../output
	$(JULIA) $<
../output/R_packages.txt: packages.R | ../output
	$(R) $<