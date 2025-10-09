clear all

assert inlist("`1'","NYC", "DetroitUA", "MSP")
assert inlist(`2',2010,2014)

* count the fraction of X_ij==0 when X_ji!=0.
cap program drop asymmetriczeros
program define asymmetriczeros
syntax using/, output(string) [county(string)] 
use "`using'",clear
if "`county'"!="" foreach element of numlist `county' {
	local keepiflist = `"`keepiflist'"' + `""`element'""' + ", " //Construct a list of strings from the numlist
}
local keepiflist = substr(`"`keepiflist'"',1,length(`"`keepiflist'"')-2) //Drop the final unnecessary comma
if "`county'"!="" keep if inlist((substr(i,1,5),`keepiflist') & inlist((substr(j,1,5),`keepiflist') & missing(X_ij)==0 & X_ij!=0
tempfile tf0
save `tf0'
rename (i j X_ij) (j i X_ji)
merge 1:1 i j using `tf0',  keep(using match)

recode X_ji .=0 if _merge==2
drop _merge

count if X_ji==0 & X_ij!=0
local X_ji_zero  = `r(N)'
count if X_ij!=0
local obs  = `r(N)'
local X_ji_zero_rate = string(100*`X_ji_zero'/`obs',"%2.0f")
display "$ \ell_{nk}=0$ for `X_ji_zero_rate'\% of tract pairs with $ \ell_{kn}>0$."
file open outputfile using "`output'", write replace
file write outputfile "$ \ell_{nk}=0$ for `X_ji_zero_rate'\% of tract pairs with $ \ell_{kn}>0$." _n
file close outputfile
end

cap program drop asymmetriczeros_robustness
program define asymmetriczeros_robustness
syntax , output(string)
bys i: egen X_i_total = total(X_ji)
bys j: egen X_j_total = total(X_ij)
count if X_ji==0 & X_ij!=0 & inrange(X_i_total/X_j_total,0.9,1.1)==1
local X_ji_zero_robust  = `r(N)'
count if X_ij!=0 & inrange(X_i_total/X_j_total,0.9,1.1)==1
local obs_robust  = `r(N)'
local X_ji_zero_rate_robust = string(100*`X_ji_zero_robust'/`obs_robust',"%2.0f")
display "$ \ell_{nk}=0$ for `X_ji_zero_rate_robust'\% of tract pairs for which $ \ell_{kn}>0$ and total employment in $ k$ and $ n$ differs by 10\% or less."
file open outputfile using "`output'", write replace
file write outputfile "$ \ell_{nk}=0$ for `X_ji_zero_rate_robust'\% of tract pairs for which $ \ell_{kn}>0$ and total employment in $ k$ and $ n$ differs by 10\% or less." _n
file close outputfile
end

asymmetriczeros using "../input/lodes_`1'_`2'.dta", output("../output/`1'_`2'_asymmetriczeros.tex") 
asymmetriczeros_robustness, output("../output/`1'_`2'_asymmetriczeros_robust.tex") 

