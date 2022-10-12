function[ b ]    =  Sample_Loads_bin( ...
...
...
b                 , I            , I_back            , Constant     , ...
observation       , Time         , Number_molecules  , Q            , ...
BB_size           , BB_loads     )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % b                             :  Old sampled loads
     % I                             :  Moelcular brightness
     % I_back                        :  Background photon emission rate
     % Constant                      :  Precalculated likelihood
     % observation                   :  Intensity trace as our observation
     % Time                          :  Data acquisition time
     % Number_molecules              :  Number of defined molecules
     % Q                             :  Probability of a load be equal to 1
     % BB_size                       :  Precalculations to directly sample the loads
     % BB_loads                      :  Precalculations to directly sample the loads
    
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % b                             :  Updated loads
   

     
     
% pre-calculations
AS_1=log((1/Q)-1);
AS_2=log(1-Q);


NN=ones(1,Number_molecules);

while sum(NN)>0

    np=[];
    for n=1:BB_size(end,2)
        % Randomly select a group of loads
        np(n)=Discrete_sampler(NN);
        NN(np(n))=0;
        if sum(NN)==0
            break;
        end
    end

    np_size=length(np);
    AB=repmat(b,BB_size(np_size,1),1);
    AB(:,np)=BB_loads{np_size};

    % Total number of configurations
    total_configs =2^np_size;
    
    % Pre-localizing
    logr=zeros(total_configs,1);
           
    % Calculating the posteriors of all possible configurations of the loads
    for ll=1:total_configs
        oldd  =(I_back + I*(AB(ll,:)*Constant)).*Time;
        logr(ll) = sum(observation.*log(oldd)-oldd);
    end

    
% Sampling the configuration of loads from the catogerical distribution
    b(np)=BB_loads{np_size}( Discrete_sampler( softmax( logr-AS_1*sum(BB_loads{np_size},2)+np_size*AS_2)),:);

end




  
   
end