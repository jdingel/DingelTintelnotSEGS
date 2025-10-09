cap program drop select_UScounties
program define select_UScounties

drop if substr(StateID_w, 1, 1) != "0" //Restrict attention to US workplace locations
drop if StateID_h=="72"|StateID_w=="072" //Omit Puerto Rico
assert real(StateID_w) > 56 if CountyID_w=="000" //If work county isn't specified, it's not in 50 states nor DC
drop if CountyID_w=="000"

gen ID_h = StateID_h + CountyID_h
gen ID_w = substr(StateID_w, 2, 3) + CountyID_w

end



cap program drop merge_w_dist
program define merge_w_dist

//merge=3: County pair appears in both ACS commuting and NBER distance<100 miles files

//merge==1: Only in ACS data: Either it's i==j (distance data lacks i==j) or distance exceeds 120km
assert _merge==1 if ID_h==ID_w

//merge==2: Only in distance data: implies X_ij==0 since not in ACS, but guard against counties that don't exist at all in ACS data
bys ID_h: egen byte ACS_ID_h = max(_merge!=2) //Indicator that home county appears somewhere in ACS file
bys ID_w: egen byte ACS_ID_w = max(_merge!=2) //Indicator that work county appears somewhere in ACS file

count if _merge==3
count if ID_h==ID_w
count if (ACS_ID_h==1 & ACS_ID_w==1 & _merge==2)

replace dist_km=0 if ID_h==ID_w //The NBER distance file doesn't include i==j
replace X_ij=0 if (ACS_ID_h==1 & ACS_ID_w==1 & _merge==2) //The ACS file doesn't report zero flows

keep if _merge==3 | ID_h==ID_w | (ACS_ID_h==1 & ACS_ID_w==1 & _merge==2) //Drop observations that are only in the ACS file on the basis that they're more than 120km apart

drop _merge ACS_ID_h ACS_ID_w

end


// Define a program that keeps and labels common variables to avoid duplicates
cap program drop keep_label_vars
program define keep_label_vars

keep ID_h ID_w dist_km X_ij MOE
label var ID_h "County of residence (5-digit FIPS)"
label var ID_w "County of workplace (5-digit FIPS)"
label var dist "Distance between i and j (geodesic distance between centroids in kilometers)"
label var X_ij "Number of commuters residing in i and working in j"
label var MOE "Margin of error for X_ij (Census reported MOE)"
compress

end 



