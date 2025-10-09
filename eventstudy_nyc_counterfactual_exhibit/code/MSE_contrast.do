import delimited using "../input/slope_int_MSE_all_cbm_nta.csv", clear
rename (slope intercept mse) (cbm_NTA_slope cbm__NTA_intercept cbm_NTA_mse) 
tempfile temporary
save `temporary'
import delimited using "../input/slope_int_MSE_all_csp_nta.csv", clear
rename (slope intercept mse) (csp_NTA_slope csp_NTA_intercept csp_NTA_mse)
merge m:1 j using `temporary', assert(match) nogen
gen MSE_NTA_ratio = cbm_NTA_mse / csp_NTA_mse
qui summarize MSE_NTA_ratio, detail
local MSE_NTA_ratio_median = string(`r(p50)',"%3.2f")
file open mse_NTA_medians using "../output/MSE_NTA_median.txt", write replace
file write mse_NTA_medians "`MSE_NTA_ratio_median'"
file close mse_NTA_medians
qui summarize cbm_NTA_mse, detail
local median_NTA_MSE_cbm = string(`r(p50)',"%3.2f")
file open median_NTA_MSE_cbm using "../output/median_NTA_MSE_cbm.txt", write replace
file write median_NTA_MSE_cbm "`median_NTA_MSE_cbm'"
file close median_NTA_MSE_cbm
qui summarize csp_NTA_mse, detail
local median_NTA_MSE_csp = string(`r(p50)',"%3.2f")
file open median_NTA_MSE_csp using "../output/median_NTA_MSE_csp.txt", write replace
file write median_NTA_MSE_csp "`median_NTA_MSE_csp'"
file close median_NTA_MSE_csp 
count
local tot_event_NTA = `r(N)'
count if cbm_NTA_mse<csp_NTA_mse
local cbm_NTA_win = `r(N)'
file open numevent_NTA using "../output/text_num_event_NTA.tex", write replace
file write numevent_NTA "`tot_event_NTA'%"
file close numevent_NTA

file open cbmwin_NTA using "../output/text_CBM_NTA_win.tex", write replace
file write cbmwin_NTA "`cbm_NTA_win'%"
file close cbmwin_NTA

file open summse_NTA using "../output/summary_MSE_NTA.tex", write replace
file write summse_NTA "The covariates-based model has a lower MSE than the calibrated-shares procedure in `cbm_NTA_win' of the `tot_event_NTA' events."
file close summse_NTA

import delimited using "../input/slope_int_MSE_all_cbm_sigma_4.0.csv", clear
rename (slope intercept mse) (cbm_slope cbm_intercept cbm_mse) 
tempfile temporary
save `temporary'

import delimited using "../input/slope_int_MSE_all_csp_sigma_4.0.csv", clear
rename (slope intercept mse) (csp_slope csp_intercept csp_mse)
merge m:1 j using `temporary', assert(match) nogen
gen MSE_ratio = cbm_mse / csp_mse
tempfile temp2
save `temp2'

import delimited using "../input/slope_int_MSE_all_cbm_pool_2008_2010.csv", clear
rename (slope intercept mse) (cbm_pool_slope cbm_pool_intercept cbm_pool_mse) 
tempfile temporary
save `temporary'

import delimited using "../input/slope_int_MSE_all_cbm_dist.csv", clear
rename (slope intercept mse) (cbm_dist_slope cbm_dist_intercept cbm_dist_mse) 
tempfile dist
save `dist'

import delimited using "../input/slope_int_MSE_all_csp_pool_2008_2010.csv", clear
rename (slope intercept mse) (csp_pool_slope csp_pool_intercept csp_pool_mse)
merge m:1 j using `temporary', assert(match) nogen
gen MSE_pool_ratio = cbm_pool_mse / csp_pool_mse
merge m:1 j using `temp2', assert(match) nogen
merge m:1 j using `dist', assert(match) nogen
gen MSE_dist_ratio = cbm_dist_mse / csp_mse

***********************
* median of MSE ratio *
***********************

qui summarize MSE_ratio, detail
local MSE_ratio_median = string(`r(p50)',"%3.2f")
file open mse_medians using "../output/MSE_ratio_median.txt", write replace
file write mse_medians "`MSE_ratio_median'"
file close mse_medians

qui summarize MSE_pool_ratio, detail
local MSE_pool_ratio_median = string(`r(p50)',"%3.2f")
file open mse_pool_medians using "../output/MSE_pool_ratio_median.txt", write replace
file write mse_pool_medians "`MSE_pool_ratio_median'"
file close mse_pool_medians

qui summarize MSE_dist_ratio, detail
local MSE_dist_ratio_median = string(`r(p50)',"%3.2f")
file open mse_dist_medians using "../output/MSE_dist_ratio_median.txt", write replace
file write mse_dist_medians "`MSE_dist_ratio_median'"
file close mse_dist_medians

*****************
* median of MSE *
*****************
qui summarize cbm_mse, detail
local median_MSE_cbm = string(`r(p50)',"%3.2f")
file open median_MSE_cbm using "../output/median_MSE_cbm.txt", write replace
file write median_MSE_cbm "`median_MSE_cbm'"
file close median_MSE_cbm

qui summarize cbm_dist_mse, detail
local median_MSE_cbm = string(`r(p50)',"%3.2f")
file open median_MSE_cbm using "../output/median_MSE_cbm_dist.txt", write replace
file write median_MSE_cbm "`median_MSE_cbm'"
file close median_MSE_cbm

qui summarize csp_mse, detail
local median_MSE_csp = string(`r(p50)',"%3.2f")
file open median_MSE_csp using "../output/median_MSE_csp.txt", write replace
file write median_MSE_csp "`median_MSE_csp'"
file close median_MSE_csp

qui summarize cbm_pool_mse, detail
local median_MSE_cbm_pool = string(`r(p50)',"%3.2f")
file open median_MSE_cbm_pool using "../output/median_MSE_cbm_pool.txt", write replace
file write median_MSE_cbm_pool "`median_MSE_cbm_pool'"
file close median_MSE_cbm_pool

qui summarize csp_pool_mse, detail
local median_MSE_csp_pool = string(`r(p50)',"%3.2f")
file open median_MSE_csp_pool using "../output/median_MSE_csp_pool.txt", write replace
file write median_MSE_csp_pool "`median_MSE_csp_pool'"
file close median_MSE_csp_pool

count
local tot_event = `r(N)'
count if cbm_mse<csp_mse
local cbm_win = `r(N)'
count if cbm_pool_mse<csp_pool_mse
local pool_cbm_win = `r(N)'
count if cbm_dist_mse<csp_mse
local dist_cbm_win = `r(N)'

file open numevent using "../output/text_num_event.tex", write replace
file write numevent "`tot_event'%"
file close numevent

file open cbmwin using "../output/text_CBM_win.tex", write replace
file write cbmwin "`cbm_win'%"
file close cbmwin

file open poolcbmwin using "../output/text_pool_CBM_win.tex", write replace
file write poolcbmwin "`pool_cbm_win'%"
file close poolcbmwin

file open distcbmwin using "../output/text_dist_CBM_win.tex", write replace
file write distcbmwin "`dist_cbm_win'%"
file close distcbmwin

file open summse using "../output/summary_MSE.tex", write replace
file write summse "The covariates-based model has a lower MSE than the calibrated-shares procedure in `cbm_win' of the `tot_event' events."
file close summse
file open summsepool using "../output/summary_MSE_pool.tex", write replace
file write summsepool "The covariates-based model has a lower MSE than the calibrated-shares procedure in `pool_cbm_win' of the `tot_event' events."
file close summsepool