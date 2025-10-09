# setup environment

This task verifies/installs Julia, Stata, and R packages.

## Code
- `install_packages.do`: Verifies/installs STATA packages into new ado path `setup_environment/code/Stata_adofiles/`.
  Packages are primarily installed with `ssc2` from the Labor Dynamics Institute, which allows us
  to install specific Stata package versions from the SSC mirror archive. The `gtools` package and
  `save_data` packages were retrieved from GitHub.
- `create_requirements.do`: creates requirements file that enforces exact package versions using the
  `require` package.
- `profile.do`: adds `./Stata_adofiles` to the beginning of Stata's ado file search path and loads package 
version requirements from `stata_requirements.txt` each time a Stata script is run in this repository. 
Requirements are not enforced when running Stata scripts in this task, as this task installs  
the necessary ado files and creates the `stata_requirements.txt` file.

  **Notes**  
  - If `./Stata_adofiles` does not exist when running Stata scripts outside this task, an error message is returned.  
    This error is reported within `profile.do`, but the rest of the Stata script may continue to run.  
  - To ensure proper setup of ado files and requirements:
    1. Navigate to the `code` subdirectory of this task.  
    2. Run `rm ../output/stata*`.  
    3. Run `make` to download the necessary ado files into `./Stata_adofiles` and recreate `stata_requirements.txt`.
- `packages.R`: Verifies/installs R packages.
- `packages.jl`: Verifies/installs julia packages.
## Output
- `stata_packages.txt`: Text file that lists Stata packages installed.
    Created from `packages.do`.
- `stata_requirements.txt`: Text file that lists exact version requirements for packages by
  reading through packages installed in `setup_environment/code/Stata_adofiles/`. Created from
  `create_requirements.do`.
- `R_packages.txt`: Text file that lists R packages installed.
- `julia_packages.txt`: Text file that lists Julia packages installed.
- `Project.toml`: File describing this repository's direct Julia package dependencies.
- `Manifest.toml`: File describing the exact state of the repository's environment, including all direct/indirect dependencies and their versions.

It requires an internet connection.
It should take less than five minutes to run the entire task.

To remove `./Stata_adofiles` from Stata’s ado-file search path, navigate to the `code` directory for this task and run `adopath - "./Stata_adofiles"` in Stata.

The shell script `TeXpackages.sh` installs required LaTeX packages using the tlmgr command.
It is omitted from the Makefile.

* When using a computing cluster with SLURM job scheduling, customize `setup_environment/code/run.sbatch` with your credentials as required.