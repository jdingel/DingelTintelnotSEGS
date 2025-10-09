% This script is almost entirely borrowed from the replication code for 
% Chen, Fernández-Val, and Weidner (2021, Journal of Econometrics) which proposed
% the algorithm for maximum likelihood estimation of interactive fixed effects.
% [Originally labeled "FactorMLE.m"]
%
% The algorithm takes the form of an iterative expectation-maximization procedure, as per
% the paper's Algorithm 1. Becuase of the non-convexity of the likelihood in the R > 0 case,
% it is recommended that researchers initialize from multiple start points in search of the
% global optimum.
%
% The only meaningful modifications made to the following code were the addition of a "precision_fes"
% criteria, which acts as an additional check for convergence across the additive and interactive fixed
% effects, rather than exclusively determining convergence via the covariate coefficients.
% [See lines 114-139.]
% In practice, the objects of interest for this project (namely the commuting elasticity and 
% fitted values) are not substantially effected by requiring convergence across the fixed
% effects, and doing so incurs a substantial computational cost.
%
% Additionally, we have consolidated the functions model(), mult(), normalize(), and SampleLogL(),
% which were previously saved in separate scripts, into this file, as they are called nowhere else
% in our project. We also omit sections of the original code which do not have a place in our use
% (specifically those computing average partial effects and bias-correction, the latter of which is
% not needed in a Poisson model).
%
% Finally, we add arguments for passing in initial values for beta, alpha, gamma, lambda, and f.
% This is done to facilitate greater control and parallelizability across start points, which 
% is crucial for an application of our scale.

