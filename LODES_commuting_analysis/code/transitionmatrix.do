* crosstab indicators for zero/positive commuting flows in two years;
* calculate the transition matrix.

clear all

assert inlist("`1'", "DetroitUA","NYC","MSP")
if "`1'"=="DetroitUA" local pairlevel="Detroit tract pairs"
if "`1'"=="NYC" local pairlevel="NYC tract pairs"
if "`1'"=="MSP" local pairlevel="MSP tract pairs"


foreach package in logout frmttable outreg {
    capture which `package'
    if _rc==111 ssc install `package'
}

* prepare data 
use "../input/lodes_`1'_2013.dta", clear
fillin i j 
rename X_ij X_ij_2013
recode X_ij_2013 .=0 if _fillin == 1
drop _fillin
tempfile df_2013
save `df_2013'

use "../input/lodes_`1'_2014.dta", clear
fillin i j
rename X_ij X_ij_2014
recode X_ij_2014 .=0 if _fillin == 1
drop _fillin

merge 1:1 i j using `df_2013', nogen

// generate an indicator equal to 1 if someone in the tract commutes to ANY origin/destination.
bys i: egen anyresident_2013 = max(inrange(X_ij_2013,1,.)==1)
bys i: egen anyresident_2014 = max(inrange(X_ij_2014,1,.)==1)
bys j: egen anyemp_2013 = max(inrange(X_ij_2013,1,.)==1)
bys j: egen anyemp_2014 = max(inrange(X_ij_2014,1,.)==1)
gen anyresident = anyresident_2013 * anyresident_2014
drop anyresident_*
gen anyemp = anyemp_2013 * anyemp_2014
drop anyemp_*

tempfile df_20132014
save `df_20132014'

* crosstab 
use `df_20132014'
gen byte X_ij_2013_nonzero = (X_ij_2013!=0)  
gen byte X_ij_2014_nonzero = (X_ij_2014!=0)

** count
tab X_ij_2013_nonzero X_ij_2014_nonzero, matcell(tab_freq)
frmttable using "../output/`1'_2013_2014_tabulatezerosfreq.tex", statmat(tab_freq) ///
		 ctitle("", "2014", "" \ "2013", "Zero", "Positive") rtitle("Zero"\ "Positive") multicol(1,2,2) ///
		 tex frag sd(0) replace
** pct
tab X_ij_2013_nonzero X_ij_2014_nonzero, cell nofreq matcell(tab_pct)
mata: st_matrix("tab_pct", (st_matrix("tab_pct")  :/ sum(st_matrix("tab_pct"))))
frmttable using "../output/`1'_2013_2014_tabulatezerospct.tex", statmat(tab_pct) ///
		 tex frag hlines(0) sd(3) replace

** zero persistent?
count if X_ij_2013_nonzero==1
local early_positive = `r(N)'
count if X_ij_2013_nonzero==1 & X_ij_2014_nonzero==0
local early_positive_later_zero = `r(N)'
local pct = string(100*`early_positive_later_zero'/`early_positive', "%2.0f")
shell echo "`pct'\% of `pairlevel' with positive flow in 2013 were zeros in 2014" > ../output/`1'_2013_2014_zeropersistence.tex

 
// transition matrix
clear
use if anyresident * anyemp == 1 using `df_20132014'
replace X_ij_2013 = 5 if inrange(X_ij_2013,5,.)==1
replace X_ij_2014 = 5 if inrange(X_ij_2014,5,.)==1
tab X_ij_2013 X_ij_2014, matcell(freq)
mat input one = (1\1\1\1\1\1) 
mat rowtot = freq*one
mat rowpct = inv(diag(rowtot))*freq
local bothzeros = string(round(rowpct[1,1]*100))
shell echo `bothzeros'% > ../output/`1'_2013_2014_bothzeros.tex
local multicol = 5+2
frmttable using "../output/`1'_2013_2014_transition_matrix.tex", statmat(rowpct) nocenter ///
	ctitle("2014" \ "2013","0","1","2","3","4","5+") multicol(1,1,`multicol') rtitles("0"\"1"\"2"\"3"\"4"\"5+") tex frag replace

shell sed -i.bak 's/\\end{tabular}\\\\/\\end{tabular}/g' "../output/`1'_2013_2014_transition_matrix.tex"
rm ../output/`1'_2013_2014_transition_matrix.tex.bak