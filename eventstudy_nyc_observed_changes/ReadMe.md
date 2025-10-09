# eventstudy_nyc_observed_changes
This task computes both the 2010-2012 change in commuting flows for tract pairs and the change in total employment for workplace tracts. 
It also computes the change between a pooled 2008-2010 average and the 2012 flows.

## Output
* `nyc_2012_2010_observed_changes_tracttotract.dta`: Vector of 2010-2012 change in commuter counts for tract pairs.
* `nyc_2012_2010_observed_changes_dest_tract.dta`: Vector of change in employment from 2010 to 2012 by workplace tract.
* `nyc_2012_2010_2008_pool__observed_changes_tracttotract.dta`: Vector of change in commuter counts from 2008-2010 average to 2012 for tract pairs.
* `nyc_2012_2010_2008_pool_observed_changes_dest_tract.dta`: Vector of change in employment from 2008-2010 average to 2012 by workplace tract.
* `nyc_NTA_2012_2010_observed_changes_origtodest.dta`: Vector of 2010-2012 change in commuter counts for origin-destination pairs using NTA-aggregated commuting data.
* `nyc_NTA_2012_2010_observed_changes_dest.dta`: Vector of change in employment from 2010 to 2012 by workplace using NTA-aggregated commuting data.

## Code
* `compute_observed_changes_origtodest.do`: Computes observed change in commuter counts between origin-destination pairs.
* `compute_observed_changes_dest.do`: Computes observed change in employment by workplace (total commuter counts to destination)

## Input
* `nyc2010_lodes_wzero_wdelta.dta`: The tract-to-tract commuting flows in 2010 from the LODES dataset
* `nyc2012_lodes_wzeros.dta`:The tract-to-tract commuting flows in 2012 from the LODES dataset
* `nyc_pool_2008_2010_lodes_wzero_wdelta.dta`: The tract-to-tract commuting flows using the pooled 2008-2010 data from the LODES dataset
* `NTA_commutingflows_2010.dta`: The origin-destination commuting flows in 2010 from the NTA-aggregated data
* `NTA_commutingflows_2012.dta`:  The origin-destination commuting flows in 2012 from the NTA-aggregated data

