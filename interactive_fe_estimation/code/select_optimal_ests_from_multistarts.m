function [] = select_optimal_ests_from_multistarts(R, B, year)
    % Default year: 2010
    if (nargin < 3)
        year = "2010"
    end

    % Read numeric input arguments as numbers
    R = str2num(R)
    B = str2num(B)

    % Read in LODES data for computing likelihood
    data = csvread(append('../temp/nyc', year, '_lodes.csv'),1,0);

    % Assert that the dataframe is correct
    assert(length(unique(data(:, 4))) == 2) % impute variable is either 0 or 1
    assert(min(data(:, 5)) >= 1) % delta is always 1 or larger
    assert(max(data(:, 6)) < 10) % log delta shouldn't exceed 10

    i = data(:, 1);
    j = data(:, 2);
    I_tracts = unique(i);
    J_tracts = unique(j);
    I = length(I_tracts); J = length(J_tracts);
    Y = reshape(data(:, 3), I, J);
    X = reshape(data(:, 6, :), I, J);

    % Initialize arrays for estimates
    fe_i = zeros(I, B);
    fe_j = zeros(J, B);
    beta = zeros(1, B);
    fe_i_inter = zeros(I, max(1,R), B);
    fe_j_inter = zeros(J, max(1,R), B);

    % Read in estimates across multistarts
    for b = 1:B
        try
            fe_i(:, b) = readmatrix(make_filepath(R, b, "fe_i", year));
            fe_j(:, b) = readmatrix(make_filepath(R, b, "fe_j", year));
            beta(b) = readmatrix(make_filepath(R, b, "beta", year));
        if R > 0
            fe_i_inter(:, :, b) = readmatrix(make_filepath(R, b, ...
                "fe_i_interact", year));
            fe_j_inter(:, :, b) = readmatrix(make_filepath(R, b, ...
                "fe_j_interact", year));
        end
        catch
            warning(append("Iteration ", num2str(b), " is missing."))
        end
    end
    % Compute likelihoods for the no-IFE and IFE cases
    if R == 0
        log_likes = arrayfun(@(b) logL_multinomial(Y, X, ones(I, 1), ...
            ones(J, 1), beta(b), fe_i(:, b), fe_j(:, b), 0, 0), 1:B);
    else
        log_likes = arrayfun(@(b) logL_multinomial(Y, X, ones(I, 1), ...
            ones(J, 1), beta(b), fe_i(:, b), fe_j(:, b), ...
            squeeze(fe_i_inter(:, :, b)), squeeze(fe_j_inter(:, :, b))), 1:B);
    end

    % Find optimal rank-R estimates
    [max_ll, max_ll_index] = max(log_likes);


    % Normalization to match PPMLHDFE additive FEs in the R = 0 case
    norm_i_adjust = (fe_i(:, max_ll_index)' * sum(Y, 2)) ./ sum(Y, 'all');
    norm_j_adjust = fe_j(:, max_ll_index)' * sum(Y, 1)' ./ sum(Y, 'all');

    final_fe_i = fe_i(:, max_ll_index) - norm_i_adjust;
    final_fe_j = fe_j(:, max_ll_index) - norm_j_adjust;

    % Grab optimal IFE estimates
    if R > 0
        final_fe_i_inter = squeeze(fe_i_inter(:, :, max_ll_index));
        final_fe_j_inter = squeeze(fe_j_inter(:, :, max_ll_index));
        final_ife = final_fe_i_inter * final_fe_j_inter';
    else
        final_fe_i_inter = zeros(I, 1);
        final_fe_j_inter = zeros(J, 1);
        final_ife = zeros(I, J);
    end

    X_ij_preperiod = pred_flows(X, sum(Y, 'all'), beta(max_ll_index), ....
                                    final_fe_i, final_fe_j, final_ife, I, J);

    % Save output
    writematrix(beta(max_ll_index), make_filepath_out(R, "beta"));
    writematrix([I_tracts, final_fe_i], make_filepath_out(R, "fe_i"));
    writematrix([J_tracts, final_fe_j], make_filepath_out(R, "fe_j"));
    writematrix([I_tracts, fe_i(:, max_ll_index)], ...
        make_filepath_out(R, "fe_i_unnorm"));
    writematrix([J_tracts, fe_j(:, max_ll_index)], ...
        make_filepath_out(R, "fe_j_unnorm"));
    writematrix([max_ll_index], make_filepath_out(R, "optimum_seed"));

    writematrix([I_tracts, final_fe_i_inter], ...
        make_filepath_out(R, "fe_i_inter"));
    writematrix([J_tracts, final_fe_j_inter], ...
        make_filepath_out(R, "fe_j_inter"));
    writematrix([data(:, [1, 2]), final_ife(:)], ...
        make_filepath_out(R, "ife_ij"));
    writetable(table(i, j, X_ij_preperiod), ...
        make_filepath_out(R, "labor_b_approx_ife_"));

    % Helper functions for I/O
    function path = make_filepath(R, b, type, year)
        path = append("../temp/multistarts/", year, "/", type, "_", num2str(R), ...
            "_", num2str(b), ".csv");
    end

    function path_out = make_filepath_out(R, type)
        if type == "labor_b_approx_ife_"
            path_out = append("../temp/", type, num2str(R), ".csv");
        else
            path_out = append("../output/", type, "_", num2str(R), ".csv");
        end
    end

    % Multinomial log-likelihood 
    function ll = logL_multinomial(Y,X,lambda_known,f_known,...
        beta,alpha,gamma,lambda,f) % This lambda is not the lambda in the Dingel & Tintelnot paper.
        Z = squeeze(X * beta) + alpha * f_known' + lambda_known * gamma' + lambda * f'; %f_known is a K×1 ones vector; lambda_known is an N×1 ones vector. lambda * f' is a K×N structural error matrix
        ll = sum(Y .* Z, 'all') - log(sum(exp(Z), 'all')) * sum(Y, 'all');
    end

    % Computing fitted values from parameter estimates
    function flows = pred_flows(X, Lbar, beta, fe_i, fe_j, ife, I, J)
        Z = squeeze(X * beta) + ...
            repmat(fe_i, 1, J) + ...
            repmat(fe_j, 1, I)' + ...
            ife;
        Y_hat = exp(Z);
        flows = reshape(Y_hat / sum(Y_hat, 'all') * Lbar, I*J, 1);
    end
end