clear all

set scheme s2color

* puma is the destination state
import delimited "../input/puma_code.csv", delimiters(" ") clear
rename v1 puma
gen state_d = v2 + " " + v3 + " " + v4
keep puma state_d
replace state_d = upper(strtrim(state_d))
tempfile puma_code
save `puma_code', replace

* migsp is the origin state
*migsp is missing if individual lived in same address as one year ago, migsp is the location of their previous address
*so individuals with migsp and puma in same location means they moved within the state
*if their migsp is missing then they have not moved at all, even within state

import delimited "../input/migsp_code.csv", delimiters(" ") clear
rename v1 migsp
gen state_o = v2 + " " + v3 + " " + v4
keep migsp state_o 
replace state_o = upper(strtrim(state_o))
tempfile migsp_code
save `migsp_code', replace

import delimited "../input/ss01pus.csv", clear
count
local total_individuals = string(`r(N)',"%12.0gc")  //

* Keep if the observations are prime-age/ aged between 25 and 65
keep if inrange(agep, 25, 65)
count
local primeage_individuals = string(`r(N)',"%12.0gc") 

* Keep within US migration obs, excluding guam, putero rico, other US teritories. Keep only 50 states+DC.
tab migsp, sort missing
keep if migsp < 52 //88% of obs have missing(migsp)==1. i.e. 88 of percent of them stayed in the same location as year before
count
local moving_individuals = string(`r(N)',"%12.0gc")


egen migrant_num_01 = count(migsp), by(puma migsp)
keep puma migsp migrant_num_01
duplicates drop

merge m:1 puma using `puma_code', nogen
merge m:1 migsp using `migsp_code', nogen keep(match)

* impute zeros
encode state_o, gen(state_orig)
encode state_d, gen(state_dest)
keep state_orig state_dest migrant_num_01 
reshape wide migrant_num_01, i(state_orig) j(state_dest)
reshape long migrant_num_01, i(state_orig) j(state_dest)

gen migrant_num_01_impute = migrant_num_01
replace migrant_num_01_impute = 0 if missing(migrant_num_01)

gsort state_orig state_dest
cap egen state_group = group(state_orig state_dest)

tempfile migration_share_01
save `migration_share_01', replace

import delimited "../input/ss02pus.csv", clear
* Keep if the observation is aged between 25 and 65
keep if inrange(agep, 25, 65)
* Keep within US migration obs. (migsp == 54: Other US)
keep if migsp < 52

egen migrant_num_02 = count(migsp), by(puma migsp)
keep puma migsp migrant_num_02
duplicates drop

merge m:1 puma using `puma_code', nogen 
merge m:1 migsp using `migsp_code', nogen keep(match)

* impute zeros
encode state_o, gen(state_orig)
encode state_d, gen(state_dest)
keep state_orig state_dest migrant_num_02
reshape wide migrant_num_02, i(state_orig) j(state_dest) 
reshape long migrant_num_02, i(state_orig) j(state_dest) 

gen migrant_num_02_impute = migrant_num_02
replace migrant_num_02_impute = 0 if missing(migrant_num_02)

gsort state_orig state_dest
cap egen state_group = group(state_orig state_dest)

merge 1:1 state_group using `migration_share_01', nogen 

*drop within-state movers
summarize migrant_num_01_impute if state_orig==state_dest
egen total_diagonal = total(migrant_num_01_impute) if state_orig==state_dest
egen total_within_between = total(migrant_num_01_impute)
gen diagonal_share = total_diagonal / total_within_between
summarize diagonal_share
local diagonal_percent = string(100 * `r(mean)',"%4.1f")
summarize total_within_between 
local N_ind_observations = string(`r(mean)',"%12.0gc")

drop if state_orig==state_dest
egen total_between = total(migrant_num_01_impute)
summarize total_between
local between_state_movers = string(`r(mean)',"%12.0gc")  

*Data details 
file open myfile using "../output/ACS_2001_data_cleaning_details.tex", write replace
file write myfile "The ACS 2001 dataset has `primeage_individuals' prime-age individuals out of the total sample of `total_individuals' individuals. Of these, `moving_individuals' individuals moved residences. Of the `N_ind_observations' individuals who moved, `diagonal_percent'\% migrated within their states. We observe a total of `between_state_movers' between-state movers out of the `primeage_individuals' prime-age individuals in the 2001 ACS."
file close myfile 

summarize migrant_num_01_impute
local between_mean = string(`r(mean)',"%2.1f")
shell echo -n the average cell in the migration matrix has `between_mean' movers% > ../output/ACS_migration_2001_offdiag_mean.tex
gen byte migrant_01_zero = (migrant_num_01_impute==0)
summarize migrant_01_zero
if inrange(`r(mean)',0.32,0.34) {
	shell echo -n "one-third are zero" > ../output/ACS_migration_2001_zeros.tex
}
else {
	error(Mean has drastically changed)
}
summarize migrant_num_01_impute
gen byte migrant_01_belowmean = inrange(migrant_num_01_impute,0,`r(mean)')
summarize migrant_01_belowmean
local between_belowmean_percent = string(100 * `r(mean)',"%2.0f")
shell echo -n `between_belowmean_percent'\\% of cells have fewer migrants than the average value of `between_mean'% > ../output/ACS_migration_2001_belowmean.tex



*generate migrant shares, not used for now 
sum migrant_num_01_impute
gen migrant_share_01_impute = migrant_num_01_impute / r(sum)
sum migrant_num_02_impute
gen migrant_share_02_impute = migrant_num_02_impute / r(sum) 

assert missing(migrant_num_01_impute)==0
assert missing(migrant_num_02_impute)==0
save "../output/migration_share_impute.dta", replace

*generate winsorized variables for histogram, transition matrix
foreach year in 01 02{
	*winsorize at 6 for transition matrix 
	gen migrant_num_`year'_impute_winsor_06= migrant_num_`year'_impute
	replace migrant_num_`year'_impute_winsor_06= 6 if inrange(migrant_num_`year'_impute_winsor_06,6,.) 
	*winsorize at 40 for histogram 
	gen migrant_num_`year'_impute_winsor_40= migrant_num_`year'_impute
	replace migrant_num_`year'_impute_winsor_40= 40 if inrange(migrant_num_`year'_impute_winsor_40,40,.) 
}

*plot histograms, transition matrix 
foreach year in 01 02{
	histogram migrant_num_`year'_impute_winsor_40 , graphregion(color(white)) xtitle("Number of individuals") ytitle("Density")
	graph export "../output/histogram_state_migration_20`year'.eps", replace fontface(Times)
}

*plot transition matrix 
tab  migrant_num_01_impute_winsor_06 migrant_num_02_impute_winsor_06, matcell(freq)
mat input one = (1\1\1\1\1\1\1) 
mat rowtot = freq*one
mat rowpct = inv(diag(rowtot))*freq
frmttable using "../output/CDP_2001_2002_migration_transition_matrix.tex", statmat(rowpct) nocenter ctitle("2002" \ "2001","0","1","2","3","4","5","6+")  rtitles("0"\"1"\"2"\"3"\"4"\"5"\"6+") multicol(1,1,8) tex frag replace
shell sed -i '' 's/\\end{tabular}\\\\/\\end{tabular}/g' ../output/CDP_2001_2002_migration_transition_matrix.tex