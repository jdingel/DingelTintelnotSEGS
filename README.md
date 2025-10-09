This repository contains the code underlying the article "Spatial Economics for Granular Settings" by Jonathan I. Dingel and Felix Tintelnot.
This replication package produces all exhibits from scratch,
beginning with scripts in [initialdata](initialdata/code/Makefile) and [LODES_downloaddata](LODES_downloaddata/code/Makefile) that download all the required data.

## Code organization

The workflow is organized as a series of tasks.
Each task folder contains three folders: `input`, `code`, `output`.
A task's output is used as an input by one or more downstream tasks.

The repo contains 98 task folders.
[The task graph](task_graph/output/task_flow.png) depicts the input-output relationships between tasks.
The following subgraph depicts the 51 task folders involved in producing all the exhibits appearing in the main text of the paper.
![task-flow-maintext graph](task_graph/output/task_flow_maintext.png)

We use the [`make`](http://swcarpentry.github.io/make-novice/) utility to automate this workflow.
After downloading this replication package (and installing the relevant software), you can reproduce the figures and tables appearing in the paper simply by typing `make` at the command line.

## Software requirements
The project's tasks are implemented via Julia, Matlab, R, Stata, and shell scripts.
We ran our code using Julia 1.10.2, Matlab 2023b, R 4.1, Stata 18, GNU bash version 3.2.57, and ImageMagick 7.1.1-47.
The taskflow structure employs [symbolic links](https://en.wikipedia.org/wiki/Symbolic_link).

The Makefiles rely on `shell_functions.sh`, which assumes that `julia`, `Rscript`, and `stata-se` are valid commands on your machine.
Please create appropriate aliases or edit `shell_functions.sh` (e.g., replace `stata-se` with `stata-mp`).

## Replication instructions

### Download

Clone (or download) this repository by clicking the green `Code` button above.
If downloading, uncompress the ZIP file into a working directory on your cluster or local machine.

### Running scripts

From the Unix/Linux/MacOSX command line, navigate to the directory `exhibits/code`.
If you type `make`, it will build the PDF containing the exhibits,
which are committed to the tasks' output folders.

To reproduce all research results from scratch,
run `rm $(ls ./*/output/*.{csv,dta,zip,eps,png,tex} | grep -v 'initialdata\|CDP_PUMS_data\|task_graph')`
in this folder (the folder in which this `README.md` file is located) to delete all output files.
Next, run `make` in the `setup_environment/code` to install required Julia and Stata packages.
(If using a computing cluster with SLURM job scheduling, customize `setup_environment/code/run.sbatch` with your credentials as required.)
Finally, if you type `make` in `exhibits/code`,
it will run upstream tasks in order to produce the files containing the exhibits.
If you instead run `make ../output/exhibits_maintext_fast.pdf` in `exhibits/code`, it 
will generate all exhibits that do not rely on the most computationally intensive tasks.

You can produce the outputs of any individual task by running `make` in that task's `code` folder,
akin to running the `exhibits` task.

## Data download verification

The `output` (and `temp`) folders of the `initialdata`, `LODES_downloaddata`, and `CDP_PUMS_data` tasks are large (245MB, 2.2GB, and 764MB),
so we do not commit these files to the replication repo.
To verify that the files you download from the original data providers match those we used,
run `make verify_downloads` to compare their MD5 hashes to those in the `report` folder.

### Computation time
Some of the tasks are quite slow and take hundreds of CPU hours to run:
`Amazon_fixednu_simulate`, `interactive_fe_estimation`, and the various Monte-Carlo simulations.
We have committed files to various tasks' output folders,
so that downstream tasks can use those intermediate output files without having to run tasks requiring hundreds of CPU hours.

Several intermediate output files are provided in the form of `.zip` files. 
To use them, first decompress the files by running:
`for i in 1 2 3; do unzip ./interactive_fe_reformat/output/nyc2010_lambda_ife_${i}.dta.zip -d ./interactive_fe_reformat/output/; done`
This will extract the contents into their respective task's output folders so they can be used in downstream tasks.

To reproduce the main-text exhibits from these intermediate output files,
run `rm ./*/output/*.{eps,png,tex}` in this folder.
Next, run `make` in the `setup_environment/code` to install required Julia and Stata packages.
Finally, if you type `make ../output/exhibits_maintext.pdf` in `exhibits/code`,
it will run upstream tasks to produce the main-text exhibit PDFs but use the committed intermediate outputs where available.

The time required to run each task is reported within `metadata/time.txt` inside each task folder. 
For most tasks, we report precise run times for a 2021 iMac with an Apple M1 chip and 16GB RAM.
These metadata files contain two lines:
- **real**: the elapsed “wall-clock” time (i.e., how long the task took to complete).
- **user**: the total CPU time spent on the task, summed across all cores.

For tasks that run in parallel on a high-performance computing cluster, we report approximations.

### Notes
- An internet connection is required when running the `initialdata`, `LODES_downloaddata`, `CDP_PUMS_data`, and `setup_environment` tasks.
- Many scripts use $i$ and $j$ to index residences and workplaces rather than $k$ and $n$.

## Acknowledgments

We are grateful to Junbiao Chen, Daniil Iurchenko, Reigner Kane, Leran Qi, John Ruf, Isaac Shon, Ye Sun, Linghui Wu, Shijian Yang, and Mingjie Zhu for excellent research assistance in producing this content.

## List of exhibits
A table listing the outputs and task folders associated with each figure and table found in the main text and appendices can be found 
[here](exhibits/output/exhibits_table.md).
Each row of the table represents a particular file used in an exhibit and the task used to generate the file.
Note that several figures combine multiple outputs generated in separate tasks.

## Data Availability Statement
This study makes use of a wide range of publicly available datasets and data from replication packages.

A description of the specific datasets employed in the paper, how they were obtained, and relevant variables can be found in Appendix D.7. 
The relevant task folders used for data retrieval are: `LODES_downloaddata`, `initialdata`, and `CDP_PUMS_data`.
Each of these tasks contain a Makefile within the `code` sub-directory that retrieves the raw data.
In addition, each task contains a README file that briefly describes the data that is obtained.

## Data References

U.S. Census Bureau. 2019. Longitudinal Employer–Household Dynamics (LEHD), Origin–Destination Employment Statistics (LODES), Origin–Destination (OD) Files, Format Version 7.4. Washington, DC: U.S. Department of Commerce. Retrieved from https://lehd.ces.census.gov/data/lodes/LODES7/.

U.S. Census Bureau. 2010. American Community Survey, 5-Year Estimates (2006–2010), Table 1: Residence County to Workplace County Flows for the United States and Puerto Rico Sorted by Residence Geography. Washington, DC: U.S. Department of Commerce. Retrieved from https://www2.census.gov/programs-surveys/demo/tables/metro-micro/2010/commuting-employment-2010/table1.xlsx

U.S. Census Bureau. 2013. American Community Survey, 5-Year Estimates (2009–2013), Table 1: Residence County to Workplace County Flows for the United States and Puerto Rico Sorted by Residence Geography. Washington, DC: U.S. Department of Commerce. Retrieved from https://www2.census.gov/programs-surveys/commuting/tables/time-series/commuting-flows/table1.xlsx.

U.S. Census Bureau. 2015. American Community Survey, 5-Year Estimates (2011–2015), Table 1: Residence County to Workplace County Flows for the United States and Puerto Rico Sorted by Residence Geography. Washington, DC: U.S. Department of Commerce. Retrieved from https://www2.census.gov/programs-surveys/demo/tables/metro-micro/2015/commuting-flows-2015/table1.xlsx.

U.S. Census Bureau. 2001. American Community Survey, Public Use Microdata Sample (PUMS). Washington, DC: U.S. Department of Commerce. Retrieved from https://www2.census.gov/programs-surveys/acs/data/pums/2001/csv_pus.zip

U.S. Census Bureau. 2002. American Community Survey, Public Use Microdata Sample (PUMS). Washington, DC: U.S. Department of Commerce. Retrieved from https://www2.census.gov/programs-surveys/acs/data/pums/2002/csv_pus.zip

U.S. Census Bureau. 2015. U.S. Gazetteer Files — Census Tracts, New York (State FIPS 36). Washington, DC: U.S. Department of Commerce. Retrieved from https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2015_Gazetteer/2015_gaz_tracts_36.txt.

U.S. Census Bureau. 2015. U.S. Gazetteer Files — Census Tracts, Michigan (State FIPS 26). Washington, DC: U.S. Department of Commerce. Retrieved from https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2015_Gazetteer/2015_gaz_tracts_26.txt.

U.S. Census Bureau. 2006-2013. ZIP Code Business Patterns. Washington, DC: U.S. Department of Commerce. Retrieved from https://www2.census.gov/

U.S. Department of Housing and Urban Development. 2010-2013. HUD-USPS ZIP Code Crosswalk Files. Office of Policy Development and Research. Retrieved from https://www.huduser.gov/portal/datasets/usps/ 

Instituto Brasileiro de Geografia e Estatística. 2010. Censo Demográfico. Retrieved from https://censo2010.ibge.gov.br/

NYC Department of City Planning. 2010. New York City 2010 Census Tract to Neighborhood Tabulation Area (NTA) Equivalency. Retrieved from https://www1.nyc.gov/assets/planning/download/office/data-maps/nyc-population/census2010/ 

Davis, Donald R., Jonathan I. Dingel, Joan Monras, and Eduardo Morales. 2019. Replication files for "How Segregated Is Urban Consumption?" Journal of Political Economy. Retrieved from https://github.com/jdingel/DavisDingelMonrasMorales/ 

Dingel, Jonathan I., Antonio Miscio, and Donald R. Davis. 2021. Replication files for "Cities, lights, and skills in developing economies." Journal of Urban Economics. Retrieved from https://github.com/jdingel/DingelMiscioDavis 

Owens, Raymond III, Esteban Rossi-Hansberg, and Pierre-Daniel Sarte. 2020. Replication files for "Rethinking Detroit." American Economic Association. Retrieved from https://www.aeaweb.org/journals/dataset?id=10.1257/pol.20180651 

Roth, Jean. 2010. County-to-County Distance File: U.S. Counties within 100 Miles. Cambridge, MA: NBER. Retrieved from http://data.nber.org/distance/2010/sf1/county/sf12010countydistance100miles.csv.