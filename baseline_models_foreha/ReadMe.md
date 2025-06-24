# baseline_models_foreha
This task produces model specifications sufficient for computing counterfactual outcomes using exact hat algebra.
The sufficient statistics are the model's elasticities, baseline shares, and (optional) nesting structure.

## code 

Each packing script executes three steps:
- (1) Compute or load labor quantities $\ell_{kn}$ and wages $w_n$.
- (2) Compute the baseline income according to $y_{kn} = (\ell_{kn} / \bar{\delta}_{kn}) \times w_n$.
- (3) Pack elasticities $\alpha$, $\epsilon$, $\sigma$, $\eta$, and $\zeta$, along with the nested structure `nests`, and baseline shares of $\ell$ and $y$ into a `NamedTuple`.

To execute the first step:
- `pack_cbm_models.jl`, `pack_ife_models.jl`: 
    Compute the baseline equilibrium prices $r_k, w_n$ and quantities $\ell_{kn}$ based on the exogenous primitives $T_k, A_n, \delta_{kn}$.
- `pack_csp_models.jl`: 
    Load the observed baseline commuting matrix $\ell_{kn}$ and the observed wages $w_n$.
- `pack_svd_models.jl`: 
    Load the approximated baseline commuting matrix $\ell_{kn}$ and the observed wages $w_n$.

## output
- `../output/model_list.csv`: a list of model specifications.
- `model_%.jld2`: contains a tuple of { $\alpha, \epsilon, \sigma, \eta, \zeta$, nests, $\ell$ -share,  $y$ -share}.

## input
- `baseline_equilibrium_outcomes%.jld2`: contains baseline equilibrium wages, rents, and commuting flows.
- `primitives_nyc%.jld2`: contains $\bar{\delta}$ variation (i.e., distance, pooled data, NTA, and nested logit).
- `%elasticity.csv`: contains the commuting elasticity.
- `nyc_delta_bar.jld2`: contains commuting time.
- `nyc2010_wage.dta`, `NTA_avg_wages_2010.dta`, and `nyc_avg_wage_2008_2010.dta`: contain observed wages.