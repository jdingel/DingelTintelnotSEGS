// map between land price change and residence distribution

clear all

cap program drop map_res
cap program define map_res
syntax, df_commute(string) treatment_tract(string) df_hat(string) variable(string) ///
			res_output(string) pricechange_output(string)  ///
			legend_pos(string) legend_format(string) [whetheroutput(string)] [max_category(string)] fc(string) county_list(string)


// map for residence distribution
use `df_commute', clear
keep if j=="`treatment_tract'"
sum X_ij if i!="`treatment_tract'",d
local X_ij_max = `r(max)'
destring i, gen(geoid11)
merge 1:1 geoid11 using "../input/geoid11_database.dta", keep(match using) keepusing(geoid11) nogen
gen county_id = substr(string(geoid11,"%11.0f"),1,5)
keep if `county_list'==1
gen temp_avail = 1

tempfile df
save `df'

local max_category_left = `max_category'-1
sum X_ij if i!="`treatment_tract'",d
local max_category_right = `r(max)'

// find the percentile where the integer lies among non-treated tracts
gen X_ij_round = round(X_ij)
bys X_ij_round: egen count = count(X_ij_round) if i!="`treatment_tract'"
collapse (first) count, by(X_ij_round)
drop if mi(count)
gen cum_count = count[1]
replace cum_count = count[_n] + cum_count[_n-1] if _n>1
gen pct = cum_count*100/cum_count[_N]

count
if "`max_category'"!="" local count_row=`max_category'
if "`max_category'"=="" local count_row = `r(N)'
local second_max_category = `count_row'-1
local cutv_list = ""
local centile_list = ""
foreach i of numlist 1/`second_max_category'{
	local centile_list`i' = pct[`i']
	local centile_list = `"`centile_list'"' + `""`centile_list`i''""' + " "
	local cutv_point`i' = X_ij[`i']+0.9 // cutoff list is left close, right open
	local cutv_list = `"`cutv_list'"' + `""`cutv_point`i''""' + " "
	local X`i' = X_ij[`i']
}
if "`max_category'"!="" local max_cutvpoit = 1.0e5
if "`max_category'"=="" local max_cutvpoit = X_ij[`count_row']+0.9
local cutvlist = `"`cutv_list'"' + `""`max_cutvpoit'""' + " "

local max_centile = 100.0
local centile_list = `"`centile_list'"' + `"`max_centile'"'

local legend_list = ""
foreach i of numlist 2/`second_max_category'{
	local p1 = string(pct[1],"%3.1f")
	local p`i' = string(pct[`i'],"%3.1f")
	local lab_index = `i'+1
	local lab_left = `i'-1
	local lab_right = `i'
	local legend_list = `"`legend_list'"' + `"lab(`lab_index' "p`p`lab_left'' - p`p`lab_right'' (`X`i'')")"' + " "
}



local max_category_plusone = `count_row'+1
if "`max_category'"!="" local max_legend = `"lab(`max_category_plusone' "p`p`second_max_category'' - max (`max_category_left'-`max_category_right')")"'
if "`max_category'"=="" local max_legend = `"lab(`max_category_plusone' "p`p`second_max_category'' - max (`X_ij_max')")"'
local legend_list = `"`legend_list'"' + `"`max_legend'"' + " "


use `df', clear
summarize X_ij if i=="`treatment_tract'"
local treatment_res = `r(mean)'
gen map_Xij = X_ij
replace map_Xij = `max_cutvpoit'+10 if i=="`treatment_tract'"

local max_label = `count_row'+2
local legendend = `" lab(`max_label' "Treatment tract, `treatment_res'") "'
local legend_list = `"`legend_list'"' + `"`legendend'"'

tempfile df_plot
save `df_plot'

keep if geoid == `treatment_tract'
quietly merge 1:1 geoid11 using "../input/geoid11_database.dta", keep(match master) nogen
quietly merge 1:m _ID using "../input/geoid11_coords.dta", keep(match master) nogen
save "../temp/treated_tract_df.dta", replace

