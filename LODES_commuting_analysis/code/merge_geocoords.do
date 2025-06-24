foreach package in geodist {
    capture which `package'
    if _rc==111 ssc install `package'
}

cap program drop merge_geocoords
program define merge_geocoords
syntax, geo(string) [keepifnumlist(string)] [data_MSP(string)]

//Load geographic coordinates 
insheet using `geo', clear
tostring geoid, replace format("%11.0f")

if "`data_MSP'"!="" keep if inlist(substr(geoid,1,5),"27053","27123","27003","27163","27139","27171","27019","27141") | inlist(substr(geoid,1,5),"27025","27059","27095","27143","27037","27079","55109","55093") 

if "`keepifnumlist'"!="" foreach element of numlist `keepifnumlist' {
	local keepiflist = `"`keepiflist'"' + `""`element'""' + ", " //Construct a list of strings from the numlist
}
if "`keepifnumlist'"!="" local keepiflist = substr(`"`keepiflist'"',1,length(`"`keepiflist'"')-2) //Drop the final unnecessary comma
if "`keepifnumlist'"!="" keep if inlist(substr(geoid,1,5),`keepiflist')==1 
rename (geoid intptlat intptlong) (i lat_i lon_i)
keep i lat_i lon_i

//Create all possible pairs 
tempfile tf_i
save `tf_i'
rename (i lat_i lon_i) (j lat_j lon_j)
cross using `tf_i'
geodist lat_i lon_i lat_j lon_j, gen(dist_ij)
drop lat_i lon_i lat_j lon_j

end


