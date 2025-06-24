# Computes the gap between the model-predicted employment increase and a targeted employment increase for a single treated tract.
function compute_employment_gap(ŵ_guess, r̂_guess, treatmentID, destination_tract_list, employment_increase_target, model_params, exo_changes, comp_params, L)
    @assert length([treatmentID]) == 1
    employment_matrix = L .* model_params.l_share
    treated_employment_before = sum(employment_matrix[:,destination_tract_list .== treatmentID])

    _, _, ell_hat = eha_solver(ŵ_guess, r̂_guess, model_params, exo_changes, comp_params; show_every=10)

    employment_matrix_after = employment_matrix .* ell_hat
    treated_employment_after = sum(employment_matrix_after[:, destination_tract_list .== treatmentID])

    employment_change = treated_employment_after - treated_employment_before
    employment_gap = employment_change - employment_increase_target
    return employment_gap
end
