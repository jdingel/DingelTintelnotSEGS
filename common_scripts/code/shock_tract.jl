# The function A_treatment gives a productivity shock to a given tract.
function A_treatment(treatmentID::Any, power::Float64, productivity::Array{Float64,1}, df::DataFrame)
    productivity_treatment = copy(productivity)
    productivity_treatment[unique(df[!,:j]) .==treatmentID] = power*productivity[unique(df[!,:j]) .==treatmentID]

    return productivity_treatment
end
