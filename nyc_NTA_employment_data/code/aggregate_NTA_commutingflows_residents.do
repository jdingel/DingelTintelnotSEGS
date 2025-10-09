clear all

set scheme s2color
// loading NTA-tract crosswalk data
use `1', clear
rename (NTA_code tract) (i_NTA i)
summarize
tempfile temporaryi
save `temporaryi'
// Renaming data for later merge
rename (i i_NTA) (j j_NTA)
tempfile temporaryj
save `temporaryj'
// LODES employment and commuting data
use i j X_ij using `2', clear
merge m:1 i  using `temporaryi', assert(using match) keep(match) keepusing(i_NTA) nogen
merge m:1 j  using `temporaryj', assert(using match) keep(match) keepusing(j_NTA) nogen
collapse (sum) X_ij, by(j_NTA i_NTA)
sort i_NTA j_NTA
rename (i_NTA j_NTA) (i j)
label var i "NTA of residence (4-digit NTA-Code)"
label var j "NTA of workplace (4-digit NTA-Code)"
label var X_ij "Number of commuters residing in i and working in j"
save_data `3', key(j i) replace log_replace
collapse(sum) X_ij, by(i)
rename X_ij residents, replace
label var residents "Number of residents in NTA i"
save_data `4', key(i) replace log_replace

twoway (hist residents, lcolor(black) fcolor(none) start(0)  width(2500) fraction), graphregion(color(white)) xlabel(#9,labsize(large)) ylabel(,labsize(large)) ytitle(,size(medlarge)) xtitle("Number of Residents in NTA", size(medium)) ytitle(,size(large)) legend(off)
graph export `5', replace

label var residents "Number of residents in NTA i"
sort residents
keep if inrange(_n,1,10)
gen n = _n
listtex n i residents using `6', replace rstyle(tabular) ///
	head("\begin{tabular}{lcc} \toprule" "Ranking & Origin NTA & Resident Count\\" "\midrule") ///
	foot("\bottomrule\end{tabular}")