function [beta,alpha,gamma,lambda,f,exitflag,obj,APE,Var_beta,Var_APE,...
            beta_corrected,APE_corrected, v_reference] = ...
          IFE_MLE(Y,X,weight,lambda_known,f_known,R,precision_beta,precision_fes,repMIN,...
          repMAX,MAX_STEPS, b_init, alpha_init, gamma_init, lambda_init, f_init)

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%% Maximum Likelihood Estimation of Panel Factor Models
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % INPUT PARAMETERS:
      %     N = number of origin
      %     T = number of destinations
      %     Y = NxT matrix of outcomes
      %     X = KxNxT multi-matrix of regressors
      %     weight = NxT matrix that specifies fixed weights for each observation,
      %        for standard MLE we set weight(i,t)=1 if (i,t) observed
      %              and weight(i,t)=0 if (i,t) unobserved,
      %              but more general weights are also possible.
      %     lambda_known = N x Rex1 matrix of KNOWN factor loadings,
      %                    e.g. lambda_known=ones(N,1) to control standard time dummies
      %         ... if NO KNOWN factor loadings, then set lambda_known=zeros(N,0) !!!
      %     f_known = T x Rex2 matrix of KNOWN factors,
      %                    e.g. f_known=ones(T,1) to control standard individual specific fixed effects
      %         ... if NO KNOWN factors, then set f_known=zeros(T,0).
      %     R = positive integer
      %         ... number of interactive fixed effects in the estimation
      %     repMIN, repMAX = positive integers
      %                      ... number of repetitions (with repMIN counting iterations with successful convergence
      %                      and repMAX counting total start points). Note that repMIN = repMAX = 1 corresponds with
      %                      simply using the initial values passed into the function.
      %     precision_beta = defines stopping criteria for numerical optimization,
      %                      namely optimization is stopped when difference in beta
      %                      relative to previous optimization step is smaller than
      %                      "precision_beta" (uniformly over all K components of beta)
      %     precision_fes [added] = defines additional stopping criteria for numerical optimization,
      %                      namely optimization is stopped when difference across all additive and
      %                      interactive FEs is smaller than "precision_fes"
      %                      relative to previous optimization step is smaller than
      %                      "precision_beta" (uniformly over all components of alpha, lambda, gamma, and f)
      %
      % OUTPUT PARAMETERS:
      %     beta   = Kx1 vector of parameter estimate
      %     alpha  = N x Rex2 matrix of factor loadings corresponding to f_known
      %     gamma  = T x Rex1 matrix of factors corresponding to lambda_known
      %     lambda = N x R matrix of estimates for factor loading. Note that this lambda is not the lambda in the Dingel & Tintelnot paper.
      %     f      = T x R matrix of estimates for factors
      %     exitflag = 1 if iteration algorithm properly converged at optimal beta
      %              = -1 if iteration algorithm did not properly converge at optimal beta
      %     obj = objective function at optimum
      %     Var_beta = estimated variance-covariance matrix of beta
      %     APE = Kx1 vector of average partial effects
      %     Var_APE = estimated variance-covariance matrix of APE's
      %     beta_corrected = bias corrected estimator for beta
      %     APE_corrected = bias corrected estimator for APE's
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      K    = size(X,1);   % number of covariates
      N    = size(X,2);   % Panel dimension one ("cross-sectional" in the Chen et al. application)
      T    = size(X,3);   % Panel dimension one ("time" in the Chen et al. application)
      Rex1 = size(lambda_known,2);
      Rex2 = size(f_known,2);
      APE = 0;
      Var_APE = 0;
      APE_corrected = 0;

      % The first iteration starts from the input initialized values:
      beta = b_init;
      alpha = alpha_init;
      gamma = gamma_init;
      lambda = lambda_init;
      f = f_init;

      % Make sure that all regressor values for missing data are equal to zero:
      for i = 1:N
          for t = 1:T
              if weight(i, t)==0
                  X(:, i, t)=0;
              end
          end
      end

      variance_requested = nargout > 8 ;   % Whether user wants variance

      %% NUMERICAL OPTIMIZATION:

      obj_best = -inf;
      count_successful_runs = 0;
      count_total_runs = 0;
      while (count_successful_runs < repMIN) && (count_total_runs < repMAX)
          count_total_runs = count_total_runs+1;

          % ITERATION:
          count = 0;
          count_final = 0;  % How many steps already made smaller than precision_beta
          v_reference = [];
          para_reference = [];
          b_reference = 0;
          % repeat iteration step as long as beta still changes more than "precision_beta", or after MAX_STEPS steps
          while (count_final <= 5) && (count < MAX_STEPS)
              count = count+1;
              betaOLD = beta;
              fes_old = [alpha(:); gamma(:); lambda(:); f(:)];
              
              disp(append("Iteration ", num2str(count), " out of ", num2str(MAX_STEPS)))

              if count <= 5
                  [beta,alpha,gamma,lambda,f,obj] = ...
                      step(Y,X,weight,lambda_known,f_known,beta,alpha,gamma,lambda,f);
              else
                  [beta,alpha,gamma,lambda,f,obj,v_reference,para_reference,b_reference] = ...
                      stepNR(Y,X,weight,lambda_known,f_known,beta,alpha,gamma,lambda,...
                      f,v_reference,para_reference,b_reference);
              end

              beta_step = max(abs(beta-betaOLD));
              fes_step = max(abs([alpha(:); gamma(:); lambda(:); f(:)] - fes_old));
              disp(append("beta diff: ", num2str(beta_step)));
              disp(append("FEs diff: ", num2str(fes_step)));

              if (beta_step <= precision_beta) & (fes_step <= precision_fes)
                  count_final = count_final+1;
              else
                  count_final = 0;
              end
          end

          % COUNT SUCCESSFUL ITERATIONS:
          status = -1;
          if count < MAX_STEPS  % an iteration is successful if stopped before MAX_STEPS is reached
              count_successful_runs = count_successful_runs + 1;
              status = 1;
          end

          % CHECK IF OBJECTIVE IS BETTER THAN PREVIOUSLY BEST OBJECTIVE,
          % IF SO, THEN SAVE THOSE PARAMETERS:
          if obj > obj_best
              obj_best = obj;
              beta_best = beta;
              alpha_best = alpha;
              gamma_best = gamma;
              lambda_best = lambda;
              f_best = f;
              % exitflag reports if those optimal parameter values correspond to "successful" iteration run,
              % with above definition of "successful"
              exitflag = status;
          end

          % GENERATE NEW RANDOM STARTING VALUES:
          beta = 2 * rand(K, 1) - 1;
          alpha = 2 * rand(N, size(f_known,2))-1;
          gamma = 2*rand(T, size(lambda_known,2))-1;
          lambda = 2*rand(N, R)-1;
          f = 2 * rand(T, R)-1;
      end

      % REPORT PARAMETERS WITH MAXIMUM OBJECTIVE THAT WAS FOUND:
      if exitflag == 1
          disp("Successful Optimization! ");
      end

      beta = beta_best;
      alpha = alpha_best;
      gamma = gamma_best;
      lambda = lambda_best;
      f = f_best;

      % CALCULATE VARAINCE OF ESTIMATOR VIA HESSIAN:
      if variance_requested
          [obj,score,Hessian] = SampleLogL(Y,X,weight,lambda_known,f_known,beta,alpha,gamma,lambda,f,0);
          V=pinv(-Hessian * sum(sum(weight)) );
          Var_beta=V(1:K,1:K);
      else
          obj = SampleLogL(Y,X,weight,lambda_known,f_known,beta,alpha,gamma,lambda,f,0);
      end

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Some helper functions that make it easier to define
%%%% the penalized objective function below:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Translate parameter vector of length K + N*(R+Rex2) + T*(R+Rex1) back into
% The original parameters:
function [beta,alpha,gamma,lambda,f] = para_transform1(para,K,N,T,R,Rex1,Rex2)
    beta = para(1:K);
    lambda=zeros(N,R);
    f=zeros(T,R);
    alpha=zeros(N,Rex2);
    gamma=zeros(T,Rex1);
    for r = 1:R
      lambda(:,r) = para(K + (r-1)*N + (1:N)) * sqrt(N);
    end
    for r = 1:Rex2
      alpha(:,r)  = para(K + (R+r-1)*N + (1:N)) * sqrt(N);
    end
    for r = 1:R
      f(:,r)      = para(K + N*(R+Rex2) + (r-1)*T + (1:T)) * sqrt(T);
    end
    for r = 1:Rex1
      gamma(:,r)  = para(K + N*(R+Rex2) + (R+r-1)*T + (1:T)) * sqrt(T);
    end
