# Amazon Compute Distance to Treated
This task computes the distance between the treated tract and all other tracts in the dataset.

## OUTPUTS
* `NYC_dist_to_treated.dta`: The distance between origin tracts and the treatment tract.

## INPUTS
*  `2015_gaz_tracts_36.txt`: tract-level geographical coordinates in NY.

## CODE
* `dist_to_treated.do`: calculate the distance between origin tracts and the treatment tract.