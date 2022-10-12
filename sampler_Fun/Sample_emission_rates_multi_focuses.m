function[ MU , MU_BACK , mu_acceptance_rate ] = Sample_emission_rates_multi_focuses( ...
...
...
mu_proposal          , mu_alpha           , mu_beta              , MU_OLD             , ...
mu_back_proposal     , mu_back_alpha      , mu_back_beta         , MU_BACK_OLD        , ...
mu_acceptance_rate   , Number_molecules   , Trace                , Num_confocals      , ...
b                    , Number_Traces      , Trace_size           , gg                 , ...
X                    , AAA                , BB                   )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % mu_proposal                   :  Proposal parameter for MU           ( Gamma distribution)
     % mu_alpha                      :  Alpha parameter of MU prior         ( Gamma distribution)
     % mu_beta                       :  Beta parameter of MU prior          ( Gamma distribution)
     % MU_OLD                        :  Previous sampled molecular brightnesses
     % mu_back_proposal              :  Proposal parameter for MU_back       ( Gamma distribution)
     % mu_back_alpha                 :  Alpha parameter of MU_back prior     ( Gamma distribution)
     % mu_back_beta                  :  Beta parameter of MU_back prior      ( Gamma distribution)
     % MU_BACK_OLD                   :  Previous background emission rates
     % mu_acceptance_rate            :  Previous acceptance rate 
     % Number_molecules              :  Number of model molecules
     % Trace                         :  Single photon inter-arrival time traces
     % Num_confocals                 :  Number of confocals
     % b                             :  Loads
     % Number_Traces                 :  Number of traces
     % Trace_size                    :  Size of the traces
     % gg                            :  PSF functions
     % X                             :  Molecular trajectories
     % AAA                           :  Pre-calculated values
     % BB                            :  Pre-calculated values
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % MU                            :  Updated MU
     % MU_BACK                       :  Updated MU Background
     % mu_acceptance_rate            :  Updated acceptance rate


% Propose MU from a gamma distribution
     MU_NEW      = (MU_OLD/mu_proposal).*randg(mu_proposal,1,Num_confocals)                 ; 
     MU_BACK_NEW = (MU_BACK_OLD/mu_back_proposal).*randg(mu_back_proposal,1,Num_confocals)  ;


% Calculate the logarithm of posterior ratio
constant=0;

for k=1:Number_Traces
    GG_1_new=zeros(Trace_size(k),Num_confocals);
    GG_1_old=zeros(Trace_size(k),Num_confocals);
    for n=1:Number_molecules
        GG=gg( X{k}(AAA(1,n),1:Trace_size(k))',...
               X{k}(AAA(2,n),1:Trace_size(k))',...
               X{k}(AAA(3,n),1:Trace_size(k))');
                
        GG_1_new = GG_1_new + b(1,(k-1)*Number_molecules+n).*GG;
        GG_1_old = GG_1_old + b(1,(k-1)*Number_molecules+n).*GG;
    end

    GG_1p_new=(MU_BACK_NEW+ (MU_NEW.*GG_1_new))';
    GG_1p_old=(MU_BACK_OLD+ (MU_OLD.*GG_1_old))';

     constant = constant+ ...
         Trace{k}(1,1:end-1)*sum(GG_1p_old(:,1:end-1)-GG_1p_new(:,1:end-1),1)'...
         +sum( log(GG_1p_new(BB{k}(1:end-1))./GG_1p_old(BB{k}(1:end-1))) )+...
                  ...
                  log(GG_1p_new(BB{k}(end))./sum(GG_1p_new(:,end)))-...
                  log(GG_1p_old(BB{k}(end))./sum(GG_1p_old(:,end)));
end
     
     logr = constant+ ...
            sum(((2*mu_proposal-mu_alpha)*log(MU_OLD./MU_NEW))+...
                ((MU_OLD-MU_NEW)/mu_beta)+...
                (mu_proposal*((MU_NEW./MU_OLD)-(MU_OLD./MU_NEW)))+...
                ...
                ((2*mu_back_proposal-mu_back_alpha)*log(MU_BACK_OLD./MU_BACK_NEW))+...   
                ((MU_BACK_OLD-MU_BACK_NEW)/mu_back_beta)+...
                (mu_back_proposal*((MU_BACK_NEW./MU_BACK_OLD)-(MU_BACK_OLD./MU_BACK_NEW))));

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