# distance based delta compute
    This task creates a distance-predicted value of deltabar for each tract pair in NYC.


## Output
* `log_time_log_dist_r2.tex`: R2 from regressing log public transit commuting time on log great-circle distance
* `nyc2010_dest_dist.dta`: Destination tract fixed effects for commuting flows with google maps times predicted from distance as bilateral covariate
* `nyc2010_orig_dist.dta`: Origination tract fixed effects for commuting flows with google maps times predicted from distance as bilateral covariate
* `nyc2010_time_elasticity_dist.csv`: The commuting time elasticity in preperiod
* `nyc2010_lodes_wzero_wdistdelta.dta`: LODES data from stub with zero commuting flows and distance-predicted commuting costs.
* `nyc2010_bilat_predicted_dist.dta`: Predicted bilateral commuting flows across tract pairs from the gravity model, along with the log of distance-based commuting costs and origin/destination tract fixed effects for each pair.
## Code
* `compute_distance_based_delta_fn.do`: This script contains only function (hence fn). The function takes in commuting flow data, estimates a distance-predicted commuting cost matrix, and merges it with the commuting flow data. 
This script is comparable to nyc_delta.do. 
* `df_before_dist_delta.do`: This script takes in the merged commuting flow data and computes the distance-predicted value of deltabar for each tract pair in NYC and estimates a gravity model of commuting flows to output origin and destination fixed effects and bilateral predicted times. 


## Input
* `NYC_tractpairs_DDMM.dta`: NYC tract-pair level transit time from Davis, Dingel, Monras, and Morales's replication package.
* `2015_gaz_tracts_36.txt`: tract-level geographical coordinates in NY.
* `gravity_saveFE_time.do`: run gravity regression, with transit time specification.
* `programs_LODES.do`: program to aggregate block-level LODES data to tract-level, and aggregate tract-level data to place-level.
* `merge_geocords.do`: calculate tract-pair level distance
* `nyc2010_lodes_wzeros.dta`: LODES data from stub with zero commuting flows.

