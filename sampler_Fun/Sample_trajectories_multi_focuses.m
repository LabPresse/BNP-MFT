% Sampling the trajectory of molecules by Hamiltonian Monte carlo (HMC) 
% Written by Sina Jazani
%
% 04-09-2020     Matlab 2019a

function[Positions ,rec]  =  Sample_trajectories_multi_focuses( ...
    ...
Trace            , I          , I_b              , D          , ...
positions        , BB         , mu_prior         , var_prior  , ...
b                , sign_siz   , AAA              , rec        , ...
HMC_step_size    , demo       , Number_confocals , gg         , ...
gg_grad_x        , gg_grad_y  , gg_grad_z        ) 
              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Trace                    :  Single photon inter-arrival time trace
     % I                        :  Vector of molecular brightnesses for all confocals
     % I_b                      :  Vector of background emission rates for all confocals
     % D                        :  Diffusion coefficient
     % positions                :  Locations of all molecules
     % BB                       :  Pointer location of label on the detectors for each detected photon
     % mu_prior                 :  Mean value of prior of the first location in x, y and z coordintes
     % var_prior                :  Variance of prior of the first location in x, y and z coordintes
     % b                        :  Loads
     % sign_siz                 :  length of the time trace
     % AAA                      :  Pre-calculations to be used in likelihood calculations
     % rec                      :  Acceptance of the HMC
     % HMC_step_size            :  Step size of the HMC
     % demo                     :  Visulaization of HMC for calibration perposus
     % Number_confocals         :  Number of confocal volumes
     % gg                       :  Anonymous Functions of the likelihood
     % gg_grad_x                :  Anonymous Functions of the gradient of likelihood in x direction
     % gg_grad_y                :  Anonymous Functions of the gradient of likelihood in y direction
     % gg_grad_z                :  Anonymous Functions of the gradient of likelihood in x direction

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % positions                :  Updated position of targeted molecules
     % rec                      :  Updated acceptance of the HMC

     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%  Precalculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phi            = 1./(2*D*Trace(1:end-1,1))  ;   % Dynamics
Max_inner_iter = 10                         ; % Set the number of inner loops in HMC

% Calculate the effect of the other molecule on the likelihood
constant_total=I_b + zeros(sign_siz,Number_confocals);
active_mols = find(b==1);
for hj=active_mols
    constant_total = constant_total +(I.*gg(positions(:,AAA(1,hj)) ,...
                                            positions(:,AAA(2,hj)) ,...
                                            positions(:,AAA(3,hj)) )); 
end

                                                 
                                                 
% Start the FOR loop on the number of molecules
for nump=(active_mols-1)*3
        
        constant_total = constant_total -(I.*gg(positions(:,nump+1) ,...
                                                positions(:,nump+2) ,...
                                                positions(:,nump+3) ));
                          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     X     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hh=HMC_step_size*randg(1);

        [ positions(:,nump+1)   , rec ] = HMC_Multi_focuses_single_molecule( ...
                     ...
        [ positions(:,nump+1)  , ...
          positions(:,nump+2)  , ...
          positions(:,nump+3)] , sign_siz          , phi(:,1)     , ...
        (1/var_prior(1))       , Trace(1:end-1,1)  , mu_prior(1)  , ...
        constant_total         , I                 , rec          , ...
        demo                   , hh                , Trace(:,2)   , ...
        gg                     , gg_grad_x         , 1            , ...
        BB                     , Max_inner_iter   );

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     Y      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hh=HMC_step_size*randg(1);
        
        [ positions(:,nump+2) , rec ] = HMC_Multi_focuses_single_molecule( ...
                     ...
        [ positions(:,nump+1)  , ...
          positions(:,nump+2)  , ...
          positions(:,nump+3)] , sign_siz          , phi(:,1)     , ...
        (1/var_prior(2))       , Trace(1:end-1,1)  , mu_prior(2)  , ...
        constant_total         , I                 , rec          , ...
        demo                   , hh                , Trace(:,2)   , ...
        gg                     , gg_grad_y         , 2            , ...
        BB                     , Max_inner_iter    );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      Z      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hh=HMC_step_size*randg(1);
        
        [ positions(:,nump+3) , rec ] = HMC_Multi_focuses_single_molecule( ...
                     ...
        [ positions(:,nump+1)  , ...
          positions(:,nump+2)  , ...
          positions(:,nump+3)] , sign_siz          , phi(:,1)     , ...
        (1/var_prior(3))       , Trace(1:end-1,1)  , mu_prior(3)  , ...
        constant_total         , I                 , rec          , ...
        demo                   , hh                , Trace(:,2)   , ...
        gg                     , gg_grad_z         , 3            , ...
        BB                     , Max_inner_iter    );

        constant_total = constant_total +(I.*gg(positions(:,nump+1) ,...
                                                positions(:,nump+2) ,...
                                                positions(:,nump+3) ));

end

Positions = positions';
end




