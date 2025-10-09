function [] = labor_b_approx(year)
    % Construct labor_b_approx_ife_1.csv from saved parameter estimates
    if (nargin < 1)
        year = "2010";
    end
    
    if ischar(year) || isstring(year)
        year_str = year;
    else
        year_str = num2str(year);
    end
    
    R = 1;  % Fixed to rank 1
    
    % Read in LODES data
    data = csvread(append('../temp/nyc', year_str, '_lodes.csv'), 1, 0);
    
    i = data(:, 1);      % origin tract IDs
    j = data(:, 2);      % destination tract IDs
    I_tracts = unique(i);
    J_tracts = unique(j);
    I = length(I_tracts);
    J = length(J_tracts);
    Y = reshape(data(:, 3), I, J);  % observed flows
    X = reshape(data(:, 6), I, J);  % log travel times
    
    % Read in parameter estimates for rank 1
    beta = readmatrix('../input/beta_1.csv');
    fe_i_data = readmatrix('../input/fe_i_1.csv');
    fe_j_data = readmatrix('../input/fe_j_1.csv');
    
    % Extract FE-i and FE-j
    fe_i = fe_i_data(:, 2);
    fe_j = fe_j_data(:, 2);
    
    fe_i_inter_data = readmatrix('../input/fe_i_inter_1.csv');
    fe_j_inter_data = readmatrix('../input/fe_j_inter_1.csv');
    
    fe_i_inter = fe_i_inter_data(:, 2:end);
    fe_j_inter = fe_j_inter_data(:, 2:end);
    
    % Compute the IFE matrix
    final_ife = fe_i_inter * fe_j_inter';
    
    % Compute predicted flows
    Lbar = sum(Y, 'all');
    X_ij_preperiod = pred_flows(X, Lbar, beta, fe_i, fe_j, final_ife, I, J);
    
    % Save to CSV
    output_file = '../temp/labor_b_approx_ife_1.csv';
    output_table = table(i, j, X_ij_preperiod, ...
                        'VariableNames', {'i', 'j', 'X_ij_preperiod'});
    writetable(output_table, output_file);
    
    function flows = pred_flows(X, Lbar, beta, fe_i, fe_j, ife, I, J)
        % Construct Z matrix
        Z = squeeze(X * beta) + ...
            repmat(fe_i, 1, J) + ...
            repmat(fe_j, 1, I)' + ...
            ife;
        
        % Exponentiate
        Y_hat = exp(Z);
        
        % Normalize
        flows = reshape(Y_hat / sum(Y_hat, 'all') * Lbar, I*J, 1);
    end
end