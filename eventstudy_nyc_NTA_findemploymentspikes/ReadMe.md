# eventstudy_nyc_NTA_findemploymentspikes
This task computes the employment of NYC residents in each NTA from 2010 to 2012 and develops a set of figures to describe this data.
It then generates a list of NTAs that had NYC-resident employment increases greater than 5, 10, and 12.5 percent.

## Output
* `NTA_spikes_list_{x}pct.csv`: 
NTA codes for NTAs with large employment changes defined as a change in employment of over x%.
* `NTA_boom_count_{x}pct.tex`: A statement of the number of "booming" NTAs defined as a change in employment of over x% from a baseline greater than 2000.
## Code
* `NTA_findspikes.do`: 
Takes in NTA-level employment data and identifies NTAs with large employment changes defined as a change in employment of over 5%, 10% and 12.5% from an initial baseline of at least 2000 employees.

## Input
* `NTA_employment.dta`: NTA-level employment data for 2010 and 2012.

