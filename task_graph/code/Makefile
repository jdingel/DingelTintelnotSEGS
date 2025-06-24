SHELL=bash

all: $(addprefix ../output/,task_flow.png)

include ../../generic.make

../output/graph.txt: graphmaker.sh $(shell find ../../ -name "Makefile") | ../output
	bash graphmaker.sh
../output/task_flow.png: ../output/graph.txt
	dot -Grankdir=LR -Tpng $< -o $@
../output/task_flow_%.png: ../output/graph_%.txt
	dot -Grankdir=LR -Tpng $< -o $@
