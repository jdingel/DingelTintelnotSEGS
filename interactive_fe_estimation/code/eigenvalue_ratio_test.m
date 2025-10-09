% This script performs the eigenvalue ratio test proposed in Chen et al. (2021),
% Algorithm 2 (p. 308).

function [] = eigenvalue_ratio_test(Rmax, year)
    if (nargin < 2)
        year = 2010
    end

    % Read numeric input arguments as numbers
    Rmax = str2num(Rmax)
    if Rmax <= 1
        writematrix(Rmax, append("../output/optimal_rank_", num2str(Rmax), "_", year, ".txt"));
    else
        % For non-trivial cases, i.e. Rmax >= 2, first construct the full factor matrix lambda
        % by multiplying the interactive fixed effects estimates from rank Rmax
        fe_i_inter = readmatrix(append('../output/fe_i_inter_', num2str(Rmax), '.csv'));
        fe_j_inter = readmatrix(append('../output/fe_j_inter_', num2str(Rmax), '.csv'));
        lambda_tilde = fe_i_inter * fe_j_inter';

        % Perform the eigenvalue ratio test
        [R_hat, eigenvalues] = er_test(lambda_tilde * lambda_tilde', Rmax)
        
        % Output eigenvalue ratio test-optimal rank
        writematrix(R_hat, append("../output/optimal_rank_", num2str(Rmax), "_", year, ".txt"));
    end


function [R_hat, eig_vals] = er_test(A, Rmax)
    % Accept as argument A = lambda * lambda', and compute the eigenvalues in decreasing order
    eig_vals = eigs(A, Rmax, 'largestreal');

    % Following Chen et al. (2021) Algorithm 2, compute the values EV(r) for each r
    EV = zeros(1, Rmax - 1);
    for r = 1:(Rmax - 1)
        EV(r) = eig_vals(r) / eig_vals(r + 1);
    end

    % Select and return the rank in {1, ..., Rmax-1} associated with the 
    % maximum value of EV
    [~, R_hat] = max(EV);
end

end