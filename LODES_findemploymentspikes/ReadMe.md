# LODES findemploymentspikes

This task finds events that satisfy certain criteria regarding employment counts and employment increase, and visualizes the corresponding employment change.


## Output:
* `nyc_20102012_spikes_list.txt`: List of tracts that experienced employment booms in 2010-2012.
* `tract_employmentcountsOD_(tract).eps`: Figure that depicts the number of primary jobs held by New York City residents in a given tract in the LODES data.
* `tract_employmentcountsOD_notes.tex`: Description of `tract_employmentcountsOD_(tract).eps`.

## Code:
* `emp_time_series.do`: produces a figure that that depicts the number of primary jobs held by New York City residents in tracts `tract_Tiffany` and `tract_Google` in the LODES data.
* `findspikes_NYC_OD.do`: produces the list of "83 workplace tracts in New York City that had a two-year increase in total employment from 2010 to 2012 of at least 400 employees and at least 12.5% from a 2010 level of at least 400 employees." (Section 3.5 of paper)

## Input:
* `lodes_NYC_(year).dta`: tract-level LODES commuting data
