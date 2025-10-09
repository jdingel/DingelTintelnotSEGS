import Pkg
Pkg.activate("../input/Project.toml")
using JLD2, FileIO, DataFrames, CSV

K = 2160
N = 2143
block = 10000

function change_res_emp_rent(simulation::Int64)
	sum_res_b = zeros(K,block);
	sum_res_a = zeros(K,block);
	sum_emp_b = zeros(N,block);
	sum_emp_a = zeros(N,block);
	sum_rb = zeros(K,simulation);
	sum_ra = zeros(K,simulation);
	tot_simulation = block*simulation

	for s in 1:simulation
		str_s = string(s)
		df = load("../output/simulation"*str_s*".jld2")
		sum_res_b[:,s] = dropdims(sum(df["res_b"],dims=2),dims=2)
		sum_res_a[:,s] = dropdims(sum(df["res_a"],dims=2),dims=2)
		sum_emp_b[:,s] = dropdims(sum(df["emp_b"],dims=2),dims=2)
		sum_emp_a[:,s] = dropdims(sum(df["emp_a"],dims=2),dims=2)
		sum_rb[:,s] = dropdims(sum(df["real_rb"],dims=2),dims=2)
		sum_ra[:,s] = dropdims(sum(df["real_ra"],dims=2),dims=2)
	end

	res_change = dropdims(sum(sum_res_a,dims=2),dims=2)/tot_simulation .- dropdims(sum(sum_res_b,dims=2),dims=2)/tot_simulation
	emp_change = dropdims(sum(sum_emp_a,dims=2),dims=2)/tot_simulation .- dropdims(sum(sum_emp_b,dims=2),dims=2)/tot_simulation
	realr_change = (((dropdims(sum(sum_ra,dims=2),dims=2)/tot_simulation) ./ (dropdims(sum(sum_rb,dims=2),dims=2)/tot_simulation))-ones(K))*100
	return res_change,emp_change,realr_change
end

function change_wage(simulation::Int64)
	sum_realwb = zeros(N,simulation);
	sum_realwa = zeros(N,simulation);
	count_realwb_ignoreinf = zeros(N,simulation);
	count_realwa_ignoreinf = zeros(N,simulation);
	for s in 1:simulation
		str_s = string(s)
		df = load("../output/simulation"*str_s*".jld2")

		for i in 1:N
			sum_realwb[i,s] = sum(df["real_wb"][i,:][df["real_wb"][i,:] .<Inf])
			count_realwb_ignoreinf[i,s] = length(df["real_wb"][i,:][df["real_wb"][i,:] .<Inf])
			sum_realwa[i,s] = sum(df["real_wa"][i,:][df["real_wa"][i,:] .<Inf])
			count_realwa_ignoreinf[i,s] = length(df["real_wa"][i,:][df["real_wa"][i,:] .<Inf])
		end
	end
	realwb_mean = dropdims(sum(sum_realwb,dims=2),dims=2) ./dropdims(sum(count_realwb_ignoreinf,dims=2),dims=2)
	realwa_mean = dropdims(sum(sum_realwa,dims=2),dims=2) ./dropdims(sum(count_realwa_ignoreinf,dims=2),dims=2)
	realw_change = ((realwa_mean ./realwb_mean) .-ones(N))*100

	return realw_change
end

res_change1, emp_change1, realr_change1 = change_res_emp_rent(1)
res_change10,emp_change10,realr_change10 = change_res_emp_rent(10)

realw_change1 = change_wage(1)
realw_change10 = change_wage(10)


# Output
df_dest = DataFrame(hcat(emp_change1,emp_change10,realw_change1,realw_change10), :auto)
rename!(df_dest,:x1=>:emp_change1,:x2=>:emp_change10,:x3=>:realw_change1,:x4=>:realw_change10)
CSV.write("../output/simulation_dest.csv",df_dest)

df_orig = DataFrame(hcat(res_change1,res_change10,realr_change1,realr_change10), :auto)
rename!(df_orig,:x1=>:res_change1,:x2=>:res_change10,:x3=>:realr_change1,:x4=>:realr_change10)
CSV.write("../output/simulation_orig.csv",df_orig)



