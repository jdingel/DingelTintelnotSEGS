import Pkg

Pkg.activate("../input/Project.toml")


using DataFrames, StatFiles, Statistics, Distributions, CSV, Random, Printf

#==================#
# Helper Function  #
#==================#

function round_large_float(x::Float64) # new function for printing scientific notation 
    x_temp = @sprintf("%.3e", x)       # define digits
    x_rounded = parse(Float64, x_temp)
    return x_rounded
end

#================#
# Main Function  #
#================#

# Chi2 test stat

function sim_empirical_dist_Chi2(input_filename::String, output_filename::String, stat_value_filename::String)
    df = sort(DataFrame(load(input_filename)), [:j, :i]);
    df = dropmissing(df);
    df = filter(row -> row.X_ij_pred != 0, df);  # SVD models produce zero values
    X_ij_model = df.X_ij_pred
    p = X_ij_model./sum(X_ij_model);     # model-implied probability
    p = convert(Array{Float64,1}, p)
    p = p ./sum(p)                        # fix rounding error after type conversion
    total_pop = Int(round(sum(X_ij_model),digits=0))
    println("Total Commuters in NYC : ", total_pop)

    simulations = 1000;
    result_array = zeros(simulations, 1);  # create a container for the output

    for i=1:simulations
        Random.seed!(i)
        if mod(i,100) == 1
            println("Initiating Chi2 simulation for round ", i)
        end
        X_ij_data = rand(Multinomial(total_pop,p))          # Multinomial perturbation around the model implied probability
        result_array[i,1] = sum((X_ij_data .- X_ij_model).^2 ./ X_ij_model)
    end

    result_array[:,1] = sort(result_array[:,1]) ;           # percentile values of the simulated (empirical) test stat distribution
    result = DataFrame(result_array, [:pcentile_value]);
    result[:, :pcentile] = (1: simulations)./simulations ;
    result = result[5:5:end-5,:] ;                                        # keep every 5th observation to have 0.5 th to 99.5 th percentile
    stat_value_lodes = sum((df.X_ij_pred .- df.X_ij).^2 ./ df.X_ij_pred); # calculate statistics using LODES and model predictions
    result[:, :stat_value_lodes] .= convert(Float64, stat_value_lodes);
    result = result[:,[:pcentile, :pcentile_value, :stat_value_lodes]]    # order columns
    CSV.write(output_filename, result)

    rounded_stat_value_lodes = round_large_float(convert(Float64, stat_value_lodes))

    io = open(stat_value_filename, "w")                # export result in the tex file
    println(io, "$rounded_stat_value_lodes" )
    close(io)
end


# MSE as a test stat
function sim_empirical_dist_MSE(input_filename::String, output_filename::String, stat_value_filename::String)
    df = sort(DataFrame(load(input_filename)), [:j, :i]);
    df = dropmissing(df);
    
    num_orig = length(unique(df.i))       # Number of origin tracts
    num_dest = length(unique(df.j))       # Number of destination tracts

    X_ij_model = df.X_ij_pred
    p = X_ij_model./sum(X_ij_model);      # model-implied probability
    p = convert(Array{Float64,1}, p)
    p = p ./sum(p)                        # fix rounding error after type conversion
    total_pop = Int(round(sum(X_ij_model),digits=0))
    println("Total Commuters in NYC : ", total_pop)

    simulations = 1000;
    result_array = zeros(simulations, 1);  # create a container for the output

    for i=1:simulations
        Random.seed!(i)
        if mod(i,100) == 1
            println("Initiating MSE simulation for round ", i)
        end
        X_ij_data = rand(Multinomial(total_pop,p))             # Multinomial perturbation around the model implied probability
        result_array[i,1] = sum((X_ij_data .- X_ij_model).^2) / (num_orig*num_dest);
    end

    result_array[:,1] = sort(result_array[:,1]) ;            # percentile values of the simulated (empirical) test stat distribution
    result = DataFrame(result_array, [:pcentile_value]);
    result[:, :pcentile] = (1: simulations)./simulations ;
    result = result[5:5:end-5,:] ;                                              # keep every 5th observation to have 0.5 th to 99.5 th percentile
    
    stat_value_lodes = sum((df.X_ij_pred .- df.X_ij).^2) / (num_orig*num_dest); # calculate statistics using LODES and model predictions
    
    result[:, :stat_value_lodes] .= convert(Float64, stat_value_lodes);
    result = result[:,[:pcentile, :pcentile_value, :stat_value_lodes]]    # order columns
    CSV.write(output_filename, result)

    rounded_stat_value_lodes = round_large_float(convert(Float64, stat_value_lodes))

    io = open(stat_value_filename, "w")                                   # export result in the tex file
    println(io, "$rounded_stat_value_lodes" )
    close(io)
end

#=============#
# simulation  #
#=============#

sim_empirical_dist_Chi2(ARGS[1], ARGS[2], ARGS[3])
sim_empirical_dist_MSE(ARGS[1], ARGS[4], ARGS[5])