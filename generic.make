OOPR = ../output ../temp ../report ../input run.sbatch slurmlogs #Order-only pre-requisites
JULIA_OOPR = ../input/Project.toml ../input/Manifest.toml #Julia pre-requisites
wipeclean: #This deletes all output, input, and logs content
	$(WIPECLEAN) $(CURDIR)

run.sbatch: ../../setup_environment/code/run.sbatch | slurmlogs
	ln -sf $< $@
../input/Project.toml: ../../setup_environment/output/Project.toml | ../input/Manifest.toml ../input
	ln -sf $< $@
../input/Manifest.toml: ../../setup_environment/output/Manifest.toml | ../input
	ln -sf $< $@
slurmlogs ../input ../output ../temp ../report:
	mkdir $@

../report/%.csv.log: ../output/%.csv | ../report
ifneq ($(shell command -v md5),)
	cat <(md5 $<) <(echo -n 'Lines:') <(cat $< | wc -l ) <(head -3 $<) <(echo '...') <(tail -2 $<)  > $@
else
	cat <(md5sum $<) <(echo -n 'Lines:') <(cat $< | wc -l ) <(head -3 $<) <(echo '...') <(tail -2 $<) > $@
endif

../report/%.jld2.log: ../input/describe_data_script.jl ../input/describe_data.jl ../output/%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< ../output/$*.jld2

../input/describe_data.jl ../input/describe_data_script.jl: ../input/%: ../../describe_data/code/% | ../input
	ln -sf $< $@

.PRECIOUS: ../../%
../../%: #Generic recipe to produce outputs from upstream tasks
	$(MAKE) -C $(subst output/,code/,$(dir $@)) ../output/$(notdir $@)
