% This script is almost entirely borrowed from the replication code for 
% Chen, Fernández-Val, and Weidner (2021, Journal of Econometrics) which proposed
% the algorithm for maximum likelihood estimation of interactive fixed effects.
% [Originally labeled "ApplicationTradeData.m"]
%
% The modifications made, other than switching to the LODES commuting data we analyze, were 
%   1) to initialize to random start values for the parameters, which allows for easier 
%       parallelization (and setting repMIN and repMAX, the number of starts tried in 
%       IFE_MLE.m, to 1),
%   2) simplification of the data-processing steps, which had to account for missing values, and
%   3) removing the analysis/comparison to PPML. A similar function is served by other 
%       aspects of the project

function [] = int_fe_est(R, seed, MAX_STEPS, precision_beta, ...
    precision_fes, year)
    % Default year: 2010
    if (nargin < 6)
        year = "2010"
    end

    % Read input arguments as numeric
    R = str2num(R)
    seed = str2num(seed)
    MAX_STEPS = str2num(MAX_STEPS)
    precision_beta = str2num(precision_beta)
    precision_fes = str2num(precision_fes)

    % Read in LODES data
    data = csvread(append('../temp/nyc', year, '_lodes.csv'), 1, 0);

    % Assert that the dataframe is correct
    assert(length(unique(data(:, 4))) == 2) % impute variable is either 0 or 1
    assert(min(data(:, 5)) >= 1) % delta is always 1 or larger
    assert(max(data(:, 6)) < 10) % log delta shouldn't exceed 10

    N = size(unique(data(:, 1, :)), 1); % Number of origin tracts
    T = size(unique(data(:, 2, :)), 1); % Number of destination tracts
    K = 1;                              % Number of regressor = 1: only log_delta

    % Define N x T matrix of normalized outcomes Y (commuting flows), N x T matrix of regressors X (commuting costs):
    Y = reshape(data(:, 3), N, T);
    X = reshape(data(:, 6, :), 1, N, T);

    % Initialize background:
    lambda_known = ones(N,1);           % Known factor loading, corresponding to origin dummies
    f_known = ones(T,1);                % Known factors, corresponding to destination dummies
    Rex1 = size(lambda_known,2);
    Rex2 = size(f_known,2);
    weight = ones(N,T);
    repMIN = 1;                         % Multistarts are governed external to the estimation script,
    repMAX = 1;                         % and so we do repeat inside of IFE_MLE
    dist = 'Poisson';

    % Using "seed", randomly initialize starting values for all parameters in broadly plausible ranges
    rng(seed)
    beta_init = -10 * rand(1);
    alpha_init = -5 + 8 * rand(N, 1); % origin FE
    gamma_init = -5 + 8 * rand(T, 1); % destination FE
    lambda_init = -2 + 4 * rand(N, R);
    f_init = -2 + 4 * rand(T, R);

    % Set convergence mode: beta-only (no FE convergence requirement) or 
    % full (additive and interactive FE convergence requirement)
    if precision_fes < 1
        disp("FULL CONVERGENCE MODE, TOLERANCES:")
        disp(append("beta: ", num2str(precision_beta)))
        disp(append("Fixed effects: ", num2str(precision_fes)))
    else
        disp("BETA-ONLY CONVERGENCE MODE, TOLERANCE:")
        disp(append("beta: ", num2str(precision_beta)))
    end

    suffix = append(num2str(seed), ".csv");
    disp(append("Initial value of beta: ", num2str(beta_init)))

    % Maximum likelihood estimation
    [beta,alpha,gamma,lambda,f,exitflag,obj,~,Var_beta] = ...
            IFE_MLE(Y, X, weight, lambda_known, f_known, R, ...
            precision_beta, precision_fes, repMIN, repMAX, MAX_STEPS, ...
            beta_init, alpha_init, gamma_init, lambda_init, f_init);

    % Save parameter estimates and computed variance
    csvwrite(append("../temp/multistarts/", year, "/fe_i_", num2str(R), "_", suffix), alpha)
    csvwrite(append("../temp/multistarts/", year, "/fe_j_", num2str(R), "_", suffix), gamma)
    csvwrite(append("../temp/multistarts/", year, "/beta_", num2str(R), "_", suffix), beta)
    csvwrite(append("../temp/multistarts/", year, "/beta_var_", num2str(R), "_", suffix), Var_beta)
    csvwrite(append("../temp/multistarts/", year, "/obj_", num2str(R), "_", suffix), obj)

    % If interactive fixed effects are included, save them as well
    if R > 0
        csvwrite(append("../temp/multistarts/", year, "/fe_i_interact_", num2str(R), "_", suffix), lambda)
        csvwrite(append("../temp/multistarts/", year, "/fe_j_interact_", num2str(R), "_", suffix), f)
    end
end
