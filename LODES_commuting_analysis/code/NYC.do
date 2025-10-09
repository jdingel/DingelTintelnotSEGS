clear all
set more off

do "programs_descriptives.do"

use "../input/lodes_NYC_2014.dta", clear
count_cells_and_people, output("../output/NYC_2014_count_cells_and_ppl.tex")
use "../input/lodes_NYC_2014.dta", clear
shareofcommuters, output_share1("../output/NYC_2014_share1.tex") output_share5("../output/NYC_2014_share5.tex") geoname("New York City")
use "../input/lodes_NYC_2010.dta", clear
shareofcommuters, output_share1("../output/NYC_2010_share1.tex") output_share5("../output/NYC_2010_share5.tex")  output_share5_slides("../output/NYC_2010_share5_slides.tex") geoname("New York City")
use "../input/lodes_NYC_2010.dta", clear
employmentconcentration, output_texfile(../output/NYC_2010_mediantract_employees.tex) geoname("New York City")
