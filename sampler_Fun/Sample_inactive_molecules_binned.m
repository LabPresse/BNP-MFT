function[ x ] = Sample_inactive_molecules_binned( ...
...
...
x          , sign_siz   , Time   , b    , ...
mu_prior   , var_prior  , Wxyz   , D   )   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % x                             :  Molecular trajectories (Normalized)
     % sign_siz                      :  Length of the observation trace
     % Time                          :  Data acquisition time
     % b                             :  Loads for active molecules
     % mu_prior                      :  Mean value of initial positions prior  ( Normal distribution)
     % var_prior                     :  Variance of initial positions prior    ( Normal distribution)
     % Wxyz                          :  Radius of the confocal in x, y and z coordinates
     % D                             :  Old sampled diffusion coefficent

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % x                             :  Sampled inactive molecular trajectories


% Pre-calculation of the kinetic at each time step

% Check if the load on molecule is off
     inactive_molecules = find(b==0);

% Measure the nmber of inactive molecuules
     size             = length(inactive_molecules);

% Calculate the kinetics

     kx               = repmat(sqrt(2*D*Time)./Wxyz(1),size,1) ;
     ky               = repmat(sqrt(2*D*Time)./Wxyz(2),size,1) ;
     kz               = repmat(sqrt(2*D*Time)./Wxyz(3),size,1)   ;

% Sample the locations of molecules through brownian motion
     x(3*inactive_molecules-2,:) = cumsum([((-1)^(floor(2*rand())))*mu_prior(1) + sqrt(var_prior(1))*randn(size,1),...
                                             kx.*randn(size,sign_siz-1)],2)                            ;
     x(3*inactive_molecules-1,:) = cumsum([((-1)^(floor(2*rand())))*mu_prior(2) + sqrt(var_prior(2))*randn(size,1),...
                                             ky.*randn(size,sign_siz-1)],2)                            ;
     x(3*inactive_molecules  ,:) = cumsum([((-1)^(floor(2*rand())))*mu_prior(3) + sqrt(var_prior(3))*randn(size,1),...
                                             kz.*randn(size,sign_siz-1)],2)                            ;

end