return

% Translate original parameters into single parameter vector of length
% K + N*(R+Rex2) + T*(R+Rex1)
function para = para_transform2(beta,alpha,gamma,lambda,f)
    K    = length(beta);
    N    = size(lambda,1);
    T    = size(f,1);
    R    = size(lambda,2);
    Rex1 = size(gamma,2);
    Rex2 = size(alpha,2);

    para = zeros(K + N*(R+Rex2) + T*(R+Rex1),  1);

    para(1:K)=beta;
    for r=1:R
      para(K + (r-1)*N + (1:N))                = lambda(:,r)/sqrt(N);
    end
    for r=1:Rex2
      para(K + (R+r-1)*N + (1:N))              = alpha(:,r)/sqrt(N);
    end
    for r=1:R
      para(K + N*(R+Rex2) + (r-1)*T + (1:T))   = f(:,r)/sqrt(T);
    end
    for r=1:Rex1
      para(K + N*(R+Rex2) + (R+r-1)*T + (1:T)) = gamma(:,r)/sqrt(T);
    end
return

% Define the matrix of flat directions of the likelihood:
function v = flat_directions(alpha,gamma,lambda,f,lambda_known,f_known,K)
    N   = size(lambda,1);
    T   = size(f,1);
    R   = size(lambda,2);
    Rex1= size(lambda_known,2);
    Rex2= size(f_known,2);

    ff  = [f,f_known];
    ll  = [lambda,lambda_known];
    v   = zeros(K + N*(R+Rex2) + T*(R+Rex1),  (R+Rex2) * (R+Rex1));
    cnt = 0;
    for r1=1:R+Rex2
      for r2=1:R+Rex1
          ind1    = K + (r1-1)*N + (1:N);
          ind2    = K + N*(R+Rex2) + (r2-1)*T + (1:T);
          vv      = zeros(K + N*(R+Rex2) + T*(R+Rex1),1);
          vv(ind1)= ll(:,r2);
          vv(ind2)= -ff(:,r1);
          vv      = vv/norm(vv);
          cnt     = cnt+1;
          v(:,cnt)= vv;
      end
    end
return

