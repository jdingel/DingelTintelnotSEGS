OOPR = ../output ../temp ../report ../input run.sbatch slurmlogs #Order-only pre-requisites
JULIA_OOPR = ../input/Project.toml ../input/Manifest.toml #Julia pre-requisites
STATA_OOPR = $(OOPR) profile.do #Stata pre-requisites
wipeclean: #This deletes all output, input, and logs content
	$(WIPECLEAN) $(CURDIR)

run.sbatch: ../../setup_environment/code/run.sbatch | slurmlogs
	ln -sf $< $@
../input/Project.toml: ../../setup_environment/output/Project.toml | ../input/Manifest.toml ../input
	ln -sf $< $@
../input/Manifest.toml: ../../setup_environment/output/Manifest.toml | ../input
	ln -sf $< $@
profile.do: ../../setup_environment/code/profile.do
	ln -sf $< $@
slurmlogs ../input ../output ../temp ../report:
	mkdir $@

MDHASH := $(shell if command -v md5 >/dev/null 2>&1; then echo "md5 -q"; else echo "md5sum"; fi)
../report/%.csv.log: ../output/%.csv | ../report
	cat <($(MDHASH) $< | cut -d' ' -f1) <(echo -n 'Lines:') <(cat $< | wc -l ) <(head -3 $<) <(echo '...') <(tail -2 $<)  > $@
../report/%.md5: ../output/% | ../report
	$(MDHASH) $< | cut -d' ' -f1 > $@

../report/%.jld2.log: ../input/describe_data_script.jl ../input/describe_data.jl ../output/%.jld2 | $(OOPR) $(JULIA_OOPR)
	$(JULIA) $< ../output/$*.jld2

../input/describe_data.jl ../input/describe_data_script.jl: ../input/%: ../../describe_data/code/% | ../input
	ln -sf $< $@

.PRECIOUS: ../../%
../../%: #Generic recipe to produce outputs from upstream tasks
	$(MAKE) -C $(subst output/,code/,$(dir $@)) ../output/$(notdir $@)
