## CDP_replication

This tasks replicates the state-level migration matrix for years 2001 and 2002, from Caliendo, Dvorkin, Parro (ECMA 2019),
to show that there is granularity even in state-to-state migration data.

Code: `PUMS_clean.do`:
- creates the migration matrix from the raw data
- plots a histogram of migration flows to show that most migration flows are small/zero, for both years 2001 and 2002.
- creates a migration flow transition matrix to check if migration flows are stable across the two years. The value for flows are winsorized at 6.

Outputs:
- `migration_share_impute.dta`: contains imputed interstate migration flows for 2001 and 2002, along with their respective shares of total movers.
- `CDP_2001_2002_migration_transition_matrix.tex`: summarizes the probability of observing a specific migration count in 2002 given the 2001 value, winsorized at 6.
- `histogram_state_migration_(year).eps`: visualizes the distribution of imputed migration counts between state pairs in 2001 and 2002, winsorized at 40.
- `ACS_2001_data_cleaning_details.tex`: summarizes the data cleaning and filtering steps on the 2001 ACS dataset, including total individuals, prime-age subset, and moving/migration statistics.
- `ACS_migration_2001_offdiag_mean.tex`: states the average number of movers per cell in the 2001 interstate migration matrix.
- `ACS_migration_2001_zeros.tex`: states the fraction of the matrix cells that contain zero migrants.
- `ACS_migration_2001_belowmean.tex`: states the percentage of migration matrix cells with fewer migrants than the average value.

Inputs: Raw data downloaded in `CDP_PUMS_data` task.
