# Brazil commuting analysis

This task summarizes commuting patterns between Brazilian municipios in 2010.


## Output
- `commutematrix_posflows_2010_withdistances.dta`: commuting data together with information on geographical coordinates and distance.
- `Brazil_commute_2010_asymmetriczeros.tex`: Count X_ij==0 when X_ji!=0.
- `Brazil_gravity_and_zeros_60.eps`: Graphs of the log-linear gravity fit for non-zero obserations and the fraction of observations that are zero against distance.
- `municipios_are_granular.tex`: statement about granularity between Brazilian municipios in 2010.
- `municipios_total_commuters_fragment.tex`: statement about the number of commuters with commutes less than 60 km.

## Code
- `dataprep.do` loads the municipio coordinates and computes geographic distances between them
- `zeros.do` counts "asymmetric zeros", the prevalence of zeros among pairs of municipios within `dcut` kilometers, and produces graphs of the log-linear gravity fit for non-zero obserations and the fraction of observations that are zero.
- `municipios_are_granular.do`: summarize the granularity.

## Input
The two input files are drawn from the [Dingel-Miscio-Davis project](https://github.com/jdingel/DingelMiscioDavis):
`CENSO10_commuting.dta` and `municipios_2010_withcoordinates.dta`.
