# Ex Post Regret

This task investigates how often and how much individuals would prefer, given realized equilibrium prices, a different residence-workplace pair over their choice made under continuum-case rational expectations.
See Section 4.4 in the paper for a detailed description.

It is a computationally expensive task that needs to be run on the server. However, this task is parallelizable by using `make -j`. 

## Output
* `expost_results.tex`: A table displaying the ex post regret results.
* `text_expost_regret.tex`, `text_intro_expost_regret.tex`: Description about the percent of individuals who would and would not want to change their residence-workplace choice.
* `dispersion_expost_(wage | rent).csv`: Price dispersion.

## Temp
* `individuals_choices_s$(s)_b$(b).csv`: Individuals' location choices given the mean utility and simulated idiosyncratic preferences.
* `realized_commuting_flows_s$(s).dta`: Realized commuting flows given simulated idiosyncratic preferences.
* `expost_individuals_choices_s$(s)_b$(b).csv`: Individuals' location choices given the realized prices.

## Code
* `calculate_util.jl`: Computes the mean utility of living in $k$ and working in $n$.
* `simulate_individuals_choices.jl`: Simulates individual utility and stores their location choices given price beliefs and idiosyncratic preferences.
* `expost_dispersion.jl`: Computes price dispersion.
* `aggregate_choices.do`: Aggregates individuals' chosen choices into tract-to-tract commuting flows.
* `find_individuals_expost_optimal_choices.jl`: (1) Computes the mean utility of living in $k$ and working in $n$ given the realized prices. (2) Computes individuals' choices that optimize their ex-post utility.
    * Remark: We only compute ex post regret over places with positive residents and positive employment.
* `calculate_regret_magnitude.do`: Computes the magnitude of ex post regret (i.e., conditional on wanting to switch, median ex-post regret).


## Input
* `nyc2010_time_elasticity.csv`: The commuting time elasticity in 2010.
* `nyc2010_lodes_wzero_wdelta.dta`: Commuting flows in NYC 2010, with zero commuting flows.
* `primitives_nyc2010_time.jld2`: The calibrated primitives (land endowment, productivity, wage & rent beliefs, commuting cost matrix, and population).
* `finitemodel_programs.jl`: Script that draws finite labor allocation and solves for trade-equilibrium prices.
* `baseline_equilibrium_outcomes_%.jld2`: Contains baseline equilibrium outcomes. 
