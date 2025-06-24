function data_prep(baseline_ell_input, worktract_input, treatment_id_input)
    # observed commuting data
    baseline_ell_data = DataFrame(load(baseline_ell_input))
    pop = sum(baseline_ell_data[!, :X_ij])

    # location IDs (11-digit FIPS or NTA code)
    treatmentIDS = string.(DataFrame(load(treatment_id_input))[!, :id])
    worktractIDS = convert(Array{Any}, unique(baseline_ell_data[!, :j]))

    # treatment indices starting from 1
    treatment_idx = findall(in(treatmentIDS), worktractIDS)

    worktract_df = DataFrame(load(worktract_input))
    worktract_df = sort(worktract_df, [:j])
    
    # observed employment differences in level, in treated location
    observed_diff_level = worktract_df[!, :X_j_difference][findall(in(treatmentIDS), worktractIDS)]
    observed_diff_level = convert(Array{Float64}, observed_diff_level)

    # observed employment differences in ratio, in all locations
    L̂ = convert(Array{Float64}, worktract_df[!, :X_j_ratio])

    return (
        pop,
        treatment_idx,
        treatmentIDS,
        observed_diff_level,
        L̂
    )
end

# The `data_prep_pool` function is needed to handle the preprocessing of pooled commuting and workplace data,
# which uses the 2010 indices and the pooled indices to identify the shocks and the treatment tracts, respectively.

function data_prep_pool(ell_pool_input, workplace_input_2010, workplace_input_pool, treatment_id_input)
    # observed commuting data
    ell_pool_data = DataFrame(load(ell_pool_input))
    pop = convert(Float64, sum(ell_pool_data[!, :X_ij]))

    # location IDs (11-digit FIPS or NTA code)
    workplace_2010_data = DataFrame(load(workplace_input_2010))
    workplaceIDS_2010 = convert(Array{Any}, unique(workplace_2010_data[!, :j]))

    workplace_pool_data = DataFrame(load(workplace_input_pool))
    workplaceIDs_pool = convert(Array{Any}, unique(workplace_pool_data[!, :j]))

    # location IDs (11-digit FIPS or NTA code)
    treatmentIDS = string.(DataFrame(load(treatment_id_input))[!, :id])

    # treatment indices starting from 1
    treatment_idx = findall(in(treatmentIDS), workplaceIDs_pool)
    
    # observed employment differences in level, in treated tract
    observed_diff_level = workplace_2010_data[!, :X_j_difference][findall(in(treatmentIDS), workplaceIDS_2010)]
    observed_diff_level = convert(Array{Float64}, observed_diff_level)

    # observed employment differences in ratio, in all locations
    L̂ = convert(Array{Float64}, workplace_pool_data[!, :X_j_ratio])

    return (
        pop,
        treatment_idx,
        treatmentIDS,
        observed_diff_level,
        L̂
    )
end