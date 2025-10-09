# LODES downloaddata

This task downloads LEHD Origin-Destination Employment Statistics (LODES) datasets.
The download is based on different combinations of state, job type, and file type.

- File type
	- OD: Origin-Destination data, jobs totals are associated with both a home Census Block and a work Census Block.
	- main: jobs with both workplace and residence in the state.
	- aux:  jobs with the workplace in the state and the residence outside of the state.
- Job type
	- JT01: for primary jobs

The block-level origin-destination data for New York City, Detroit, and Minneapolis-St. Paul are 
obtained from LODES version 7.4 published by the US Census Bureau.
See the [official documentation](https://lehd.ces.census.gov/data/lodes/LODES7/LODESTechDoc7.4.pdf) for details of the data structure.
