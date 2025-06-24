function shock_solver_loop(model_params, eha_comp_params,
    ŵ_guess, r̂_guess, Â_guess,
    baseline_emp_treated, 
    treatment_idx, baseline_ell_matrix, 
    observed_diff, 
    proportional_gain, outerloop_tol, mediation, outerloop_max_iter)

    @assert (length(r̂_guess), length(ŵ_guess)) == size(baseline_ell_matrix)
    @assert length(baseline_emp_treated) == length(Â_guess)
    @assert length(baseline_emp_treated) == length(treatment_idx)
    @assert length(baseline_emp_treated) == length(observed_diff)

    (K, N) = size(model_params.l_share)

    #two copies of treatment shocks for updating within the loop due to scoping rules
    treatment_shocks_old = copy(Â_guess) 
    treatment_shocks = copy(Â_guess) #needs to be copied for proper scoping
    shocks_num = length(treatment_shocks)

    # pre-allocation
    ctfl_labor_matrix = ones(K, N)
    ctfl_emp = ones(1, N)
    predicted_diff = ones(shocks_num)
    Â_full = ones(N)
    l̂_update = ones(K, N)
    ŵ_update = ones(N) 
    r̂_update = ones(K) 
    l̂_update = ones(K, N)

    error = Inf
    shock_solver_iter = 0

    while error > outerloop_tol
        # update shocks
        treatment_shocks_old = copy(treatment_shocks) #needs to be copied to update

        # update EHA solver's input
        Â_full[treatment_idx] .= treatment_shocks_old
        exo_changes = (Ā̂ = Â_full, T̂ = ones(K), δ̄̂ = ones(K, N), λ̂ = ones(K, N))

        # compute counterfactual labor allocation
        @time ŵ_update, r̂_update, l̂_update = eha_solver(ŵ_guess, r̂_guess, model_params, exo_changes, eha_comp_params)
        @assert sum(isnan.(l̂_update)) == 0 "l̂ contains NaN values"

        # use result from previous iteration to increase the speed of inner loop 
        if shock_solver_iter > 2
            ŵ_guess .= ŵ_update
            r̂_guess .= r̂_update
        end

        # compute predicted changes
        @. ctfl_labor_matrix = baseline_ell_matrix * l̂_update
        ctfl_emp .= convert(Array{Float64,2}, sum(ctfl_labor_matrix, dims=1))
        @. predicted_diff = ctfl_emp[treatment_idx] - baseline_emp_treated
        error_vector = predicted_diff - observed_diff
        error = maximum(abs.(error_vector))
        println("The error is:")
        println(error)

        # compute Percent Difference between predicted and observed outcome
        inflation_factors = ((observed_diff .+ mediation) ./ (predicted_diff .+ mediation))
        inflation_factors[inflation_factors .< 0] .= 0
        inflation_factors[inflation_factors .> 2] .= 2
        # compute new treatment shocks
        treatment_shocks = Array{Any,1}(treatment_shocks_old .* proportional_gain .+ treatment_shocks .* inflation_factors .* (1.0-proportional_gain))
    
        shock_solver_iter = shock_solver_iter + 1
        @assert shock_solver_iter <= outerloop_max_iter println("Error: Reached maximum number of iterations")
        
    end
    println("Shock solver converged after $shock_solver_iter iterations.")
    return(treatment_shocks_old)
end
