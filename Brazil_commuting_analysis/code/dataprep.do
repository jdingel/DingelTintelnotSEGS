clear all

//Load data
use "../input/CENSO10_commuting.dta", clear
assert substr(string(origin),3,4)!="9999"
drop if substr(string(destination),3,4)=="9999"  //These are not valid municipios.
gen municipio6 = origin
merge m:1 municipio6 using "../input/municipios_2010_withcoordinates.dta", assert(match) keepusing(lat lon area_km2) nogen
rename (lat lon area_km2) (lat_i lon_i area_km2_i)
drop municipio6
gen municipio6 = destination
merge m:1 municipio6 using "../input/municipios_2010_withcoordinates.dta", assert(match) keepusing(lat lon area_km2) nogen
drop municipio6
rename (lat lon area_km2) (lat_j lon_j area_km2_j)
rename (origin destination x_od) (i j X_ij)
geodist lat_i lon_i lat_j lon_j, gen(dist_ij)
gen dist_log_ij = log(dist_ij)
gen X_log_ij = log(X_ij)
label var dist_log_ij "Distance (log)"

tempfile tf0
save `tf0', replace
drop area_km2_?
save "../output/commutematrix_posflows_2010_withdistances.dta", replace

//What should the distance cutoff be?
assert X_ij!=0

twoway (kdensity dist_log_ij if i!=j, yaxis(1) color(blue)) , graphregion(color(white)) name(posflow_logdistances, replace) ytitle("Density of municipio pairs with positive commuters") ytitle("Density of municipio pairs", axis(1)) xtitle(Log distance) legend(off)
twoway (kdensity dist_ij if i!=j, yaxis(1) color(blue)) , graphregion(color(white)) name(posflow_distances, replace) ytitle("Density of municipio pairs with positive commuters") ytitle("Density of municipio pairs", axis(1)) xtitle(Distance in kilometers) legend(off)

summarize dist_ij if i!=j [w=X_ij], d //Weight by number of commuters
twoway (kdensity dist_log_ij if i!=j [w=X_ij], yaxis(1) color(blue)) , graphregion(color(white)) name(posflow_logdistances, replace) ytitle("Density of municipio pairs with positive commuters") ytitle("Density of municipio pairs", axis(1)) xtitle(Log distance) legend(off)
twoway (kdensity dist_ij if i!=j [w=X_ij], yaxis(1) color(blue)) , graphregion(color(white)) name(posflow_distances, replace) ytitle("Density of municipio pairs with positive commuters") ytitle("Density of municipio pairs", axis(1)) xtitle(Distance in kilometers) legend(off)

//What is the geographic area of these municipios that are reporting 1,000 km commutes?
use `tf0', clear
summarize area_km2_? if inrange(dist_ij,1000,.)==1
egen area_km2_max = rowmax(area_km2_i area_km2_j)
summarize area_km2_max if inrange(dist_ij,1000,.)==1

//br if inrange(dist_ij,1000,.)==1 & area_km2_max<100
