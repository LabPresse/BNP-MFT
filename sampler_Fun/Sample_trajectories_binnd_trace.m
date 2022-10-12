% Sampling the trajectory of molecules by Hamiltonian Monte carlo (HMC) 
% Written by Sina Jazani
%
% 04-09-2020     Matlab 2019a


function[positions ,rec]  =  Sample_trajectories_binnd_trace( ...
    ...
    ...
observation    , I            , ...
I_b            , phi          , ...
positions      , Num_part     , ...
mu_prior       , var_prior    , ...
b              , sign_siz     , ...
PSF_func       , AAA          , ...
Time           , rec          , ...
HMC_step_size  , HMC_step_Num , ...
demo           ) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % observation              :  Intensity trace as our observation
     % I                        :  Molecular brightness
     % I_b                      :  Background emission rate
     % phi                      :  Vector of the kinetic variances at each coordinates
     % positions                :  Locations of all molecules
     % Num_par                  :  The tag for targeted molecule
     % mu_prior                 :  Mean value for prior of X0 in normalized scale for x, y and z coordintes
     % var_prior                :  Variance for prior of X0 in normalized scale for x, y and z coordintes
     % b                        :  Loads
     % sign_siz                 :  length of the trace
     % PSF_func                 :  Point Spread Function type ( '3D Gaussian', '2D Gaussian-Lorentzian' or '2D Gaussian-Cylindrical')
     % AAA                      :  Pre-calculations to be used in likelihood calculations
     % Time                     :  Data acquisition time
     % rec                      :  Acceptance of the HMC
     % HMC_step_size            :  Step size of the HMC
     % demo                     :  Visulaization of HMC for calibration perposus
     
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % positions                :  Updated position of targeted molecules
     % rec                      :  Updated acceptance of the HMC 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%  Precalculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AA=[ 1 , 2 , 3 ; ...
     2 , 1 , 3 ; ...
     3 , 1 , 2];
 
 
% Start the FOR loop on the number of molecules
for num_par=1:Num_part
        
    % Check if the molecule num_par is active (b=1)
    if  b(num_par)==1 
        
        nump = (num_par-1)*3;
        
        % Calculate the effect of the other molecule on the likelihood
        b(num_par) = 0;

        % Choose the function for PSF
        switch  PSF_func
            
            case 1    %%%%% 3D Gaussian PSF %%%%%
                     constant1 = I_b+I.*(b*exp(-2*((positions(AAA(1,:),:).^2) ...
                                                  +(positions(AAA(2,:),:).^2) ...
                                                  +(positions(AAA(3,:),:).^2))));                         

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  nn=1,2,3 as X, Y , Z  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     for nn = 1:3
                         hh=HMC_step_size*randg(1);

                         [positions(nump+AA(nn,1),:),rec] = HMC_binned_time_trace( ...
                         ...
                         positions(nump+AA(nn,1) ,:)' , sign_siz     , phi(AA(nn,1))      , (1/var_prior(AA(nn,1)))  , ...
                         positions(nump+AA(nn,2) ,:)  , observation  , mu_prior(AA(nn,1)) , constant1*Time           , ...
                         positions(nump+AA(nn,3) ,:)  , I*Time       , rec                , demo                     , ...
                         hh                           , HMC_step_Num   );
                     end
        
            case 2         %%%% Lorentzian-Gaussian PSF %%%%
                     constant1 = I_b+(b*(I.*exp(-2*(( positions(AAA(1,:),:).^2) ...
                                                    +(positions(AAA(2,:),:).^2))./...
                                                  (1+(positions(AAA(3,:),:).^2)))./...
                                                  (1+(positions(AAA(3,:),:).^2))));
               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  nn=1,2,3 as X, Y , Z  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     for nn=1:3
                         hh=HMC_step_size*randg(1);
                         if  AA(nn,1)==3
                             [positions(nump+AA(nn,1),:),rec] = HMC_binned_time_trace_Lorent_z( ...
                             ...
                             positions(nump+AA(nn,1) ,:)' , sign_siz    , phi(AA(nn,1))    , (1/var_prior(AA(nn,1)))  , ...
                             positions(nump+AA(nn,2) ,:)  , observation , mu_prior(AA(nn,1)) , constant1*Time           , ...
                             positions(nump+AA(nn,3) ,:)  , I*Time      , rec                , demo                     , ...
                             hh                           , HMC_step_Num );
                         else
                             [positions(nump+AA(nn,1),:),rec] = HMC_binned_time_trace_Lorent_xy( ...
                              ...
                             positions(nump+AA(nn,1) ,:)' , sign_siz    , phi(:,AA(nn,1))    , (1/var_prior(AA(nn,1)))  , ...
                             positions(nump+AA(nn,2) ,:)  , observation , mu_prior(AA(nn,1)) , constant1*Time           , ...
                             positions(nump+AA(nn,3) ,:)  , I*Time      , rec                , demo                     , ...
                             hh                           , HMC_step_Num );
                         end
                     end       
            otherwise      %%%%% Cylindrical PSF %%%%%
                     constant1 = I_b+I*(b*exp(-2*(positions(AAA(1,:),:).^2 ...
                                                  +positions(AAA(2,:),:).^2)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%  nn=1,2  as X, Y   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     for nn = 1:2
                         hh=HMC_step_size*randg(1); 
                         [positions(nump+AA(nn,1),:),rec] = HMC_binned_time_trace_Cylinder( ...
                         ...
                         positions(nump+AA(nn,1) ,:)' , sign_siz    , phi(AA(nn,1))      , (1/var_prior(AA(nn,1)))  , ...
                         positions(nump+AA(nn,2) ,:)  , observation , mu_prior(AA(nn,1)) , constant1*Time(1)        , ...
                         I*Time                       , rec         , demo               , hh                       , HMC_step_Num );
                     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%  Z coordinate from random walk  %%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     positions(nump+3,:) =  cumsum([((-1)^(floor(2*rand())))*mu_prior(3) + sqrt(var_prior(3))*randn(),...
                                              sqrt(1./phi(3)).*randn(1,sign_siz-1)],2) ;
        end
        b(num_par)=1;
    end  % End of if condition on the active molecules
end  % End of the loop on the molecules

end % End of the function