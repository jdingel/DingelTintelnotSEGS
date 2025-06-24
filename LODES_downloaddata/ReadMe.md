# LODES downloaddata

This task downloads LEHD Origin-Destination Employment Statistics (LODES) datasets.
The download is based on different combinations of state, job type, and file type.

- File type
	- OD: Origin-Destination data, jobs totals are associated with both a home Census Block and a work Census Block.
	- WAC: Workplace Area Characteristic data, jobs are totaled by work Census Block.
	- main: jobs with both workplace and residence in the state.
	- aux:  jobs with the workplace in the state and the residence outside of the state.
- Job type
	- JT00: for all jobs
	- JT01: for primary jobs

It takes about 20 minutes to run the entire task.