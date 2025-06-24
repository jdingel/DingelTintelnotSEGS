function commuting_flows(r, w, α, ε_compute, ζ,	δ_bar, λ, nests, L)
	δ = δ_bar .* λ
	(K, N) = size(δ)

	element = r.^(-α*ε_compute) * w'.^(ε_compute) .* (δ.^(-ε_compute)) # shape: K * N

	if ζ == 1.0
		element[δ .== Inf] .= 0.0
		ell_kn = L .* element ./ sum(element) # shape: K * N
	else
		@assert typeof(nests) == Array{Array{CartesianIndex{2},1},1}
		Z = length(nests)
		element_sum = ones(Z)
		ell_temp = ones(K, N)
		for (id, xy) in enumerate(nests)
			# id : nests index, id ∈ {1,...,Z}
			# xy : coordinates for the commuting matrix, (x,y) ∈ {1,..,K}×{1,..,N}
			element_sum[id] = sum(element[xy]) # scalar
			ell_temp[xy] = element[xy] .* (element_sum[id].^(ζ-1))
		end
		ell_temp[δ .== Inf] .= 0.0
		ell_kn = L .* ell_temp ./ sum(element_sum.^ζ) # shape: K * N
	end
	return ell_kn
end

function price_update(w_guess, r_guess, T, A_bar, δ_bar, λ, α, σ, ε_compute, η, L, ζ, nests, damp, tol, max_iter, verbose)

	@assert length(T) == size(δ_bar, 1)
	@assert length(A_bar) == size(δ_bar, 2)
	@assert σ > 1.0
	@assert η >= 0.0
	@assert ζ <= 1.0
	@assert length(r_guess) == length(T)
	@assert length(w_guess) == length(A_bar)
	@assert any(isfinite.(r_guess))
	@assert any(isfinite.(w_guess))
	@assert (ζ == 1.0 && nests === nothing) || (ζ < 1.0 && nests != nothing)
	@assert 0 < damp < 1

	r_old, w_old = r_guess, w_guess
	w_imp, r_imp = similar(w_guess), similar(r_guess) # initialization
	w_new, r_new = similar(w_guess), similar(r_guess) 
	iter = 0
	diff = Inf # an abitrary large number

	while diff > tol
		ell_kn = commuting_flows(r_old, w_old, α, ε_compute, ζ, δ_bar, λ, nests, L)
		L_n = sum(ell_kn ./ δ_bar, dims=1)[:]

		# Goods market clearing implies
		# w_n/w_0 = (Ā_n/Ā_0)^((σ-1)/σ) * (L_n/L_0)^((σ*η-1-η)/σ)
		if σ == Inf
			w_relative = (A_bar/A_bar[1]) .* (L_n/L_n[1]) .^ η
		else
			w_relative = (A_bar/A_bar[1]) .^((σ-1)/σ) .* (L_n/L_n[1]) .^((σ * η - 1 - η) / σ)
		end

		# Impose w[1] = 1
		w_imp = w_relative
		r_imp = α .* ((ell_kn ./ δ_bar * w_imp) ./ T)

		@assert all(isfinite.(w_imp))
		@assert all(isfinite.(r_imp))

		diff_w = maximum(abs.(w_old .- w_imp))
		diff_r = maximum(abs.(r_old .- r_imp))
		diff = maximum([diff_w, diff_r])

		if verbose && mod(iter, 20) == 1
			println(iter)
			println(diff)
		end

		# compute next-step price
		@. w_new = (1 - damp) * w_old + damp * w_imp
		@. r_new = (1 - damp) * r_old + damp * r_imp

		w_old = w_new
		r_old = r_new

		iter = iter + 1
		@assert iter < max_iter "Error: Reached maximum number of iterations"
	end
	println("Converged after ", iter, " iterations")
	return w_old, r_old
end

# main function
function cont_baseline_eqlm_solver(primitives, damp, tol, max_iter, verbose)
	
	@unpack T, A_bar, δ_bar, λ, α, σ, η, L, ζ, nests = primitives
	if ζ == 1.0
		@unpack ε = primitives
		ε_compute = ε
	else
		@unpack ε_ring = primitives
		ε_compute = ε_ring / ζ
	end

	if σ == Inf
		w_guess = A_bar / A_bar[1]
	else
		w_guess = (A_bar / A_bar[1]) .^ ((σ - 1) / (σ + ε_compute))
	end

	r_guess = 1 ./ T
	@time w_star, r_star = price_update(w_guess, r_guess, T, A_bar, δ_bar, λ, α, σ, ε_compute, η, L, ζ, nests, damp, tol, max_iter, verbose)
	ell_star = commuting_flows(r_star, w_star, α, ε_compute, ζ, δ_bar, λ, nests, L)
	return w_star, r_star, ell_star
end