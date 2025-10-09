# describe_data
This task creates a function, `describe_data_output`, 
that generates a report file for any `jld2` output file.
The Julia dictionary can contain `AbstractFloat`, `AbstractArray` (including `Array`, `Vector{<:Vector}`, and `Array{Array{CartesianIndex{2},1},1}`), `NamedTuple`, and `DataFrame`. 
Log files' treatment of `Inf`s and `NaN`s may vary across versions of Julia.


## Output
* `named_tuple_mwe.jld2`: Minimal working example of a `NamedTuple`.

## Code
* `describe_data.jl`: This file creates a function, `describe_data_output`, 
    that writes a `describe`-like output to a report file.
* `describe_data_script.jl`: This script applies `describe_data_output` to a `.jld2` input.
* `prep_named_tuple.jl`: This script prepares a named tuple for testing `describe_data.jl`.

## Input
* `Project.toml`, `Manifest.toml`: Required Julia environment.
* `primtives_nyc2010_time.jld2`: Test `.jld2` file to describe. 
* `baseline_equilibrium_outcomes%.jld2`: Contains baseline equilibrium outcomes. 