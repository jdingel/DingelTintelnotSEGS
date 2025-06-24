function SVD_approximation(X::Array{Float64, 2}, rank::Int64)
    F = svd(X);
    U = F.U; Σ = F.S; Vt = F.Vt;
    return U[:, 1:rank] * Diagonal(Σ[1:rank]) * Vt[1:rank, :];
end

function SVD_approximation_diag_preserve(lodes_mat::Array{Float64, 2}, r::Int64, diag::BitMatrix)
    svd_diag = SVD_approximation(lodes_mat, r)
    off_diag_total = sum(lodes_mat) - sum(lodes_mat[diag])
    svd_diag[.~diag] = max.(svd_diag[.~diag], 0) |> (m -> m ./ sum(m) .* off_diag_total)
    svd_diag[diag] = lodes_mat[diag]
    return svd_diag
end

function get_diagonal_indices(lodes_df::DataFrame)
    I = length(unique(lodes_df[!, :i]))
    J = length(unique(lodes_df[!, :j]))
    diag = (lodes_df[:, :i] .== lodes_df[:, :j]) |> (t -> reshape(t, I, J))
    return diag
end

function NNMF_approximation(X::Array{Float64, 2}, rank::Int64)
    Random.seed!(1) # nnmf() calls rand() at one point; seed needed for reproducibility
    L = sum(X)
    nn_svd = nnmf(X, rank, maxiter=10000)

    return (nn_svd.W * nn_svd.H) |> (t -> L * t ./ sum(t))
end

function zeros_percentage(X::Array{Float64, 2}, tolerance::Float64)
    round(mean(isapprox.(X, 0, atol=tolerance)) * 100, digits=2);
end