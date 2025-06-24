// Use LODES NYC data files to restrict attention to workers who reside in NYC
use "../input/lodes_NYC_2010.dta",clear
collapse (sum) employment_2010 = X_ij, by(j)
tempfile tf2010 tf_OD
save `tf2010'
use "../input/lodes_NYC_2012.dta",clear
collapse (sum) employment_2012 = X_ij, by(j)
merge 1:1 j using `tf2010', nogen
rename j geoid11

//2010-2012 changes in NYC
gen employment_diff = employment_2012 - employment_2010
gen employment_growth = (employment_2012 - employment_2010)/employment_2010
levelsof geoid11 if (inrange(employment_growth,0.125,.) & inrange(employment_2010,400,.) & inrange(employment_diff,400,.)), local(geoid11_growers_list)
cap rm ../output/nyc_20102012_spikes_list.txt
foreach place in `geoid11_growers_list' {
	shell echo `place' >> ../output/nyc_20102012_spikes_list.txt
}
