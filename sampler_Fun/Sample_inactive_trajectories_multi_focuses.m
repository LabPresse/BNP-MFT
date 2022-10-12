function[ x ] = Sample_inactive_trajectories_multi_focuses( ...
...
...
x          , sign_siz   , D          , ...
Time       , b          , mu_prior   , ...
var_prior  )   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % x                   :  Molecular trajectories (Normalized)
     % sign_siz            :  Length of the observation trace
     % Time                :  Data acquisition time
     % b                   :  Loads for active molecules
     % mu_prior            :  Mean value of initial positions prior  ( Normal distribution)
     % var_prior           :  Variance of initial positions prior    ( Normal distribution)
     % D                   :  Old sampled diffusion coefficent

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % x                   :  Sampled inactive molecular trajectories


% Check if the load on molecule is off
     active_molecules = find(b==0);

% Measure the nmber of inactive molecuules
     size             = length(active_molecules);

% Calculate the kinetics
     k               = repmat(sqrt(2*D*Time),size,1) ;

    
% Sample the locations of molecules through brownian motion
     x(3*active_molecules-2,:) = cumsum([((-1)^(floor(2*rand())))*mu_prior(1) + sqrt(var_prior(1))*randn(size,1),...
                                             k.*randn(size,sign_siz-1)],2)                            ;
     x(3*active_molecules-1,:) = cumsum([((-1)^(floor(2*rand())))*mu_prior(2) + sqrt(var_prior(2))*randn(size,1),...
                                             k.*randn(size,sign_siz-1)],2)                            ;
     x(3*active_molecules  ,:) = cumsum([((-1)^(floor(2*rand())))*mu_prior(3) + sqrt(var_prior(3))*randn(size,1),...
                                             k.*randn(size,sign_siz-1)],2)                            ;

end