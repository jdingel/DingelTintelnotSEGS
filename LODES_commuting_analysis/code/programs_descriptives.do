clear all
set more off

cap program drop count_cells_and_people
program define count_cells_and_people
syntax, output(string)
confirm variable i j X_ij
egen tag_i = tag(i)
egen tag_j = tag(j)
count if tag_i==1
local count_i = r(N)
local count_i_str = string(`count_i',"%5.0fc")
count if tag_j==1
local count_j = r(N)
local count_j_str = string(`count_j',"%5.0fc")
local matrix_cells = `count_i' * `count_j'
local matrix_cells_str = string(`matrix_cells',"%10.0fc")
shell echo "Commuting matrix contains `matrix_cells_str' cells: `count_i_str' origins and `count_j_str' destinations." > `output'
collapse (sum) total = X_ij
summarize total
local tot_ppl = string(`r(mean)', "%10.0fc")
shell echo "Commuting matrix contains `tot_ppl' people." >> `output'
local average_cell = string(`r(mean)' / `matrix_cells',"%3.2f")
shell echo "Average cell contains `average_cell' commuters." >> `output'

end

cap program drop shareofcommuters
program define shareofcommuters
syntax, output_share1(string) output_share5(string) geoname(string) [output_share5_slides(string)]
confirm variable i j X_ij
egen total = total(X_ij)
gen byte lessthanfive = inrange(X_ij,0,5)
bys lessthanfive: egen total5 = total(X_ij)
tab lessthanfive total5
gen byte onlyone = (X_ij==1)
bys onlyone: egen total1 = total(X_ij)
tab onlyone total1
quietly summarize total1 if onlyone==1, d
local onlyone = `r(p50)'
assert `r(sd)'==0
quietly summarize total5 if lessthanfive==1, d
local lessthanfive = `r(p50)'
assert `r(sd)'==0
quietly summarize total, d
local total = `r(p50)'
assert `r(sd)'==0
local onlyone_share = string(100*`onlyone' / `total',"%4.1f")
shell echo "`onlyone_share'\% of `geoname' commuters are the sole commuter in their cell of the commuting matrix." > `output_share1'
local lessthanfive_share = string(100*`lessthanfive' / `total',"%4.1f")
if "`geoname'"=="New York City" shell echo "`lessthanfive_share'\% of `geoname' commuters have five or fewer commuters in their cell of the commuting matrix." > `output_share5'
if "`geoname'"!="New York City" shell echo "In `geoname', `lessthanfive_share'\% of commuters have five or fewer commuters in their cell of the commuting matrix." > `output_share5'
if "`output_share5_slides'"!="" shell echo "`lessthanfive_share'\% of commuters in cell with $\leq$ 5" > `output_share5_slides'

end

cap program drop employmentconcentration
program define employmentconcentration
syntax, output_texfile(string) geoname(string)
confirm variable i j X_ij
egen count_orig = tag(i)
count if count_orig==1
local tracts_count = `r(N)'
collapse (sum) X_ij, by(j)
summarize X_ij, detail 
local median_employment = `r(p50)'
local median_tract_share = string(100*(`tracts_count'-`median_employment')/`tracts_count',"%2.0f")
local tracts_count_str = string(`tracts_count',"%7.0gc")
if `median_employment' < `tracts_count' {
	shell echo "The median tract in `geoname' has `median_employment' employees working in it. Since `geoname' has `tracts_count_str' residential tracts, at least `median_tract_share'\% of locations must have zero residents commuting to this workplace." > `output_texfile'
}
end
