# Amazon p-uncertainty baseline data
This task simulates 100 baseline commuting shares variations by sampling individuals with replacement from the observed 2010 commuting shares matrix. 

## Output
* `baseline_data_puncertainty_s#.csv`: Baseline commuting matrix for parameter uncertainty scenario #.

## Code
* `create_df_before.jl`: Compiles the observed commuting matrix
* `simulate_baseline_data.jl`: Simulates 100 variations of the baseline commuting matrix by sampling individuals with replacement from the observed commuting matrix.

## Input
* `nyc2010_lodes_wzeros_wdelta.dta`: LODES NYC 2010 data with zero commuting flows.