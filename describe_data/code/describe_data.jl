# This set of functions require the DataFrames, StatsBase, and JLD2 packages.
# These functions expand upon the describe functionality to generate relevant 
# "report" .log files that can be used to evaluate the success of a data-generating script.

function describe_plus_tibble(file, item, sigfigs)
    if isa(item, DataFrame)
        # round numeric columns
        for col in names(item)
            if eltype(item[!, col]) <: AbstractFloat
                item[!, col] = round.(item[!, col]; sigdigits=sigfigs)
            end
        end
        write(file, "Summary Stats (rounded to $sigfigs significant figures): \n")
        write(file, string(describe(item)))
        write(file, "\nThe first row is (rounded to $sigfigs significant figures): \n" * string(first(item)) * "\n")
        write(file, "The last row is (rounded to $sigfigs significant figures): \n" * string(last(item)) * "\n")
    else
        # skip missing and NaN values
        filtered_data = filter(!isnan, skipmissing(item))
        
        # create formatted summary statistics string
        summary_stats = """
        Summary Stats (rounded to $sigfigs significant figures):
        Length:         $(rpad(string(length(item)), 10))
        Missing Count:  $(rpad(string(sum(ismissing.(item))), 10))
        Mean:           $(rpad(string(round(mean(filtered_data), sigdigits=sigfigs)), 10))
        Std. Deviation: $(rpad(string(round(std(filtered_data), sigdigits=sigfigs)), 10))
        Minimum:        $(rpad(string(round(minimum(filtered_data), sigdigits=sigfigs)), 10))
        1st Quartile:   $(rpad(string(round(quantile(filtered_data, 0.25), sigdigits=sigfigs)), 10))
        Median:         $(rpad(string(round(quantile(filtered_data, 0.50), sigdigits=sigfigs)), 10))
        3rd Quartile:   $(rpad(string(round(quantile(filtered_data, 0.75), sigdigits=sigfigs)), 10))
        Maximum:        $(rpad(string(round(maximum(filtered_data), sigdigits=sigfigs)), 10))
        Type:           $(rpad(string(typeof(item)), 10))
        First entry:    $(rpad(string(round(first(item); sigdigits=sigfigs)), 10))
        Last entry:     $(rpad(string(round(last(item); sigdigits=sigfigs)), 10))
        Most common entry: $(rpad(string(round(mode(item); sigdigits=sigfigs)), 10))
        """
        write(file, summary_stats)
    end
end

function describe_namedtuple(file, item, sigfigs)
    write(file, 
        "\nThis entry is a NamedTuple, which contains " * string(length(item)) * " fields. \n")
    
    # iterate over each field in the NamedTuple
    for field in keys(item)

        # extract values from the NamedTuple
        value = getfield(item, field)

        if value isa AbstractArray{<:Number}
            size_str = size(value)
            mean_val = round(mean(value), sigdigits=sigfigs)
            std_val = round(std(value), sigdigits=sigfigs)
            min_val = round(minimum(value), sigdigits=sigfigs)
            max_val = round(maximum(value), sigdigits=sigfigs)
            write(file,
                "The size of '$(string(field))' is $size_str.\n" *
                "The mean, std. dev, min, and max of '$(string(field))' are (rounded to $sigfigs significant figures) " *
                "$mean_val, $std_val, $min_val, and $max_val.\n")
        elseif value isa AbstractFloat
            write(file, "'" *string(field)* "' is a float. '"*string(field)* "' = " * string(value) *".\n")
        elseif value isa String
            write(file, "'" *string(field)* "' is a String. '"*string(field)* "' = " * value *".\n")
        elseif typeof(value) == Array{Array{CartesianIndex{2},1},1}
            write(file, "The following report summarizes '"* string(field) *"'.\n")
            describe_nested_structure(file, value)
        else
            # handle non-numerical field
            write(file, "'" *string(field) * "' contains non-numerical data.\n")
        end
    end
end

function describe_nested_structure(file, item)
    write(file, 
        "This entry is a two-level nested array, with each inner array containing entries of type `" *
        string(typeof(item[1][1])) * "`. \n")
    write(file,
        "There are " * string(length(item)) * " nests, " *
        "and the sizes of the nests vary from " *
        string(minimum([length(i) for i in item])) *
        " to " *
        string(maximum([length(i) for i in item])) * ". \n")
    write(file,
        "The first nest is of size " * string(length(first(item))) * ", " *
        "and the last nest is of size " * string(length(last(item))) * ".\n")
    write(file,
        "The total number of entries (aggregating across nests) is " *
        string(sum([length(i) for i in item])) * ". \n")
