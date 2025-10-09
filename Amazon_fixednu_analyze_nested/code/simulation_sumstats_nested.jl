import Pkg

Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV, StatsBase, Statistics

# Function
function calculate_percentile(pct::Int64, matrix::Array{Float64,2})
	vector = zeros(size(matrix,1))
	for i in 1:size(matrix,1)
		idx = matrix[i,:] .< Inf
		vector[i] = percentile(matrix[i, idx], pct)
	end
	return vector
end

function calculate_mean(matrix::Array{Float64,2})
	vec_mean = zeros(size(matrix,1))
	for i in 1:size(matrix,1)
		vec_mean[i] = mean(matrix[i,:][matrix[i,:] .< Inf])
	end
	return vec_mean
end

# Parameters
total_sim = 100
num_origin = 2160
num_dest = 2143

res_b = zeros(num_origin, total_sim)
res_a = zeros(num_origin, total_sim)
emp_b = zeros(num_dest, total_sim)
emp_a = zeros(num_dest, total_sim)
real_rb = zeros(num_origin, total_sim)
real_ra = zeros(num_origin, total_sim)
real_wb = zeros(num_dest, total_sim)
real_wa = zeros(num_dest, total_sim)

for i in 1:total_sim
	# we only consider zeta = 0.25 for the AHQ2 nested-logit fixednu simulations
	df = load("../input/simulation_fixednu_"*"0.25_"*string(i)*"_nested.jld2")
	res_b[:, i] = df["res_b"]
	res_a[:, i] = df["res_a"]
	emp_b[:, i] = df["emp_b"]
	emp_a[:, i] = df["emp_a"]
	real_rb[:, i] = df["real_rb"]
	real_ra[:, i] = df["real_ra"]
	real_wb[:, i] = df["real_wb"]
	real_wa[:, i] = df["real_wa"]
end

real_wb[real_wb .== 0] .= Inf
real_wa[real_wa .== 0] .= Inf

# Calculate statistics
d_res = res_a .- res_b
d_emp = emp_a .- emp_b
d_real_rent = real_ra .- real_rb 
d_real_wage = real_wa .- real_wb
d_real_rent_ratio = d_real_rent ./ real_rb * 100
d_real_wage_ratio = d_real_wage ./ real_wb * 100

# Output - Origin
df_orig = DataFrame(
	id = collect(1:num_origin),
	d_res_p95 = calculate_percentile(95, d_res),
	d_res_p5 = calculate_percentile(5, d_res),
	d_res_mean = calculate_mean(d_res),
	d_real_rent_ratio_p95 = calculate_percentile(95, d_real_rent_ratio),
	d_real_rent_ratio_p5 = calculate_percentile(5, d_real_rent_ratio),
	d_real_rent_ratio_mean = calculate_mean(d_real_rent_ratio),
	real_rb_mean = calculate_mean(real_rb),
	real_ra_mean = calculate_mean(real_ra)
)
CSV.write("../output/simulation_distribution_orig_nested.csv", df_orig)

# Output - Destination
df_dest = DataFrame(
	id = collect(1:1:num_dest),
	d_emp_p95 = calculate_percentile(95, d_emp),
	d_emp_p5 = calculate_percentile(5, d_emp),
	d_emp_mean = calculate_mean(d_emp),
	d_real_wage_ratio_p95 = calculate_percentile(95, d_real_wage_ratio),
	d_real_wage_ratio_p5 = calculate_percentile(5, d_real_wage_ratio),
	d_real_wage_ratio_mean = calculate_mean(d_real_wage_ratio),
	real_wb_mean = calculate_mean(real_wb),
	real_wa_mean = calculate_mean(real_wa)
)
CSV.write("../output/simulation_distribution_dest_nested.csv", df_dest)