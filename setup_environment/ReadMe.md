# setup environment

This task verifies/installs Julia, Stata, and R packages.
It requires an internet connection.
It should take less than five minutes to run the entire task.

The shell script `TeXpackages.sh` installs required LaTeX packages using the tlmgr command.
It is omitted from the Makefile.

* When using a computing cluster with SLURM job scheduling, customize `setup_environment/code/run.sbatch` with your credentials as required.