% Normalize parameters:
function [alpha,gamma,lambda,f] = normalize(alpha,gamma,lambda,f,lambda_known,f_known)

     N              = size(lambda,1);
     T              = size(f,1);

     M_lambda_known = eye(N)-lambda_known/(lambda_known'*lambda_known)*lambda_known';
     M_f_known      = eye(T)-f_known/(f_known'*f_known)*f_known';

     % Find normalized alpha and gamma:
     Z      = alpha * f_known' + lambda_known * gamma' + lambda * f';
     Z      = Z - M_lambda_known * Z * M_f_known;   % part of index that can be explained by lambda_known and f_known
     gamma  = Z'*lambda_known/(lambda_known'*lambda_known);
     Z      = Z-lambda_known * gamma';
     alpha  = Z*f_known/(f_known'*f_known);

     % Find normalized lambda and f:
     f      = M_f_known * f;
     lambda = M_lambda_known * lambda;   % Already took care of everything that can be explained by f_known and lambda_known

     A      = sqrtm(f'*f/T);  % Note that this is symmetric
     f      = f/A;
     lambda = lambda*A;
 return



% Perform one iteration step using Newton-Raphson
function [beta,alpha,gamma,lambda,f,obj,v_reference,para_reference,b_reference] = ...
      stepNR(Y,X,weight,lambda_known,f_known,beta0,alpha0,gamma0,lambda0,f0,v_reference,para_reference,b_reference)

     K    = size(X,1);
     N    = size(X,2);
     T    = size(X,3);
     R    = size(lambda0,2);
     Rex1 = size(lambda_known,2);
     Rex2 = size(f_known,2);

     % Get log-likelihood, score, Hessian for each observation
     [obj0,score0,Hessian0] = SampleLogL(Y,X,weight,lambda_known,f_known,...
         beta0,alpha0,gamma0,lambda0,f0,1);

     % Rescale score and Hessian to account for parameter rescaling
     rescale  = [ones(K,1); sqrt(N)*ones(N*(R+Rex2),1); sqrt(T)*ones(T*(R+Rex1),1)];
     score0   = rescale .* score0;
     Hessian0 = (rescale*rescale') .* Hessian0;

     % Check if v_reference is still appropriate
     if b_reference>0
       v      = flat_directions(alpha0,gamma0,lambda0,f0,lambda_known,f_known,K);
       ev_min = min(abs(eig(v'*v_reference*v_reference'*v)));
     else
       ev_min = 0;
     end

     if ev_min < 0.1   % Criterion for updating reference parameter
       disp('updating reference parameter for penalized objective function');
       [alpha0,gamma0,lambda0,f0] = normalize(alpha0,gamma0,lambda0,f0,lambda_known,f_known);
       para_reference             = para_transform2(beta0,alpha0,gamma0,lambda0,f0);
       v_reference                = flat_directions(alpha0,gamma0,lambda0,f0,lambda_known,f_known,K);
       b_reference                = abs(trace(-Hessian0)/size(Hessian0,1));
     end

     % Penalized objective:
     para0   = para_transform2(beta0,alpha0,gamma0,lambda0,f0);
     objP    = obj0 - b_reference/2 * ((para0-para_reference)' * v_reference) * (v_reference' * (para0-para_reference));
     score   = score0 - b_reference * v_reference * (v_reference' * (para0-para_reference));
     Hessian = Hessian0 - b_reference * (v_reference * v_reference');

     epsilon_max = 1;
     epsilon_min = 10^(-4);
     epsilon     = 10^(-5);

     stop2=0;
     it_count = 1;
     while stop2==0
         direction = ( -Hessian + b_reference * epsilon * eye(size(Hessian,1)) ) \ score;
         direction = direction / norm(direction);
         step_para = direction * (direction'*score) / (direction' * (-Hessian) * direction);

         % Translate step_para into original parameters:
         [step_beta,step_alpha,step_gamma,step_lambda,step_f] = para_transform1(step_para,K,N,T,R,Rex1,Rex2);

         % Try to update parameters, making sure that penalized objective increases;
         % if we cannot make progress, then we try to make "a smaller step",
         % but the default step corresponds to fct = 1
         fct = 1;
         stop = 0;
         while stop == 0
             para = para0 + fct * step_para;
             beta = beta0 + fct * step_beta;
             lambda = lambda0 + fct * step_lambda;
             alpha  = alpha0 + fct * step_alpha;
             f = f0     + fct * step_f;
             gamma  = gamma0 + fct * step_gamma;
             it_count = it_count + 1;

             obj = SampleLogL(Y,X,weight,lambda_known,f_known,beta,alpha,gamma,lambda,f);
             objPnew = obj - b_reference/2 * ((para-para_reference)' * v_reference) * (v_reference' * (para-para_reference));
             if objPnew>objP
                 stop  = 1;
                 stop2 = 1;
             else
                 if (fct < 1/2) && (epsilon < epsilon_max * 0.9999)
                   fct = 1;
                   epsilon = max(epsilon_min, epsilon*10);
                   stop = 1;
                 else
                    % If we cannot make progress, then we reduce the "steplength"
                    fct = fct/2;
                    % Final stopping criterion
                    if fct < 10^(-4)
                       stop  = 1;
                       stop2 = 1;
                    end
                 end
             end
         end
     end

     % If no progress was made in the likelihood maximization, report the old parameters and objective
     if objPnew < objP
       beta   = beta0;
       alpha  = alpha0;
       gamma  = gamma0;
       f      = f0;
       lambda = lambda0;
       obj    = obj0;
     end

return

% Perform one iteration step (similar to EM)
% This is where Algorithm 1 is clearly instantiated
function [beta,alpha,gamma,lambda,f,obj] = step(Y,X,weight,lambda_known,f_known,beta0,alpha0,gamma0,lambda0,f0)

     K=size(X,1);
     N=size(X,2);
     T=size(X,3);
     R=size(lambda0,2);

    % Stepsize: if we cannot make progress, then we try to make "a smaller step",
    % but the default is fct = 0.5
     fct = 0.5;
     stop = 0;
     while stop==0
         % Definition of single index:
         Z = mult(X,beta0) + alpha0 * f_known' + lambda_known * gamma0' + lambda0 * f0';

         % Get corresponding log-likelihood and derivatives for each observation:
         [logL,dlogL,ddlogL] = model(Y,Z,weight);
         obj0                = mean(mean(logL));

         % Add dlogL./wt to single index
         Z = Z + fct * dlogL/mean(mean(-ddlogL));

         %PRINCIPAL COMPONENTS STEP TO GET NEW alpha,gamma,lambda,f:
         M_lambda_known = eye(N)-lambda_known/(lambda_known'*lambda_known)*lambda_known';
         M_f_known      = eye(T)-f_known/(f_known'*f_known)*f_known';
         res            = M_lambda_known * (Z - mult(X,beta0)) * M_f_known;

         [f,~]=eigs(res'*res,R);
         for r=1:R
             f(:,r)=f(:,r)/norm(f(:,r));
             if mean(f(:,r))<0
                 f(:,r)=-f(:,r);
             end
         end
         lambda = res*f;
         f      = f*sqrt(T);
         lambda = lambda/sqrt(T);

         res    = Z - mult(X,beta0) - lambda*f';
         gamma  = res'*lambda_known/(lambda_known'*lambda_known);
         res    = res-lambda_known * gamma';
         alpha  = res*f_known/(f_known'*f_known);

         % Update Z:
         Z                   = mult(X,beta0) + alpha * f_known' + lambda_known * gamma' + lambda * f';
         [logL,dlogL,ddlogL] = model(Y,Z,weight);
         obj1                = mean(mean(logL));

         % WLS STEP TO GET NEW beta, POSSIBILITY 1:
         Z                   = Z + fct * dlogL./mean(mean(-ddlogL));
         lambda_all          = [lambda,lambda_known];
         f_all               = [f,f_known];
         Mlambda_all         = eye(N)-lambda_all/(lambda_all'*lambda_all)*lambda_all';
         Mf_all              = eye(T)-f_all/(f_all'*f_all)*f_all';
         W                   = zeros(K,K);
         V                   = zeros(K,1);
         for k1 = 1:K
             Xk1   = Mlambda_all*squeeze(X(k1,:,:))*Mf_all;
             V(k1) = 1/N/T*trace(Xk1*Z');
             for k2 = 1:K
                 Xk2      = Mlambda_all*squeeze(X(k2,:,:))*Mf_all;
                 W(k1,k2) = 1/N/T*trace(Xk1*Xk2');
             end
         end
         beta=W\V;

         obj2 = mean(mean(model(Y,mult(X,beta) + alpha * f_known' + lambda_known * gamma' + lambda * f',weight)));
         if obj2 > obj0
        % We stop if the we indeed increased the likelihood function in this step.
           stop=1;
        % If we have not increased the likelihood, then we reduce the stepsize
        else
             fct=fct/2;
             % Final stopping criterion
             if fct<10^(-4)
               stop=1;
             end
         end
     end

     % If progress was made in the likelihood maximization, then report the new
     % objective and updated parameters...
     if obj2 > obj0
       obj = obj2;
    % ...otherwise report the old parameters and objective.
    else
       beta  = beta0;
       alpha = alpha0;
       gamma = gamma0;
       f     = f0;
       lambda= lambda0;
       obj   = obj0;
     end

return

function [logL, dlogL, ddlogL] = model(y, z, weight)
    logL = y.*z - exp(z);
    if nargout > 1
        dlogL  = (y - exp(z));
        ddlogL = - exp(z);
    end   
    
    % Weigh observations
    logL = weight .* logL;
    if nargout>1
        dlogL  = weight .* dlogL;  
        ddlogL = weight .* ddlogL;      
    end    
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% calculate full sample log-likelihood, score, Hessian:
%%%% NOTE: we do not include "dlogL" terms in the Hessian if Hlin=0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obj,s,H] = SampleLogL(Y,X,weight,lambda_known,f_known,beta,alpha,gamma,lambda,f,Hlin,logL,dlogL,ddlogL)
    %score and Hessian use the following order of parameters:
    %beta, lambda, alpha, f, gamma
    K = size(X,1);
    N = size(X,2);
    T = size(X,3);
    R = size(lambda,2);
    Rex1 = size(lambda_known,2);
    Rex2 = size(f_known,2);
    
    ff = [f,f_known];
    ll = [lambda,lambda_known];
    
    if nargin<=12  %if logL, dlogL, ddlogL not already provided as inputs, then compute them
        Z  = mult(X,beta) + alpha * f_known' + lambda_known * gamma' + lambda * f';
        [logL,dlogL,ddlogL] = model(Y,Z,weight);
    end  

  %calculate log-likelihood:
  obj=sum(sum(logL))/N/T;
  
  if nargout==1
    return  
  end    
 
  %calculate score:
  s = zeros(K + N*(R+Rex2) + T*(R+Rex1),1); 
  for k=1:K
    XX   = squeeze(X(k,:,:));  
    s(k) = sum(sum(dlogL .* XX))/N/T;
  end    
  for r=1:R+Rex2
    s(K + (r-1)*N + (1:N)) =  dlogL * ff(:,r)/N/T;
  end
  for r=1:R+Rex1
    s(K + N*(R+Rex2) + (r-1)*T + (1:T)) =  dlogL' * ll(:,r)/N/T;
  end
  
  if nargout==2
    return  
  end    
  
  %calculate Hessian:
  H = zeros(K + N*(R+Rex2) + T*(R+Rex1), K + N*(R+Rex2) + T*(R+Rex1)); 
  for k1=1:K
    X1          = squeeze(X(k1,:,:));  
    for k2=1:K
      X2        = squeeze(X(k2,:,:));  
      H(k1,k2)  = sum(sum(ddlogL .* X1 .* X2))/N/T;
    end  
    for r = 1:R+Rex2
      ind       =  K + (r-1)*N + (1:N);
      H(k1,ind) =  (X1.*ddlogL) * ff(:,r)/N/T;
      H(ind,k1) =  H(k1,ind)';
    end
    for r = 1:R+Rex1
      ind       =  K + N*(R+Rex2) + (r-1)*T + (1:T);  
      H(k1,ind) =  (X1.*ddlogL)' * ll(:,r)/N/T;
      H(ind,k1) =  H(k1,ind)';
    end
  end
  
  for r1 = 1:R+Rex2
    ind1           = K + (r1-1)*N + (1:N);  
    for r2 = 1:R+Rex2
      ind2         = K + (r2-1)*N + (1:N);  
      H(ind1,ind2) = diag(ddlogL * (ff(:,r1).*ff(:,r2)) /N/T );
    end
  end
  
  for r1 = 1:R+Rex1
    ind1           = K + N*(R+Rex2) + (r1-1)*T + (1:T);
    for r2 = 1:R+Rex1
      ind2         = K + N*(R+Rex2) + (r2-1)*T + (1:T);
      H(ind1,ind2) = diag(ddlogL' * (ll(:,r1).*ll(:,r2)) /N/T);
    end
  end

  for r1 = 1:R+Rex2
    ind1           = K + (r1-1)*N + (1:N);
    for r2 = 1:R+Rex1
      ind2         = K + N*(R+Rex2) + (r2-1)*T + (1:T); 
      H(ind1,ind2) = ddlogL .* ( ll(:,r2) * ff(:,r1)' )/N/T;
      H(ind2,ind1) = H(ind1,ind2)';
    end
  end
  
  if Hlin==1     %add terms in the Hessian, which are only there because index itself is non-linear.
                 %those terms depend on the first derivative of the
                 %log-likelihood (dlogL)         
    for r=1:R
      ind1         = K + (r-1)*N + (1:N);
      ind2         = K + N*(R+Rex2) + (r-1)*T + (1:T); 
      H(ind1,ind2) = H(ind1,ind2) + dlogL/N/T;
      H(ind2,ind1) = H(ind2,ind1) + dlogL'/N/T;
    end  
  end  
  
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% multiplication between beta and X to form NxT matrix:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mat = mult(X,beta)
    mat = zeros(size(X,2), size(X,3));
    for k = 1:size(X,1)
        mat = mat + beta(k) * squeeze(X(k,:,:));
    end
return