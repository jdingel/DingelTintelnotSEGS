# Purpose
# Given origin and destination fixed effects, δ̄, λ, ε, α, σ, η, ζ, nests, and population
# Solve A and T

function calibrate(price_beliefs, parameters, pop)
    
    @unpack δ̄, λ, α, σ, η, ζ, nests = parameters
    @unpack r_belief, w_belief = price_beliefs
    
    ε_compute = (ζ == 1.0) ? (parameters.ε) : (parameters.ε_ring/ζ)
    
    @assert size(δ̄, 1) == length(r_belief)
    @assert size(δ̄, 2) == length(w_belief)
    @assert size(δ̄) == size(λ)
    @assert 0 <= α <= 1 isless(α,1) && isless(0,α)
    @assert 1 <= σ
    @assert 0 <= ε_compute
    cond1 = ((ζ != 1.0) && typeof(nests) == (Array{Array{CartesianIndex{2},1},1}))
    cond2 = (ζ == 1.0 && nests === nothing)
    @assert cond1 || cond2

    δ = δ̄ .* λ
    replace!(δ, NaN=>Inf)

    w_relative = w_belief / w_belief[1]
    r_relative = r_belief / r_belief[1]

    # Compute commuting flows
    ell_kn_element = δ.^(-ε_compute) .* (r_relative .^ (-α*ε_compute)) .* (transpose(w_relative) .^ ε_compute)

    if ζ < 1.0
        for nest in nests
            ell_kn_element[nest] = ell_kn_element[nest] .* (sum(ell_kn_element[nest]).^(ζ-1))
        end
    end

    ell_kn_element[δ .== Inf] .= 0.0
    ell_kn = pop * ell_kn_element ./ sum(ell_kn_element)

    # individuals spend 1/δ̄ of their time working
    realized_labor = ell_kn ./ δ̄

    L_n = sum(realized_labor, dims=1)[:]
    L_n_relative = L_n / L_n[1]

    # Inner product representation for ∑ₙ
    y_k_relative = realized_labor * w_relative / (realized_labor * w_relative)[1]

    # Logbook show that 
    # Aₙ/A₀ = (wₙ/w₀)^[σ/(σ-1)] * (Lₙ/L₀)^[(1+η-σ*η)/(σ-1)]
    # Tₖ/T₀ = (r₀/rₖ) * [∑ₙ lₖₙ*(wₙ/w₀)] / [∑ₙ l₀ₙ * (wₙ/w₀)]
    # where we impose A[1] = 1, T[1] = 1
    
    # Calibrating productivity
    if η == 0.0
        if σ == Inf
            A_relative = w_relative
        else
            A_relative = (w_relative) .^(σ/(σ-1)) .* L_n_relative .^(1/(σ-1))
        end
    else
        @assert σ != Inf "Error: We don't support σ == Inf with local increasing returns."
        A_relative = (w_relative) .^(σ/(σ-1)) .* L_n_relative .^ ( (1+η-σ*η) / (σ-1))
    end

    # Calibrating land endowment
    T_relative = y_k_relative ./ r_relative

    A = A_relative
    T = T_relative
    return w_belief, r_belief, A, T
end