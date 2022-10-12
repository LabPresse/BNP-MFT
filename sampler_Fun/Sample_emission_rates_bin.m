function[ MU , MU_BACK , mu_acceptance_rate ] = Sample_emission_rates_bin( ...
...
...
mu_proposal          , mu_alpha       , ...
mu_beta              , MU_OLD         , ...
mu_back_proposal     , mu_back_alpha  , ...
mu_back_beta         , MU_BACK_OLD    , ...
mu_acceptance_rate   , Trace          , ...
Time                 , Constant       , ...
b                    , sign_siz       , ...
Num_part             ) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % mu_proposal                   :  Proposal parameter for MU           ( Gamma distribution)
     % mu_alpha                      :  Alpha parameter of MU prior         ( Gamma distribution)
     % mu_beta                       :  Beta parameter of MU prior          ( Gamma distribution)
     % MU_OLD                        :  Previous sampled molecular brightness
     % mu_back_proposal              :  Proposal parameter for MU_back       ( Gamma distribution)
     % mu_back_alpha                 :  Alpha parameter of MU_back prior     ( Gamma distribution)
     % mu_back_beta                  :  Beta parameter of MU_back prior      ( Gamma distribution)
     % MU_BACK_OLD                   :  Previous background emission rate
     % mu_acceptance_rate            :  Previous acceptance rate 
     % Trace                         :  Intensity trace as our observation
     % Time                          :  Data acqisition time
     % Constant                      :  Precalculated likelihood
     % b                             :  Loads for active molecules
     % sign_siz                      :  Length of the observation signal
     % Num_part                      :  Number of model molecules
     
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % MU                            :  Updated MU
     % MU_BACK                       :  Updated MU Background
     % mu_acceptance_rate            :  Updated acceptance rate


% Propose MU from a gamma distribution
     MU_NEW      = (MU_OLD/mu_proposal).*randg(mu_proposal)                 ; 
     MU_BACK_NEW = (MU_BACK_OLD/mu_back_proposal).*randg(mu_back_proposal)  ;

 % Calculate the likelihood
         constant1=0;
         for k  = 1:length(sign_siz)
  
                 neww      = (MU_BACK_NEW + MU_NEW*(b(1,(k-1)*Num_part+1:k*Num_part)*Constant{k})) ;
                          
                 oldd      = (MU_BACK_OLD + MU_OLD*(b(1,(k-1)*Num_part+1:k*Num_part)*Constant{k})) ;
                          
                 constant1 = constant1 + sum(Trace{k}.*log(neww./oldd) +(oldd-neww).*Time) ;
         end

% Calculate the logarithm of posterior ratio                           
         logr = constant1 + ...
                 ...
                ((2*mu_proposal-mu_alpha)*log(MU_OLD/MU_NEW))+...
                ((MU_OLD-MU_NEW)/mu_beta)+...
                (mu_proposal*((MU_NEW/MU_OLD)-(MU_OLD/MU_NEW)))+...
                ...
                ((2*mu_back_proposal-mu_back_alpha)*log(MU_BACK_OLD/MU_BACK_NEW))+...   
                ((MU_BACK_OLD-MU_BACK_NEW)/mu_back_beta)+...
                (mu_back_proposal*((MU_BACK_NEW/MU_BACK_OLD)-(MU_BACK_OLD/MU_BACK_NEW)));

    

% Accept or reject the proposals
     if  logr>log(rand())
         MU                    = MU_NEW                   ;
         MU_BACK               = MU_BACK_NEW              ;
         mu_acceptance_rate    = mu_acceptance_rate+1     ;
     else
         MU                    = MU_OLD                   ;
         MU_BACK               = MU_BACK_OLD              ;
         mu_acceptance_rate(1) = mu_acceptance_rate(1)+1  ;
     end
         
end