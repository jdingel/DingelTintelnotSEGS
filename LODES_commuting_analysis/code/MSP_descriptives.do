clear all
do "programs_descriptives.do"

use "../input/lodes_MSP_2014.dta", clear
count_cells_and_people, output("../output/MSP_2014_count_cells_and_ppl.tex")
use "../input/lodes_MSP_2014.dta", clear
shareofcommuters, output_share1("../output/MSP_2014_share1.tex") output_share5("../output/MSP_2014_share5.tex") geoname(Twin Cities)
use "../input/lodes_MSP_2014.dta", clear
shareofcommuters, output_share1("../output/MSP_2014_share1.tex") output_share5("../output/MSP_2014_share5.tex") geoname(the Twin Cities)
use "../input/lodes_MSP_2014.dta", clear
employmentconcentration, output_texfile(../output/MSP_2014_mediantract_employees.tex) geoname(the Twin Cities)
