import delimited using "../output/nyc2010_time_elasticity.csv", clear
local epsilon = v1[1]
display "`epsilon'"
use "../output/nyc2010_lodes_wzero_wdelta.dta", clear
gen eps_logdelta = `epsilon' * log_delta
summarize eps_logdelta
local outnumber = string(`r(sd)',"%5.3f")
file open outputfile using "../output/nyc2010_stddev_epslndelta.tex", write replace
file write outputfile "`outnumber'"
file close outputfile