* 1. For how many pairs of US counties is the reported number of commuters less than 100?
* 2. heatplot the transition matrix

clear all
set scheme s2color
capture which heatplot //This package was installed by setup_environment task
capture which palettes.hlp //This package was installed by setup_environment task

graph set window fontface "Times New Roman"

// Task: For how many pairs of US counties is the reported number of commuters less than 100?
use if ID_h!=ID_w using "../output/ACS_20062010_dist_within120km.dta", clear
count if X_ij>0
local count_postivie = `r(N)'
count if X_ij>0 & X_ij<100 
local count_less100 = `r(N)'
local pct = `count_less100'*100/`count_postivie'
di `pct'

use if ID_h!=ID_w using "../output/ACS_20112015_dist_within120km.dta", clear
count if X_ij>0
local count_postivie = `r(N)'
count if X_ij>0 & X_ij<100 
local count_less100 = `r(N)'
local pct = `count_less100'*100/`count_postivie'
di `pct'

// Task: heatplot for US counties representing (binned) transition matrix
// ACS20062010
use "../output/ACS_20062010_dist_within120km.dta", clear
keep if ID_h!=ID_w
rename X_ij X_ij0610
gen ID_h_1115 = ID_h
gen ID_w_1115 = ID_w
// manually replace county changes across years
// source: https://www.census.gov/programs-surveys/acs/technical-documentation/table-and-geography-changes.replace_year_here.html
replace ID_h_1115 = "02158" if ID_h == "02270"
replace ID_w_1115 = "02158" if ID_w == "02270"
replace ID_h_1115 = "46102" if ID_h == "46113"
replace ID_w_1115 = "46102" if ID_w == "46113"
replace ID_h_1115 = "51019" if ID_h == "51515"
replace ID_w_1115 = "51019" if ID_w == "51515"
bys ID_h_1115 ID_w_1115: egen count_pair = count(X_ij)
assert ID_h_1115=="51019" | ID_w_1115=="51019" if count_pair==2
collapse (sum) X_ij0610 (mean) dist_km, by(ID_h_1115 ID_w_1115)
drop if ID_h_1115 == ID_w_1115
assert inrange(dist_km,0,120)==1 
tempfile ACS0610
save `ACS0610'

// ACS20112015
use "../output/ACS_20112015_dist_within120km.dta", clear
keep if ID_h!=ID_w
rename X_ij X_ij1115
rename ID_* ID_*_1115

// match 
merge 1:1 ID_h_1115 ID_w_1115 using `ACS0610', keep(match) nogen
drop MOE dist_km
recode X_ij0610 (0 = 0) (1/30=1) (31/50=2) (51/70=3) (71/90=4) (91/110=5) (111/500=6) (501/1500=7) (1500/10e6=8), ///
	gen(category0610) test
assert mi(category0610)==mi(X_ij0610) & inlist(category0610,0,1,2,3,4,5,6,7,8)==1

recode X_ij1115 (0 = 0) (1/30=1) (31/50=2) (51/70=3) (71/90=4) (91/110=5) (111/500=6) (501/1500=7) (1500/10e6=8), ///
	gen(category1115) test
assert mi(category1115)==mi(X_ij1115) & inlist(category1115,0,1,2,3,4,5,6,7,8)==1

// text output
count if X_ij0610==0 & X_ij1115>0
local zero_to_pos = `r(N)'
count if X_ij0610>0 & X_ij1115==0
local pos_to_zero = `r(N)'
count if X_ij0610==0
local num_zero = `r(N)'
local frac_zero_to_pos = round((`zero_to_pos'/`num_zero')*100)
shell echo `frac_zero_to_pos'% > ../output/ACS_frac_zero_to_pos.tex
local frac_pos_to_zero = round((`pos_to_zero'/`num_zero')*100)
shell echo `frac_pos_to_zero'% > ../output/ACS_frac_pos_to_zero.tex

count if category0610==4 & category1115==4
local samebin_7190=`r(N)'
count if category0610==4
local bin_7190=`r(N)'
local frac_samebin_7190 = round((`samebin_7190'/`bin_7190')*100)
shell echo `frac_samebin_7190'% > ../output/ACS_frac_samebin_7190.tex

// heatplot
tab category0610 category1115, matcell(freq)
mat input one = (1\1\1\1\1\1\1\1\1)
mat rowtot = freq*one
count
local count_total=`r(N)'
di `count_total'
mat initial_share = rowtot*100/79196
mat rowpct = inv(diag(rowtot))*freq

mat transition_matrix = initial_share,rowpct
mat rownames transition_matrix = 0 1-30 31-50 51-70 71-90 91-110 111-500 501-1,500 >1,500
mat colnames transition_matrix = "Initial Share(%)" 0 1-30 31-50 51-70 71-90 91-110 111-500 501-1,500 >1,500


heatplot transition_matrix,  ///
	xscale(titlegap(*15)) ///
	xsize(11)  cuts(0.1 0.2 0.5 1)  color(LemonChiffon Orange*0.5 Orange DarkOrange Red*1.2 White)  ///
	values(format(%3.2f) mlabsize(vlarge)) graphregion(color(white)) xlabel(,labsize(vlarge)) ylabel(,labsize(vlarge)) xtitle("2011-2015",size(huge)) ytitle("2006-2010",size(huge)) legend(off) xscale(alt)
graph export "../output/heatmap_transition_matrix.eps", replace

// histogram to justify the arbitrary choice of bins
hist X_ij0610 if inrange(X_ij0610,0.1,150)==1, ///
	start(0) width(1) graphregion(color(white)) xtitle("Commuting flows in 2006-2010")
graph export "../output/hist_ACS_arbitrary_bin.eps", replace

// heatplot integer instead of category
keep if X_ij0610<=100 & X_ij1115<=100
bys X_ij0610: egen count_early = count(X_ij0610)
bys X_ij0610 X_ij1115: egen count_later = count(X_ij1115)
gen prob = count_later/count_early
collapse (first) prob, by(X_ij0610 X_ij1115)
fillin X_ij0610 X_ij1115
recode prob .=0 if _fillin==1
drop _fillin
heatplot prob X_ij0610 X_ij1115, ///
	keylabels(,interval) cuts(0.005 0.01 0.02 0.03 0.1 0.2 0.3 0.4 0.8) xdiscrete(1) ydiscrete(1) ///
	legend(title("Transition Prob", size(small)) subtitle("")) graphregion(color(white)) color(YlOrRd) xtitle("2011-2015",size(vlarge)) ytitle("2006-2010",size(vlarge)) xlabel(,labsize(medium)) ylabel(,labsize(medium))  
graph export "../output/heatmap_integer_0_100.eps", replace 
