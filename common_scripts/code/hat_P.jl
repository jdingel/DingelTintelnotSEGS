# multiple dispatch 
function hat_P(Â, ŵ, y_share, σ)
    y_share_per_dest = sum(y_share, dims = 1)[:]
    P̂ = sum(((ŵ ./Â) .^(1-σ)) .* y_share_per_dest)^(1/(1-σ))
    return P̂
end

function hat_P(Â, ŵ, w, Ln, σ)
    P̂ = sum(((ŵ ./Â) .^(1-σ)) .* w .*Ln/sum(w .*Ln))^(1/(1-σ))
    return P̂
end