%% HMC posterior sampler for sample 1D trajectory based the single photon inter-arrival times, and is modified for implicit diffusion
function [x_new,rec] = HMC_Multi_focuses_single_molecule( ...
    ...
X              , N          , phi        , V0              , ...
w              , mu         , I_b        , I_mol           , ...
rec            , demo       , h          , BBB_confocals   , ...
gg             , gg_grad    , nn         , BB              , ...
Max_inner_iter  )


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%   Propose the trajectory based on HMC    %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Precalculations of the implicit solver
  g0  = 2/h;
  d2  = 0.5*h*[ phi(1,1)+V0                  ;...
                phi(1:end-1,1)+phi(2:end,1)  ;...
                phi(end,1)                  ];
  F1  = g0 + d2;
  F2  = g0 - d2;
  psi = -0.5*phi(:,1)*h;


  
  
% pre-allocation
x_mid = nan(N,Max_inner_iter);
p_mid = nan(N,Max_inner_iter);



% Initialzing
j     = 1;

% Sample the momenta from a standard normal distribution
p_mid(:,j) = randn(N,1);  % [mass]*[q]/[time] , mass=1 otherwise sqrt(m).*randn(N,1)

x_mid(:,j) = X(:,nn);

Xp         = X;


% Visualization of the HMC
if demo; Gim = HMC_plot([],Max_inner_iter,N, x_mid, p_mid); end

% half-step (apply only Vq)
    p_mid(:,1) = p_mid(:,1) -0.5*h*get_V_SPh_grad_Multi_focuses( X, w, I_b, I_mol, N, BBB_confocals, gg, gg_grad , BB);

% Start the for loop of HMC
for j = 2:Max_inner_iter
    
    % whole-step (apply M and Lq)
    x_mid(:,j) = tri_solver_single_photons(N,F1,psi,(2*p_mid(:,j-1))+(F2.*x_mid(:,j-1))-([-(h*mu*V0);psi.*x_mid(1:N-1,j-1)])-([psi.*x_mid(2:N,j-1);0]));
    Xp(:,nn)   = x_mid(:,j);
    
    % whole-step (apply only Vq)
    p_mid(:,j) = g0.*(x_mid(:,j)-x_mid(:,j-1))-p_mid(:,j-1)-h*get_V_SPh_grad_Multi_focuses( Xp , w , I_b , I_mol , N , BBB_confocals , gg , gg_grad  , BB);

    % Visualization of the HMC
    if demo; HMC_plot(Gim,[],N, x_mid, p_mid); end
end
% End the for loop of HMC

% half-step adjustment
p_mid(:,j) = p_mid(:,j) + 0.5*h*get_V_SPh_grad_Multi_focuses( Xp , w , I_b , I_mol , N , BBB_confocals , gg , gg_grad  , BB);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%     Metropolis-Hastings    %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the acceptance ratio
    log_a = get_V_SPh_Multi_focuses(X , Xp , w , I_b , I_mol , N , BBB_confocals, gg ,BB) ...
          + 0.5*V0*( (x_mid(1,1)-mu)^2 - (x_mid(1,end)-mu)^2 ) ...
          + 0.5*sum( (diff(x_mid(:,1)).^2 - diff(x_mid(:,end)).^2).*phi ) ...
          + 0.5*sum( (p_mid(:,1).^2-p_mid(:,end).^2) );


% Accept or reject 
    if log(rand) < log_a            % accept
        x_new  = x_mid(:,end) ;
        rec    = rec    + 1   ;
    else                            % reject
        x_new  = x_mid(:,1)   ;
        rec(2) = rec(2) + 1   ;
    end

end


%% HMC potential (likelihood only) of the Multi-confocal volumes, single photon inter-arrival time traces
function V = get_V_SPh_Multi_focuses(X_old , X_new , w , I_b , I_mol , sizee , BBB_confocals, gg ,BB)

    test_old = (I_b+I_mol.*gg( X_old(:,1) , X_old(:,2) , X_old(:,3) ))';
    test_new = (I_b+I_mol.*gg( X_new(:,1) , X_new(:,2) , X_new(:,3) ))';
    
% Calculate the gradiant sizee (Last point)
    V      = (sum(test_old(:,1:end-1)-test_new(:,1:end-1),1)*w) + ...
             sum(log((test_new(BB(1:sizee-1))+eps)./(test_old(BB(1:sizee-1))+eps) +eps)) -...
             log( (test_old(BBB_confocals(sizee),end)/sum(test_old(:,end)))./...
                  (test_new(BBB_confocals(sizee),end)/sum(test_new(:,end))));
end


%% HMC potential gradient (likelihood only) of the Multi-confocal volumes, single photon inter-arrival time traces
function Vq = get_V_SPh_grad_Multi_focuses(X ,w , I_b , I_mol , sizee , BBB_confocals,gg ,gg_grad ,BB)
         

   test_1          = I_b+ I_mol.*gg( X(:,1) , X(:,2) , X(:,3) );
   test_2          = I_mol.*gg_grad( X(:,1) , X(:,2) , X(:,3) );

   G=(test_2./test_1)';

   % Calculate the gradiant 1:sizee-1
   Vq(1:sizee-1,1) = w.*sum(test_2(1:end-1,:),2) - G(BB(1:end-1))' ;

   % Calculate the gradiant sizee (Last point)
   Vq(sizee,1)     = ((test_1(end,BBB_confocals(end))*sum(test_2(end,:))-...
                       test_2(end,BBB_confocals(end))*sum(test_1(end,:))))/...
                      (test_1(end,BBB_confocals(end))*sum(test_1(end,:)));
end

