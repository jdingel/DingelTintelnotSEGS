clear all

local tract = `1'
local output_filestub = "../output/`tract'_contrastchanges_NTA"

log using "slurmlogs/`tract'_contrastchanges_NTA.log", replace

// function
cap program drop regression
cap program define regression
syntax, obs(string) pred(string) pos(string) ctitle(string) output(string)
egen mean_abs_diff = mean(abs(`obs'-`pred'))
local MAE = mean_abs_diff[1]
egen mean_sq_diff = mean((`obs'-`pred')^2)
local MSE = mean_sq_diff[1]
clonevar x_temp = `pred' 
label var x_temp "Predicted change"
reg `obs' x_temp
outreg2 using `output', ///
	`pos' tex(frag) ctitle(`ctitle') noaster label ///
	addstat(MAE,`MAE', MSE, `MSE')
drop mean_abs_diff mean_sq_diff x_temp
end


// prepare data
// map tract-NTA
use "../output/nyc_tract_NTA_crosswalk.dta",clear
tempfile map_tract_NTA
keep tract NTA_code
save `map_tract_NTA'

// observed data in 2010 and 2012
use "../input/nyc2012_lodes_wzeros.dta", clear
keep if j=="`tract'"
rename X_ij x_ij2012
destring i j, replace
tempfile LODES2012
save `LODES2012'

// Calibrated-shares
import delimited "../input/nyc_obs_csp_sigma_4.0_all.csv", clear
keep if j==`tract'
drop j
summarize
gen diff_cs = x_ctfl-x_baseline
tempfile tf_cs
save `tf_cs'

// Continuum-limit
import delimited "../input/nyc_obs_cbm_sigma_4.0_all.csv", clear
keep if j==`tract'
drop j
gen diff_cont = x_ctfl-x_baseline
tempfile tf_cont
save `tf_cont'

// Continuum-limit, delta=Inf
import delimited "../input/nyc_obs_cbm_deltainf_all.csv", clear
keep if j==`tract'
drop j
gen diff_cont_deltainf = x_ctfl-x_baseline
tempfile tf_cont_deltainf
save `tf_cont_deltainf'

// merge different spec
use `tf_cs',clear
merge 1:1 i using `tf_cont', keepusing(diff_cont) assert(match) nogen
merge 1:1 i using `tf_cont_deltainf', keepusing(diff_cont_deltainf) assert(match) nogen
merge 1:1 i using `LODES2012', keep(match master)
replace x_ij2012=0 if _merge==1
drop _merge

gen diff_obs = x_ij2012-x_baseline
drop x_ij*
order i j
tostring i, replace format("%11.0f")
tostring j, replace format("%11.0f")
tempfile df_eventstudy
save `df_eventstudy'

// match tract id to NTA id
use `map_tract_NTA', clear
rename (tract NTA_code) (i NTA_i)
merge 1:1 i using `df_eventstudy', assert(match master) keep(match) nogen

// collapse at NTA level
collapse (sum) diff*, by(NTA_i)

// regression
regression, output("`output_filestub'.tex") pos(replace)  obs(diff_obs) pred(diff_cs)			ctitle(Calibrated,shares)
regression, output("`output_filestub'.tex") pos(append)   obs(diff_obs) pred(diff_cont)		    ctitle(Continuum limit, of finite)
regression, output("`output_filestub'.tex") pos(append)   obs(diff_obs) pred(diff_cont_deltainf) ctitle(Continuum limit, (prohibitive costs))

//Clean up table
shell sed -i.bak 's/VARIABLES \& /\&/' "`output_filestub'.tex"
rm "`output_filestub'.tex.bak"
rm "`output_filestub'.txt"

log close