end

function describe_vec_of_vec(file, item, sigfigs)
    write(file, 
        "This entry is a vector of vectors, with each inner vector containing entries of type `" *
        string(typeof(item[1][1])) * "`. \n")
    write(file,
        "There are " * string(length(item)) * " outer vectors, " *
        "and the sizes of the inner vectors vary from " *
        string(minimum([length(i) for i in item])) *
        " to " *
        string(maximum([length(i) for i in item])) * ". \n")
    
    v_length = minimum([length(item[1]),3])
    write(file,
        "The first " * string(v_length) 
        * " entries of the first vector (rounded to $sigfigs significant figures) are " 
        * string(round.(item[1][1:v_length]; sigdigits=sigfigs)) * ". \n")
    
    write(file,
        "The mean, std. dev, min, and max of the first vector (rounded to $sigfigs significant figures) are " * 
        string(round(mean(first(item)); )) * ", " *
        "" * string(round(std(first(item)); sigdigits=sigfigs)) * ", " *
        "" * string(round(minimum(first(item)); sigdigits=sigfigs)) * ", and " *
        "" * string(round(maximum(first(item)); sigdigits=sigfigs)) * ".\n")
    write(file,
        "The total number of entries (aggregating across vectors) is " *
        string(sum([length(i) for i in item])) * ". \n")
end

function describe_item(item, reportname, sigfigs)
    file = open(reportname, "a") # open the report file and start appending
        if isa(item, AbstractFloat) # if a value is a float, just report that value
            write(file, "This item is a Float \n")
            write(file, string(round(item; sigdigits=sigfigs))*" (rounded to " * string(sigfigs)* " significant figures) \n")
        elseif isa(item, AbstractArray)
            if ndims(item) > 1 # if the array is 2D or greater, report the dimensions
                write(file, 
                    "This entry is a multidimensional array with the following number of dimensions: \n" *
                    string(ndims(item)) * "\n")
                write(file, "The description of the entry as a unidimensional array is: \n")
                describe_plus_tibble(file, item, sigfigs)
            elseif typeof(item) == Array{Array{CartesianIndex{2},1},1}
                # A Vector{Vector{CartesianIndex{2}}} is a one-dimensional object.
                describe_nested_structure(file, item)
            elseif item isa Vector{<:Vector}
                # A vector of vector is a one-dimensional object.
                describe_vec_of_vec(file, item, sigfigs)
            else
                describe_plus_tibble(file, item, sigfigs)
            end
        elseif item isa NamedTuple
            describe_namedtuple(file, item, sigfigs)
        elseif isa(item, DataFrame)
            # round numeric columns
            for col in names(item)
                if eltype(item[!, col]) <: AbstractFloat
                    item[!, col] = round.(item[!, col]; sigdigits=sigfigs)
                end
            end
            write(file, "This entry is a dataframe with the following number of rows and columns: \n")
            write(file, string(size(item))*".\n")
            describe_plus_tibble(file, item, sigfigs)
        else # write describe to the report file
            describe(file, item)
        end
    close(file)
end

function describe_data(data, filename, sigfigs)
    if isfile("../report/" * filename * ".log") # replace report if it exists
        rm("../report/" * filename * ".log")
    end

    if isa(data, Dict) # if it is a dict type (for most jld2 files) then create separate descriptions for each element and append
        file = open("../report/" * filename * ".log", "w")
        write(file, "The following report summarizes " * filename * "\n")
        write(file, "The keys in the file are: \n")
        write(file, string(keys(data)) * "\n")
        close(file)
        for item in keys(data)
            file = open("../report/" * filename * ".log", "a")
            write(file, "\nThe following description is for entry: " * item * "\n")
            close(file)
            describe_item(data[item], "../report/" * filename * ".log", sigfigs)
        end
    else # if it's not a Dict type, just describe the input using the rules defined for Dict
        file = open("../report/" * filename * ".log", "w")
        write(file, "The following report summarizes " * filename * "\n")
        describe_item(data, "../report/" * filename * ".log", sigfigs)
        close(file)
    end
end

function describe_data_output(file, sigfigs=6)
    data = load(file) # loads a jld2 file 
    filename = basename(file) # removes file path
    describe_data(data, filename, sigfigs)
end