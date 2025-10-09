## CDP_PUMS_data

This task downloads the PUMS data for 2001 and 2002 to replicate the state-to-state migration matrix used in Caliendo, Dvorkin, Parro (ECMA 2019).
The PUMS data is downloaded from the Census American Community Survey (ACS) dataset.

The state or foreign country coding standards are inconsistent for variables MIGSP (origin of migration) and PUMA (data record area/destination of migration).
For example, Connecticut is "007" in MIGSP but "00009" in PUMA.
The following two datasets with codes and location names are therefore manually extracted from the PUMS data dictionary `../output/PUMSDataDict00_02.pdf`.

1. `../output/migsp_code.csv` is from p58-61 in the documentation.
2. `../output/puma_code.csv` is from p17-18 in the documentation.

Other datasets produced by this task:
- `../output/ss01pus.csv`: compressed file containing person-level ACS PUMS data for the entire United States in 2001.
- `../output/ss02pus.csv`: compressed file containing person-level ACS PUMS data for the entire United States in 2002.