use `df_plot'

if "`whetheroutput'"=="" maptile map_Xij, ///
	geofolder("../input") mapif(temp_avail==1) ///
	geo(geoid11) fc(`fc') ///
	spopt(legend(pos(`legend_pos') size(small)) ///
		polygon(data("../temp/treated_tract_df.dta") fcolor(black) ///
			legenda(on) leglabel("Treatment tract, `treatment_res'"))) ///
	cutv(`cutv_list') /// 
	twopt(legend(size(small) ///
		lab(1 "No residents in 2010") ///
		lab(2 "<p`p1'          (`X1')") `legend_list')) ///
	res(0.3) savegraph(`res_output') replace

shell rm ../temp/treated_tract_df.dta

// map for land price change
// prepare data
use `df_hat', clear
merge 1:1 geoid11 using "../input/geoid11_database.dta", keep(match using) keepusing(geoid11) nogen
gen county_id = substr(string(geoid11,"%11.0f"),1,5)
keep if `county_list'==1
gen temp_avail = 1

centile `variable' if geoid11!=`treatment_tract', centile(`centile_list')
gen rent_list = ""
gen rent_list_display = ""
foreach i of numlist 1/`second_max_category' {
	local rent_list`i' = `r(c_`i')'
	if `i' == 1 {
		local rent_list_display`i' = round(`rent_list`i'', 0.1)
		local rent_list_display`i' = string(`rent_list_display`i'', "`legend_format'")
	}
	else{
		local rent_list_display`i' = string(`r(c_`i')',"`legend_format'")
	}
	local rent_list = `"`rent_list'"' + `""`rent_list`i''""' + " "
	local rent_list_display = `"`rent_list_display'"' + `""`rent_list_display`i''""' + " "
}
centile `variable' if geoid11!=`treatment_tract',centile(100.0)
* local max_rent_list = `r(c_1)'
local max_rent_list_display = string(`r(c_1)',"`legend_format'")
* local rent_list = `"`rent_list'"' + `"`max_rent_list'"'
local rent_list_display = `"`rent_list_display'"' + `"`max_rent_list_display'"'

summarize `variable' if geoid11!=`treatment_tract',d
local rent_max = `r(max)'
local rent_max_label = string(`rent_max', "`legend_format'")
local rent_min_label = string(`r(min)', "`legend_format'")

summarize `variable' if geoid11==`treatment_tract'
local treatment = string(round(`r(mean)',0.00001),"`legend_format'")
replace `variable' = `rent_max'+10 if geoid11==`treatment_tract'

local legend_list2 = ""
foreach i of numlist 2/`second_max_category'{
	local lab_index2 = `i'+1
	local lab_left2 = `i'-1
	local lab_right2 = `i'
	local legend_list2 = `"`legend_list2'"' + `"lab(`lab_index2' "p`p`lab_left2'' - p`p`lab_right2'' (`rent_list_display`i'')")"' + " "
}

local max_legend_list2 = `"lab(`max_category_plusone' "p`p`second_max_category'' - max (`rent_max_label')")"'
local legend_list2 = `"`legend_list2'"' + `"`max_legend_list2'"'

local max_label2 = `count_row'+2
* local legendend2 = `" lab(`max_label' "Treatment tract, `treatment'") "'
* local legend_list2 = `"`legend_list2'"' + `" `legendend2' "'

tempfile df_plot
save `df_plot' 

keep if geoid == `treatment_tract'
quietly merge 1:1 geoid11 using "../input/geoid11_database.dta", keep(match master) nogen
quietly merge 1:m _ID using "../input/geoid11_coords.dta", keep(match master) nogen
save "../temp/treated_tract_df.dta", replace

use `df_plot'

maptile `variable', ///
		geofolder("../input") mapif(temp_avail==1) ///
		geo(geoid11) fc(`fc') ///
		spopt(legend(pos(`legend_pos') size(small)) ///
			polygon(data("../temp/treated_tract_df.dta") fcolor(black) ///
				legenda(on) leglabel("Treatment tract, `treatment'"))) ///
		cutv(`rent_list') ///
		twopt(legend(size(small) ///
			lab(1 "No residents in 2010") ///
			lab(2 "min (`rent_min_label') - p`p1' (`rent_list_display1')") ///
			`legend_list2')) ///
		res(0.3) savegraph(`pricechange_output') replace

shell rm ../temp/treated_tract_df.dta

end

