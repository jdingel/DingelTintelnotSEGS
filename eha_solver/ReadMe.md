# eha\_solver
This task contains an Exact Hat Algebra (EHA) solver based on equation (5)-(7) and the extensions in Appendix B.7 (nested logit) and Appendix B.9 (local increasing returns).

## code
* `eha_solver.jl`: is an EHA solver for computing the counterfactual equilibrium.
It takes $\hat{\bar{A}}$, $\hat{T}$, $\hat{\bar{\delta}}$, $\hat{\lambda}$, $\ell$ -share, $y$ -share, `nests`, $\sigma$, $\epsilon$, $\alpha$, $\eta$, and $\zeta$ as given 
and uses function iteration to find the fixed point { $\hat{w}$, $\hat{r}$, $\hat{\ell}$ }.
Note that `nests` is required if $\zeta$ < 1.