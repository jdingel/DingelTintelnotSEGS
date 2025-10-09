# Finite model equilibrium solver

This task solves for the commuting equilibrium with finitely many individuals, per Definition 4.2 in the paper.
The parameters are L (total population), &alpha; (land expenditure share), &epsilon; (commuting elasticity), A\_n (workplacep productivity), T\_k (residential land endowment), delta\_{kn} (commuting costs), and beliefs (about wages and land prices).

The procedure is, given all these parameter values, to:

1. Draw a realization of ell_{kn} from that process [&alpha;, &epsilon;, &delta;, and beliefs] that sums to L
2. Solve for equilibrium wages and land prices {w\_n,r\_k} given that realization ell\_{kn} and {A\_n,T\_k}.

This task is written in Julia.

`finitemodel_programs.jl` contains three functions:

- `MNL_draw` generates realization of ell_{kn} given &alpha;, &epsilon;, &delta;, and beliefs
- `freetrade_equilibrium_solver` solve for wages given A\_n, ell\_{kn}, &sigma;, and &alpha;
- `land_rent_solver` solves for land prices given ell_{kn}, wages, T\_k, and &alpha;

`finitemodel_demo.jl` provides an example.

There is no Makefile because, while I have written the above functions, we have not yet defined any output.
