# svd_zeros

This task creates a table that records the shares of zero commuters in the SVD and NNMF 
approximations across different ranks.


## Folder structure

`code:`

* `svd_zeros_table_generator.R`: script for producing the (bespoke) formatting for a final output table compiling the 
proportion of zeros across various ranks of SVD and NNMF approximation

`input:`

* `zeros_share_{rank}.csv`: share of zeros in the SVD-approximated matrix of given rank

* `zeros_share_nnmf_{rank}.csv`: share of zeros in the NNMF-approximated matrix of given rank

`output:`

* `svd_zeros.tex`: reports the shares of zero commuters in the SVD- and NNMF-
approximated matrices across different ranks
