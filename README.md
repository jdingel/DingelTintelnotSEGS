This repository contains the code underlying the article "Spatial Economics for Granular Settings" by Jonathan I. Dingel and Felix Tintelnot.
This replication package produces the main-text exhibits from scratch,
beginning with scripts in [initialdata](initialdata/code/Makefile) and [LODES_downloaddata](LODES_downloaddata/code/Makefile) that download all the required data.

## Code organization

The workflow is organized as a series of tasks.
Each task folder contains three folders: `input`, `code`, `output`.
A task's output is used as an input by one or more downstream tasks.

The repo contains 51 task folders.
[This graph](task_graph/output/task_flow.png) depicts the input-output relationships between tasks.

![task-flow graph](task_graph/output/task_flow.png)

We use the [`make`](http://swcarpentry.github.io/make-novice/) utility to automate this workflow.
After downloading this replication package (and installing the relevant software), you can reproduce the figures and tables appearing in the paper simply by typing `make` at the command line.

## Software requirements
The project's tasks are implemented via Julia, Matlab, R, Stata, and shell scripts.
We ran our code using Julia 1.9, Matlab 2023b, R 4.1, Stata 18, and GNU bash version 3.2.57.
The taskflow structure employs [symbolic links](https://en.wikipedia.org/wiki/Symbolic_link).

The Makefiles rely on `shell_functions.sh`, which assumes that `julia`, `Rscript`, and `stata-se` are valid commands on your machine.
Please create appropriate aliases or edit `shell_functions.sh` (e.g., replace `stata-se` with `stata-mp`).

## Replication instructions

### Download

Download (or clone) this repository by clicking the green `Clone or download` button above.
Uncompress the ZIP file into a working directory on your cluster or local machine.

### Running scripts

From the Unix/Linux/MacOSX command line, navigate to the directory `exhibits/code`.
If you type `make`, it will build the PDF containing the exhibits,
which are committed to the tasks' output folders.

To reproduce research results from scratch, run `rm -r ./*/output` in this folder (the folder in which this `README.md` file is located) to delete all output files,
then `git checkout -- setup_environment/output/` and `git checkout -- maptile_templates/output/` to restore those tasks.
Next, run `make` in the `setup_environment/code` to install required Julia and Stata packages.
(If using a computing cluster with SLURM job scheduling, customize `setup_environment/code/run.sbatch` with your credentials as required.)
Finally, if you type `make` in `exhibits/code`,
it will run upstream tasks in order to produce the files containing the exhibits.

The `readme.md` file within each task folder comments on the expected runtime.
Some of the tasks are quite slow and take hundreds of CPU hours to run:
`Amazon_fixednu_simulate`, `interactive_fe_estimation`, and the various Monte-Carlo simulations.

You can produce the outputs of any individual task by running `make` in that task's `code` folder,
akin to running the `exhibits` task.

### Notes
- An internet connection is required when running the `initialdata`, `LODES_downloaddata`, and `setup_environment` tasks.

## Acknowledgments

We are grateful to Junbiao Chen, Reigner Kane, Daniil Iurchenko, Leran Qi, John Ruf, Ye Sun, Linghui Wu, Shijian Yang, and Mingjie Zhu for excellent research assistance in producing this content.
