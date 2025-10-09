import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV
using StatsBase,Statistics

# Function
function calculate_percentile(pct::Int64,matrix::Array{Float64,2})
	vector = zeros(size(matrix,1))
	for i in 1:size(matrix,1)
		vector[i] = percentile(matrix[i,:][matrix[i,:] .<Inf],pct)
	end

	return vector
end

function calculate_mean_std(matrix::Array{Float64,2})
	vec_mean = zeros(size(matrix,1))
	vec_std = zeros(size(matrix,1))
	for i in 1:size(matrix,1)
		vec_mean[i] = mean(matrix[i,:][matrix[i,:] .<Inf])
		vec_std[i]  = std(matrix[i,:][matrix[i,:] .<Inf])
	end

	return vec_mean,vec_std
end

# Prepare data
df1 = load("../output/simulation1.jld2")
df2 = load("../output/simulation2.jld2")
df3 = load("../output/simulation3.jld2")
df4 = load("../output/simulation4.jld2")
df5 = load("../output/simulation5.jld2")
df6 = load("../output/simulation6.jld2")
df7 = load("../output/simulation7.jld2")
df8 = load("../output/simulation8.jld2")
df9 = load("../output/simulation9.jld2")
df10 = load("../output/simulation10.jld2")

#grab continuum data from df1, is same across all simulations
cont_real_wb = df1["cont_real_wb"]
cont_real_wa = df1["cont_real_wa"]
cont_real_rb = df1["cont_real_rb"]
cont_real_ra = df1["cont_real_ra"]

res_a = hcat(df1["res_a"],df2["res_a"],df3["res_a"],df4["res_a"],df5["res_a"],df6["res_a"],df7["res_a"],df8["res_a"],df9["res_a"],df10["res_a"])
@assert size(res_a,2)==100000 # check the total simulation counts
emp_a = hcat(df1["emp_a"],df2["emp_a"],df3["emp_a"],df4["emp_a"],df5["emp_a"],df6["emp_a"],df7["emp_a"],df8["emp_a"],df9["emp_a"],df10["emp_a"])
@assert size(emp_a,2)==100000
real_rb = hcat(df1["real_rb"],df2["real_rb"],df3["real_rb"],df4["real_rb"],df5["real_rb"],df6["real_rb"],df7["real_rb"],df8["real_rb"],df9["real_rb"],df10["real_rb"])
@assert size(real_rb,2)==100000
real_ra = hcat(df1["real_ra"],df2["real_ra"],df3["real_ra"],df4["real_ra"],df5["real_ra"],df6["real_ra"],df7["real_ra"],df8["real_ra"],df9["real_ra"],df10["real_ra"])
@assert size(real_ra,2)==100000
real_wb = hcat(df1["real_wb"],df2["real_wb"],df3["real_wb"],df4["real_wb"],df5["real_wb"],df6["real_wb"],df7["real_wb"],df8["real_wb"],df9["real_wb"],df10["real_wb"])
@assert size(real_wb,2)==100000
real_wa = hcat(df1["real_wa"],df2["real_wa"],df3["real_wa"],df4["real_wa"],df5["real_wa"],df6["real_wa"],df7["real_wa"],df8["real_wa"],df9["real_wa"],df10["real_wa"])
@assert size(real_wa,2)==100000

# Calculate statistics
res_a_p95 = calculate_percentile(95,res_a)
res_a_p5 = calculate_percentile(5,res_a)

emp_a_p95 = calculate_percentile(95,emp_a)
emp_a_p5 = calculate_percentile(5,emp_a)

real_ra_p95 = calculate_percentile(95,real_ra)
real_ra_p5 = calculate_percentile(5,real_ra)
real_ra_mean,real_ra_std = calculate_mean_std(real_ra)
real_rb_mean,real_rb_std = calculate_mean_std(real_rb)

real_wa_p95 = calculate_percentile(95,real_wa)
real_wa_p5  = calculate_percentile(5,real_wa)
real_wa_mean,real_wa_std = calculate_mean_std(real_wa)
real_wb_mean,real_wb_std = calculate_mean_std(real_wb)

# Output
df_orig = DataFrame(hcat(res_a_p5,res_a_p95,real_ra_p95,real_ra_p5,real_rb_mean,real_ra_mean,real_rb_std,cont_real_rb, cont_real_ra), :auto)
rename!(df_orig,:x1=>:res_a_p5,:x2=>:res_a_p95,:x3=>:realra_p95,:x4=>:realra_p5,:x5=>:realrb_mean,:x6=>:realra_mean,:x7=>:realrb_std, :x8=>:realrb_cont, :x9=>:realra_cont)
CSV.write("../output/simulation_100k_distribution_orig.csv",df_orig)

df_dest = DataFrame(hcat(emp_a_p5,emp_a_p95,real_wa_p95,real_wa_p5,real_wb_mean,real_wa_mean,real_wb_std, cont_real_wb, cont_real_wa), :auto)
rename!(df_dest,:x1=>:emp_a_p5,:x2=>:emp_a_p95,:x3=>:realwa_p95,:x4=>:realwa_p5,:x5=>:realwb_mean,:x6=>:realwa_mean,:x7=>:realwb_std, :x8=>:realwb_cont, :x9=>:realwa_cont)
CSV.write("../output/simulation_100k_distribution_dest.csv",df_dest)



