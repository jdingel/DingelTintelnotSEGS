clear all

set scheme s2color

assert inlist("`1'","DetroitUA","NYC","MSP")
assert inlist("`2'","2010","2014")

graph set window fontface "Garamond"
graph set eps fontface "Times"

use "../input/lodes_`1'_`2'.dta",clear
summarize X_ij, d
local topcodevalue = ceil(`r(p99)'/10) * 10
local stepsize = round(`topcodevalue'/10,5)*2
shell echo `stepsize'

gen X_ij_topcoded = min(X_ij,`topcodevalue')
sort X_ij
egen pop = total(X_ij)
gen X_ij_cum_share = sum(X_ij)/pop
gen X_ij_jumpflag = X_ij_topcoded != X_ij_topcoded[_n+1]
recode X_ij_jumpflag 0=1 if inlist(_n,1,_N)

graph twoway (hist X_ij_topcoded, start(1) width(1) lcolor(blue) color(white) fraction graphregion(color(white)) yaxis(1)) ///
        (line X_ij_cum_share X_ij_topcoded if X_ij_jumpflag, color(black) graphregion(color(white)) yaxis(2) connect(stairstep)), ///
        xtitle(Number of individuals, size(large)) ytitle("", axis(1)) ytitle("", axis(2)) ///
        xlabel(0(`stepsize')`topcodevalue',labsize(*`labsizeinflate')) ylabel(0(0.2)1 ,labsize(*`labsizeinflate')) ///
        legend(region(lstyle(none) lcolor(white)) label(1 "Fraction of tract pairs") label(2 "Cumulative share of commuters") pos(5) order(1 2) )
graph export "../output/histogram_`1'_`2'_positive_w_shares.eps", replace fontface(Times)
