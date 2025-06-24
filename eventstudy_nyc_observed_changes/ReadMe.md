# eventstudy_nyc_observed_changes
This task computes both the 2010-2012 change in commuting flows for tract pairs and the change in total employment for workplace tracts.

## Output
* `nyc_2012_2010_observed_changes_tracttotract.dta`: Vector of 2010-2012 change in commuter counts for tract pairs.
* `nyc_2012_2010_observed_changes_dest_tract.dta`: Vector of change in employment from 2010 to 2012 by workplace tract.

## Code
* `compute_observed_changes_origtodest.do`: Computes observed change in commuter counts between origin-destination pairs.
* `compute_observed_changes_dest.do`: Computes observed change in employment by workplace (total commuter counts to destination)

## Input
* `nyc2010_lodes_wzeros_wdelta.dta`: The tract-to-tract commuting flows in 2010 from the LODES dataset
* `nyc2012_lodes_wzeros.dta`:The tract-to-tract commuting flows in 2012 from the LODES dataset

This task takes under 5 minutes to run.
