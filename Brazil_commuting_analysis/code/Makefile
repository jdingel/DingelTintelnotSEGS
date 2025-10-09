SHELL=bash
include ../../shell_functions.make

#### DEFINITIONS ####
INPUTS  = ../input/CENSO10_commuting.dta ../input/municipios_2010_withcoordinates.dta
OUTPUTS= ../output/commutematrix_posflows_2010_withdistances.dta \
		../output/Brazil_commute_2010_asymmetriczeros.tex \
		../output/Brazil_gravity_and_zeros_60.eps \
		../output/municipios_are_granular.tex \
		../output/municipios_total_commuters_fragment.tex

#### RECIPES ####
all: $(OUTPUTS)
include ../../generic.make

../output/commutematrix_posflows_2010_withdistances.dta: dataprep.do $(INPUTS) | $(STATA_OOPR)
	$(STATA) $<
../output/Brazil_commute_2010_asymmetriczeros.tex ../output/Brazil_gravity_and_zeros_60.eps: zeros.do  ../output/commutematrix_posflows_2010_withdistances.dta | $(STATA_OOPR)
	$(STATA) $<
../output/municipios_are_granular.tex: municipios_are_granular.do ../output/commutematrix_posflows_2010_withdistances.dta | $(STATA_OOPR)
	$(STATA) $<
../output/municipios_total_commuters_fragment.tex: municipios_are_granular.do ../output/commutematrix_posflows_2010_withdistances.dta | $(STATA_OOPR)
	$(STATA) $<

../input/CENSO10_commuting.dta: ../../initialdata/output/CENSO10_commuting.dta | ../input
	ln -sf $< $@
../input/municipios_2010_withcoordinates.dta: ../../initialdata/output/municipios_2010_withcoordinates.dta | ../input
	ln -sf $< $@

