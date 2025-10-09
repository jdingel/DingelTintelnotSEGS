function mean_util_kn(w, r, A, δ, σ, α, ε)
	P = sum((w ./A) .^(1-σ))^(1/(1-σ))
	P_k = (r .^α) * (P^(1-α))
	util_kn = ε .* log.( w' ./ (P_k .* δ))

	return util_kn[:]
end