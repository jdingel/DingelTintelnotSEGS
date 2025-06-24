#Purpose
#Given parameter values L, A_n, T_k, epsilon, and delta_{kn} and beliefs (\tilde{w},\tilde{r}),
#1. Draw a realization of \ell_{kn} from that process
#2. Solve for equilibrium wages and land prices {w_n,r_k} given \ell_{kn} and {An,T_k}.

using LinearAlgebra, Random, Distributions
function prob_i_choose_kn(wagebelief::Array{Float64,1},rentbelief::Array{Float64,1},delta::Array{Float64,2},epsilon::Float64,alpha::Float64)

	@assert size(delta)==(length(rentbelief),length(wagebelief)) "Matrix conformity problem"
	@assert isless(alpha,1) && isless(0,alpha) "Expenditure share must be in (0,1)"
	@assert wagebelief >= zeros(length(wagebelief))

	#compute Probability of choosing {kn} using all arguments except "headcount"
	#Multinomial realization of \ell_{kn} depends on beliefs (\tilde{w},\tilde{r}), commuting costs delta_{kn}, and epsilon
	wagerent_belief_array = (repeat(rentbelief,1,size(wagebelief,1)).^(-alpha*epsilon)) .* (repeat(wagebelief',size(rentbelief,1),1).^epsilon)
	value_temp = wagerent_belief_array .* (delta.^(-epsilon))
	Prob = value_temp ./ sum(value_temp) #KxN array
	Prob_vector = dropdims(reshape(Prob,length(Prob),1),dims=2)

	return Prob_vector
end

prob1 = prob_i_choose_kn([0.0,1.0],[1.0,1.0,1.0],ones(3,2),2.0,0.5) #w_1=0 should make ell_k1 = 0 for all k
prob2 = prob_i_choose_kn([1.0,1.0,1.0],[1.0,1.0,1.0],[Inf 1 1; 1 Inf 1; 1 1 Inf],2.0,0.5) #delta_kk = Inf implies ell_kk==0
prob3 = prob_i_choose_kn([2.0,1.0,1.0],[10.0,1.0,1.0],ones(3,3),2.0,0.01) #alpha=0.01 should make r_1=10 unimportant relative to w_1 = 2.0
prob4 = prob_i_choose_kn([2.0,1.0,1.0],[10.0,1.0,1.0],[1 1.1 1.2; 1.1 1.2 1.3; 1.2 1.4 1.3],2.0,0.01) #alpha=0.01 should make r_1=10 unimportant relative to w_1 = 2.0

function labor_realization(K::Int64,N::Int64,Prob_vector::Array{Float64,1},headcount,aggregate_labor,rand_seed::Int64=1)

	if headcount == Inf
		x = aggregate_labor * Prob_vector
	else
		#Draw "headcount" people from a multinomial distribution with this probability
		Random.seed!(rand_seed)
		x = aggregate_labor/headcount * rand(Multinomial(convert(Int64,headcount),Prob_vector))
	end

	#Return the KxN MNL draw
	return reshape(x,K,N)
end

#MNL_draw tests:
test1 = labor_realization(3,2,prob1,100.0,200.0) #w_1=0 should make ell_k1 = 0 for all k
@assert test1[:,1] == zeros(size(test1,1))
test2 = labor_realization(3,3,prob2,100.0,100.0) #delta_kk = Inf implies ell_kk==0
@assert diag(test2)==zeros(size(test2,1))
test3 = labor_realization(3,3,prob3,100.0,100.0) #alpha=0.01 should make r_1=10 unimportant relative to w_1 = 2.0
@assert sum(test3,dims=1)[1] >= 50  #This assertion is not literally true; it should be true for almost all draws, roughly
test4 = labor_realization(3,3,prob4,100.0,100.0)


function freetrade_equilibrium_solver(A::Array{Float64,1},labor::Array{Float64,2},σ::Float64,commute_cost_time::Bool,delta_bar::Array{Float64,2})
	#solve for equilibrium wages given realized_ell_{kn}, alpha, sigma, productivity
	@assert size(labor,2)==length(A)

	if commute_cost_time==true
		realized_labor = labor ./delta_bar
	else
		realized_labor = labor
	end

	#Let L_n = \sum_k \ell_{kn}
	L_n = dropdims(sum(realized_labor,dims=1),dims=1)
	L_n_relative = L_n/L_n[1]

	A_relative = A/A[1]

	# Logbook show that
    # w_n/w_0 = (A_n/A_0)^((σ-1)/σ) * (L_n/L_0)^(-1/σ)
    if σ == Inf
        wages = A
    else
    # Suppose w[1]=1
        wages = A_relative .^((σ-1)/σ) .* L_n_relative .^(-1/σ) 
    end
	
	@assert length(wages)==length(A)
	return wages, realized_labor

end
#freetrade_equilibrium_solver tests:
wage1,rl1 = freetrade_equilibrium_solver(ones(4),ones(Float64,4,4),2.0,false,ones(Float64,4,4)) #Equal A and L should deliver equal wages
@assert wage1 == ones(length(wage1)) * wage1[1]
wage2, rl2 = freetrade_equilibrium_solver([1.0,1,0],ones(Float64,3,3),2.0,false,ones(Float64,3,3)) #Zero productivity means zero wage
@assert wage2[3]==0.0
wage3, rl3 = freetrade_equilibrium_solver([1.0,2.0,3.0],ones(Float64,3,3),Inf, true,ones(Float64,3,3))
@assert wage3 == [1.0,2.0,3.0]

function land_rent_solver(realized_labor::Array{Float64,2},wages::Array{Float64,1},landendowment::Array{Float64,1},alpha::Float64)

	#The rows of L are residences; the columns are workplaces
	@assert size(realized_labor,1)==length(landendowment)
	@assert size(realized_labor,2)==length(wages)
	@assert isless(alpha,1) && isless(0,alpha)

	w_compute = replace(wages, NaN=>0) # caused by wagebelief=0 and A_n=0 (3 obs in Wayne county's case)
	w_compute = replace(wages, Inf=>0) # caused by L_n=0 

	#r_k = Σ_n ell_{kn} α w_n / T_k = α (Σ_n ell_{kn} w_n) / T_k  
	land_prices = alpha .* ((realized_labor * w_compute) ./ landendowment)
	return land_prices
end
#land_rent_solver tests:
rent1 = land_rent_solver(ones(Float64,2,3),ones(3),[1,.1],0.5)
@assert rent1[1]==rent1[2]/10
rent2 = land_rent_solver([0.0 0.0 0.0;1.0 2.0 3.0],ones(3),ones(2),0.5)
@assert rent2[1]==0.0 && rent2[2]==sum([0.0 0 0;1 2 3])*0.5


