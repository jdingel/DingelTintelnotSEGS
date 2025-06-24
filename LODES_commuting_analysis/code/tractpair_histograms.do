clear all

set scheme s2color

assert inlist("`1'","DetroitUA","NYC","MSP")
assert inlist("`2'","2010","2014")

if "`1'"=="DetroitUA" local areaname="Detroit"
if "`1'"=="NYC" local areaname="New York City"
if "`1'"=="MSP" local areaname="The Twin Cities"

if "`1'"=="DetroitUA" local statename="Michigan"
if "`1'"=="NYC" local statename="New York"
if "`1'"=="MSP" local statename="MN WI"


graph set window fontface "Garamond"
graph set eps fontface "Times"

use "../input/lodes_`1'_`2'.dta",clear
tempvar tv1 tv2
egen `tv1' = tag(i)
count if `tv1'==1  
local Ntracts = string(`r(N)',"%6.0fc")
shell echo -n `areaname' has `Ntracts' residential census tracts.% > ../output/`1'_`2'_number_tracts.tex
egen `tv2' = tag(j)
count if `tv2'==1
summarize X_ij, d
local topcodevalue = ceil(`r(p99)'/10) * 10
shell echo `topcodevalue' > ../output/histogram_`1'_`2'_topcode.tex

gen X_ij_topcoded = min(X_ij,`topcodevalue')
hist X_ij_topcoded, start(1) width(1) graphregion(color(white)) xtitle(Number of individuals, size(large)) ytitle(,size(large)) xlabel(,labsize(*`labsizeinflate')) ylabel(,labsize(*`labsizeinflate')) subtitle(Excluding zeros, size(large)) name(histogram_positiveflows)
hist X_ij_topcoded, start(1) width(1) graphregion(color(white)) xtitle(Number of individuals, size(large)) ytitle(,size(large)) xlabel(,labsize(*`labsizeinflate')) ylabel(,labsize(*`labsizeinflate')) title(Commuters between `areaname' tract pairs)
graph export "../output/histogram_`1'_`2'_positive.eps", replace fontface(Times)

fillin i j
recode X_ij .=0 if _fillin==1
recode X_ij_topcoded .=0 if _fillin==1
count if X_ij_topcoded==0
local zeros = `r(N)'
count
local Ntractpairs = `r(N)'

hist X_ij_topcoded, start(0) width(1) graphregion(color(white)) xlabel(,labsize(*`labsizeinflate')) ylabel(,labsize(*`labsizeinflate')) xtitle(Number of individuals, size(large)) ytitle(,size(large))  name(histogram_withzeros)
hist X_ij_topcoded, start(0) width(1) graphregion(color(white)) xlabel(,labsize(*`labsizeinflate')) ylabel(,labsize(*`labsizeinflate')) title(Commuters between `areaname' tract pairs with zeros) xtitle(Number of individuals)  note(There are zero commuters between `zeros' of  `Ntractpairs' pairs of tracts.)
graph export "../output/histogram_`1'_`2'_withzeros.eps", replace fontface(Times)


graph combine histogram_withzeros histogram_positiveflows,  graphregion(color(white)) 
graph export "../output/histogram_`1'_`2'.eps", replace fontface(Times)


//Report prevalence of zeros
gen byte X_ij_iszero = (X_ij == 0)
count if i!=j
local denom = r(N)
local denom_str = string(`denom',"%12.0gc")
shell echo There are `denom_str' tract pairs in `areaname', `statename'. > ../output/`1'_`2'_zeros_prev.tex
count if X_ij_iszero == 1 & i!=j
local numer = r(N)
local numer_str = string(`numer',"%12.0gc")
shell echo Of those pairs, `numer_str' have zero commuters between them. >> ../output/`1'_`2'_zeros_prev.tex
count if X_ij_iszero == 0 & i!=j
local nonzero_str = string(r(N),"%12.0gc")
shell echo Only `nonzero_str' have non-zero commuting flows. >> ../output/`1'_`2'_zeros_prev.tex
local percent = string(100*`numer'/`denom',"%3.0f")
shell echo `percent'\\%  > ../output/`1'_`2'_zeros_prev_slide.tex
