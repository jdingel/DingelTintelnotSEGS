# nyc_NTA_crosswalk
Transforms tract-to-NTA crosswalk from Excel file to a DTA file.

## Output
* `nyc_tract_NTA_crosswalk.dta`: NYC tract-to-NTA crosswalk

## Code
* `NTA_crosswalk_maker.do`: Takes in the NYC census to NTA tabulation spreadsheet and reformats the census tract codes to be aligned with the format of the census tract data we currently use. 
It also renames the variable labels to be more descriptive.

## Input
* `../input/nyc2010census_tabulation_equiv.xlsx`: City-provided tract-to-NTA crosswalk in Excel format
