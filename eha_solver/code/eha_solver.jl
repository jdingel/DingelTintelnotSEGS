# Fixed-point iteration
function eha_solver(ŵ_guess, r̂_guess, model_params, exo_changes, comp_params; show_every=nothing)

    # compute counterfactual prices and quantities
    @unpack l_share, y_share, σ, α, η, ζ, nests = model_params
    @unpack Ā̂, T̂, δ̄̂, λ̂ = exo_changes
    @unpack tol, damp_low, damp_high, max_iter = comp_params
    
    ε_compute = (ζ == 1.0) ? model_params.ε : model_params.ε_ring / ζ
    K = length(r̂_guess)
    N = length(ŵ_guess)

    @assert all(!iszero, sum(l_share, dims = 1)) "Error: Zero employment"
    @assert all(!iszero, sum(l_share, dims = 2)) "Error: Zero residents"
    @assert all(!iszero, sum(y_share, dims = 1)) "Error: Zero workplace income"
    @assert all(!iszero, sum(y_share, dims = 2)) "Error: Zero residential income"
    @assert η >= 0.0
    @assert 0.0 <= ζ <= 1.0
    @assert (ζ == 1.0 && nests === nothing) || (ζ < 1.0 && nests != nothing)
    @assert (N == 1 && size(l_share) == (K,)) || size(l_share) == (K,N)
    @assert (N == 1 && size(y_share) == (K,)) || size(y_share) == (K,N)
    @assert 0.0 <= damp_low <= damp_high <= 1.0

    y_share_per_dest = y_share ./ sum(y_share, dims = 1)
    y_share_per_orig = y_share ./ sum(y_share, dims = 2)
    zero_idx = l_share .== 0.0

    # pre-allocation
    element = ones(K, N)
    element_adj = ones(K, N)
    l̂_old = ones(K, N)
    ŵ_old = copy(ŵ_guess)
    r̂_old = copy(r̂_guess)
    ŵ_imp = ones(N)
    r̂_imp = ones(K)
    ŷ_old = ones(K, N)
    ŷn_adj = ones(K, N)
    ŷk_adj = ones(K, N)
    ŷn_adj_vec = ones(N)
    ŷk_adj_vec = ones(K)
    inner = (ζ == 1.0) ? nothing : ones(length(nests))
    l_inner_share = (ζ == 1.0) ? nothing : ones(K, N)
    l_outer_share = (ζ == 1.0) ? nothing : ones(length(nests))

    iter = 0
    diff = Inf
    @time while diff > tol

        # compute l̂
        if all(x -> x == 1.0, [maximum(δ̄̂), minimum(δ̄̂), maximum(λ̂), minimum(λ̂), ζ])         
            element .= transpose(ŵ_old).^(ε_compute) .* r̂_old.^(- α * ε_compute)
            @. element_adj .= element .* l_share
            l̂_old .= element ./ sum(element_adj)
        elseif ζ == 1.0
            element .= transpose(ŵ_old).^(ε_compute) .* r̂_old.^(-α*ε_compute) .* δ̄̂.^(-ε_compute) .* λ̂.^(-ε_compute)
            @. element_adj .= element .* l_share
            l̂_old .= element ./ sum(element_adj)
        else
            # compute P(kn|Bz) and P(Bz)            
            for (idx, xy) in enumerate(nests)
                l_inner_share[xy] .= l_share[xy] ./ sum(l_share[xy]) 
                l_outer_share[idx] = sum(l_share[xy]) 
            end
            element .= transpose(ŵ_old).^(ε_compute) .* r̂_old.^(-α*ε_compute) .* δ̄̂.^(-ε_compute) .* λ̂.^(-ε_compute)
            for (idx, xy) in enumerate(nests)
                element_adj[xy] .= element[xy] .* l_inner_share[xy]
                inner[idx] = sum(element_adj[xy]) # scalar
                element[xy] .= element[xy] * (inner[idx].^(ζ-1))
            end
            l̂_old .= element ./ sum(l_outer_share .* (inner.^ζ)) # shape: K * N
        end

        l̂_old[zero_idx] .= 1.0
        ŷ_old .= l̂_old .* transpose(ŵ_old) ./ δ̄̂

        # Update ŵ_imp
        @. ŷn_adj .= ŷ_old .* y_share_per_dest
        ŷn_adj_vec = sum(ŷn_adj, dims = 1)[:]
        pow = (σ == Inf) ? (1 - 1/(η+1)) : (1 - σ/((σ-1) * (η+1)))
        @. ŵ_imp .= Ā̂ .^ (1/(η+1)) .* ŷn_adj_vec .^ pow

        # fix ŵ[1] = 1
        @assert isnan(ŵ_imp[1]) == false && iszero(ŵ_imp[1]) == false
        ŵ_imp = ŵ_imp/ŵ_imp[1]

        # Compute implied r̂
        @. ŷk_adj .= ŷ_old .* y_share_per_orig
        ŷk_adj_vec .= sum(ŷk_adj, dims = 2)
        @. r̂_imp .= ŷk_adj_vec ./ T̂

        diff_w = maximum(abs.(ŵ_old .- ŵ_imp))
        diff_r = maximum(abs.(r̂_old .- r̂_imp))
        diff = maximum([diff_w, diff_r])

        if show_every != nothing  && mod(iter, show_every) == 1
            println("Iteration $iter: Diff between iterations = ", string(round(diff, digits=6)))
        end
        
        # update damping parameter
        damp = (diff < 1e-6) ? damp_high : damp_low

        # compute next-step price
        @. ŵ_old .= (1 - damp) .* ŵ_old .+ damp .* ŵ_imp
        @. r̂_old .= (1 - damp) .* r̂_old .+ damp .* r̂_imp

        iter = iter + 1
        @assert iter <= max_iter println("Error: Reached maximum number of iterations")
    end
    println("EHA solver converged after $iter iterations.")
    return ŵ_old, r̂_old, l̂_old
end