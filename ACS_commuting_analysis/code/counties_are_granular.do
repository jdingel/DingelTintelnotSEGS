clear all

set scheme s2color

use "../output/ACS_20062010_dist_within120km.dta", clear
summarize X_ij
local commuters_total = string(`r(mean)'*`r(N)'/1000000,"%4.0f")
file open outputfile using "../output/counties_are_granular.tex", write replace
file write outputfile "In the 2006--2010 American Community Survey (ACS) data, there are `commuters_total' million commuters (with commutes less than 120 kilometers).%" _n
file close outputfile

file open outputfile using "../output/counties_are_granular.tex", write append
file write outputfile "\footnote{We follow \citesupp{MonteReddingRossi-Hansberg:2018} by restricting attention to county pairs that are less than 120 kilometers apart.}" _n
file close outputfile

summarize X_ij if ID_h==ID_w
local commuters_diagonal_total = string(`r(mean)'*`r(N)'/1000000,"%4.0f")
summarize X_ij if ID_h!=ID_w
local commuters_offdiagonal_total = string(`r(mean)'*`r(N)'/1000000,"%4.0f")
local commuters_offdiagonal_denom = string(`r(N)',"%6.0fc")
file open outputfile using "../output/counties_are_granular.tex", write append
file write outputfile "Of those `commuters_total' million, `commuters_diagonal_total' million live and work in the same county, so there are `commuters_offdiagonal_total' million cross-county commuters between `commuters_offdiagonal_denom' pairs of counties." _n
file close outputfile

summarize X_ij if ID_h!=ID_w
local commuters_offdiagonal_mean = string(`r(mean)',"%8.0f")
file open outputfile using "../output/counties_are_granular.tex", write append
file write outputfile "Thus, the average off-diagonal element of the county-to-county commuting matrix has `commuters_offdiagonal_mean' commuters." _n
file close outputfile

qui egen rank = rank(X_ij) if ID_h!=ID_w, field
qui summarize X_ij if inrange(rank,1,10)
local commuters_offdiagonal_top10 = string(floor(`r(mean)'*`r(N)'/1000000),"%4.0f")
file open outputfile using "../output/counties_are_granular.tex", write append
file write outputfile "However, the distribution of commuters is extremely uneven. The top 10 county pairs account for more than `commuters_offdiagonal_top10' million commuters alone." _n
file close outputfile

qui summarize X_ij if ID_h!=ID_w, d
qui summarize X_ij if ID_h!=ID_w & inrange(X_ij,0,`r(p90)'), d
local commuters_offdiag_leq_p90_mean = string(`r(mean)',"%4.0f")
file open outputfile using "../output/counties_are_granular.tex", write append
file write outputfile "For the bottom 90\% of off-diagonal observations, the mean value is only `commuters_offdiag_leq_p90_mean' commuters." _n
file close outputfile

qui summarize X_ij if ID_h!=ID_w, d
hist X_ij if ID_h!=ID_w & inrange(X_ij,0,`r(p90)'), start(0) width(1) graphregion(color(white)) name(histogram, replace) xtitle(Number of commuters) frequency

keep if ID_h!=ID_w
qui summarize X_ij, d
keep if inrange(X_ij,1,`r(p90)')
sort X_ij
egen pop = total(X_ij)
gen X_ij_cum_share = sum(X_ij)/pop
gen X_ij_jumpflag = X_ij != X_ij[_n+1]
recode X_ij_jumpflag 0=1 if inlist(_n,1,_N)
graph twoway (hist X_ij, start(0) width(1) lcolor(blue) color(white) frequency graphregion(color(white))) ///
        (line X_ij_cum_share X_ij if X_ij_jumpflag, color(black) graphregion(color(white)) yaxis(2) connect(stairstep)), ///
        xtitle(Number of individuals, size(large)) ytitle("", axis(1)) ytitle("", axis(2)) ///
        xlabel(,labsize(*`labsizeinflate')) ylabel(,labsize(*`labsizeinflate')) ///
        legend(region(lstyle(none) lcolor(white)) label(1 "Fraction of county pairs") label(2 "Cumulative share of commuters") pos(5) order(1 2))
graph export "../output/ACS_20062010_histogram_lower90.eps", replace fontface(Times)