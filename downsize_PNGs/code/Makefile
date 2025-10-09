SHELL=bash
include ../../shell_functions.make

all: $(addprefix ../output/, \
			$(foreach stub,cbm ife_1 svd_5 svd_16 svd_100 svd_200 nnmf_5, \
			lodes_$(stub)_visualization.png) \
		lodes_visualization.png) ../output/map_svd16_reschange_cutoff.png

include ../../generic.make

../output/%.png: ../input/%.png | ../output
	convert $< -resize 800x800 $@

../input/lodes%visualization.png: ../../commuting_matrix_visualization/output/lodes%visualization.png | ../input
	ln -sf $< $@
../input/map_svd16_reschange_cutoff.png: ../../Amazon_counterfactual_map_approx/output/map_svd16_reschange_cutoff.png | ../input
	ln -sf $< $@
