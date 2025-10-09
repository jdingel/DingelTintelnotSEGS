clear all 

local model = "`1'"
assert "`model'" == "ife" | "`model'" == "svd"

import delimited using "../input/slope_int_MSE_all_cbm_sigma_4.0.csv", clear
rename (slope intercept mse) (slope_cbm intercept_cbm mse_cbm)

count 
local tot_event_cbm = r(N)

tempfile cbm_tf
save `cbm_tf', replace

if "`model'" == "ife"{
	foreach num of numlist 1(1)3{

		import delimited using "../input/slope_int_MSE_all_ife_`num'.csv", clear
		rename (slope intercept mse) (slope_ife_`num' intercept_ife_`num' mse_ife_`num')
		tempfile ife_`num'
		save `ife_`num'', replace

		qui summarize slope_ife_`num', d
		local ife_`num'_median_slope = string(`r(p50)',"%4.2f")
		file open ife_`num'_median_slope using "../output/ife_`num'_events_median_slope.tex", write replace
		file write ife_`num'_median_slope "`ife_`num'_median_slope'"
		file close ife_`num'_median_slope

		merge 1:1 j using `cbm_tf', assert(match) nogen

		count if abs(slope_ife_`num' - 1) < abs(slope_cbm - 1)
		loc ife_closest_to_1 = `r(N)'
		local slope_closest_to_1 = string(`ife_closest_to_1',"%4.0f")
		file open ife_`num'_closest_to_1 using "../output/text_ife_`num'_vs_cbm_sigma_4.0_closest_to_1.tex", write replace
		file write ife_`num'_closest_to_1 "`slope_closest_to_1' of the `tot_event_cbm' events."
		file close ife_`num'_closest_to_1

		count if mse_ife_`num' < mse_cbm
		loc ife_lower_mse = `r(N)'
		local mse_lower = string(`ife_lower_mse',"%4.0f")
		file open ife_`num'_lower_mse using "../output/text_ife_`num'_vs_cbm_sigma_4.0_lower_MSE.tex", write replace
		file write ife_`num'_lower_mse "`mse_lower' of the `tot_event_cbm' events."
		file close ife_`num'_lower_mse
	}
}


if "`model'" == "svd"{
	local rank = `2'
	assert inrange(`rank', 1, 2160)
	import delimited using "../input/slope_int_MSE_all_svd_`rank'.csv", clear
	rename (slope intercept mse) (slope_svd_`rank' intercept_svd_`rank' mse_svd_`rank')
	tempfile svd_`rank'
	save `svd_`rank'', replace

	qui summarize slope_svd_`rank', d
	local svd_`rank'_median_slope = string(`r(p50)',"%4.2f")
	file open svd_`rank'_median_slope using "../output/svd_`rank'_events_median_slope.tex", write replace
	file write svd_`rank'_median_slope "`svd_`rank'_median_slope'"
	file close svd_`rank'_median_slope

	merge 1:1 j using `cbm_tf', assert(match) nogen

	count if abs(slope_svd_`rank' - 1) < abs(slope_cbm - 1)
	loc svd_closest_to_1 = `r(N)'
	local slope_closest_to_1 = string(`svd_closest_to_1',"%4.0f")
	file open svd_`rank'_closest_to_1 using "../output/text_svd_`rank'_vs_cbm_sigma_4.0_closest_to_1.tex", write replace
	file write svd_`rank'_closest_to_1 "`slope_closest_to_1' of the `tot_event_cbm' events."
	file close svd_`rank'_closest_to_1

	count if mse_svd_`rank' < mse_cbm
	loc svd_lower_mse = `r(N)'
	local mse_lower = string(`svd_lower_mse',"%4.0f")
	file open ife_`rank'_lower_mse using "../output/text_svd_`rank'_vs_cbm_sigma_4.0_lower_MSE.tex", write replace
	file write ife_`rank'_lower_mse "`mse_lower' of the `tot_event_cbm' events."
	file close ife_`rank'_lower_mse
}

