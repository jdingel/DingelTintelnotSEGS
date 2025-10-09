SHELL=bash
include ../../shell_functions.make

## DEFINITIONS
set_zeta = 0.125 0.25 0.5 0.75
set_pairs = ntapair countypair
set_nests = $(foreach zeta, $(set_zeta), residence_$(zeta) workplace_$(zeta) ntaorigin_$(zeta)) $(set_pairs) 

OUTPUTS = $(foreach nest, $(set_nests), $(addprefix ../output/, \
	correlation_productivity_$(nest).tex \
	correlation_landendowment_$(nest).tex \
	commuting_elasticity_$(nest).tex \
	compare_wage_$(nest).png compare_rent_$(nest).png \
	compare_productivity_$(nest).png compare_landendowment_$(nest).png))

all: $(OUTPUTS)
include ../../generic.make

# OUTPUT RECIPES
.NOTPARALLEL:
../output/commuting_elasticity_%.tex $(addprefix ../output/correlation_, productivity_%.tex landendowment_%.tex) \
$(addprefix ../output/compare_, rent_%.png wage_%.png productivity_%.png landendowment_%.png): compare_prices.jl $(addprefix ../input/primitives_nyc2010_time, _%.jld2 .jld2) | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< $*

# INPUT RECIPES
../input/primitives%.jld2: ../../nyc_baseline_calibrate/output/primitives%.jld2 | ../input
	ln -sf $< $@
