* In what fraction of observations with positive commuting flows does the margin of error exceed the value of the flow?
* Compute the number of zeros.
cap program drop descriptive_stats
program define descriptive_stats
syntax using/, dataset(string) 
use "`using'", clear
count if X_ij == 0 & ID_w!=ID_h
local n_zero = `r(N)'
local n_zero_str = string(`n_zero', "%12.0gc")
count if X_ij>0 & ID_w!=ID_h
local positive_flow = `r(N)'
count if inrange(MOE, X_ij+1, .) == 1 & X_ij>0 & ID_w!=ID_h
local moe_exceed_flow = `r(N)'
local pct = string(`moe_exceed_flow'*100/`positive_flow', "%3.0f")
mat define stats_`dataset' = [`n_zero', `positive_flow', `pct']
end

* count the fraction of X_ij==0 when X_ji!=0.
cap program drop asymmetriczeros
program define asymmetriczeros
syntax using/, output(string)  
use "`using'",clear
drop if ID_h==ID_w
tempfile tf0
save `tf0'
rename (ID_h ID_w X_ij) (ID_w ID_h X_ji)
merge 1:1 ID_h ID_w using `tf0',  keep(using match)
recode X_ji .=0 if _merge==2
drop _merge
count if X_ji==0 & X_ij!=0
local X_ji_zero  = `r(N)'
count if X_ij!=0
local obs  = `r(N)'
local X_ji_zero_rate = string(100*`X_ji_zero'/`obs',"%2.0f")
display "$ \ell_{nk}=0$ for `X_ji_zero_rate'\% of county pairs with $ \ell_{kn}>0$."
file open outputfile using "`output'", write replace
file write outputfile "$ \ell_{nk}=0$ for `X_ji_zero_rate'\% of county pairs with $ \ell_{kn}>0$." _n
file close outputfile
end

* count the zero prevalence among county pairs.
cap program drop zero_prev
program define zero_prev
syntax using/, output(string)
use "`using'",clear
count if ID_h!=ID_w
local denom = r(N)
local denom_str = string(`denom',"%9.0gc")
count if X_ij == 0 & ID_h!=ID_w
local number = r(N)
local percent = string(100*`number'/`denom',"%3.0f")
file open outputfile using "`output'", write replace
file write outputfile "`percent'\% of county pairs within 120 km have zero commuters between them." _n
file close outputfile
end

* Produce the 2x2 table of zero and non-zero flows for 2006-2010 county pairs vs 2011-2015 county pairs
cap program drop zero_persist
program define zero_persist
syntax, earlydata(string) laterdata(string) outputfreq(string) outputpct(string)
use "`earlydata'" if ID_h!=ID_w, clear
rename X_ij X_ij_0610
tempfile ACS20062010
save `ACS20062010'
use "`laterdata'" if ID_h!=ID_w, clear
merge 1:1 ID_h ID_w using "`ACS20062010'", keep(match) keepusing(X_ij)
rename X_ij X_ij_1115
gen byte X_ij_0610_nonzero = (X_ij_0610!=0)  
gen byte X_ij_1115_nonzero = (X_ij_1115!=0)
tab X_ij_0610_nonzero X_ij_1115_nonzero, matcell(tab_freq) 
frmttable using "`outputfreq'", statmat(tab_freq) ///
		 ctitle("", "ACS20112015", "" \ "ACS20062010", "Zero", "Positive") rtitle("Zero"\ "Positive")  ///
		 tex frag sd(0) replace
mata: st_matrix("tab_freq", (st_matrix("tab_freq") :/sum(st_matrix("tab_freq"))))
frmttable using "`outputpct'", statmat(tab_freq) ///
		 ctitle("", "ACS20112015", "" \ "ACS20062010", "Zero", "Positive") rtitle("Zero"\ "Positive")  ///
		 tex frag sd(2) replace
end