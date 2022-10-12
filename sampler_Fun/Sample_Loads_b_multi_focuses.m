function[ b ]    =  Sample_Loads_b_multi_focuses( ...
...
...
b          , I         , Trace          , Number_molecules  , ...
I_back     , Q         , Trace_size     , X                 , ...
AAA        , PSFs      , BB             , BB_size           , ...
BB_loads   )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % b                             :  Old sampled loads 
     % I                             :  Moelcular brightness
     % Trace                         :  single photon inter arrival times
     % Number_molecules              :  Maximum number of molecules
     % I_back                        :  Background photon emission rate
     % Q                             :  Probability of a load be equal to 1
     % Trace_size                    :  Length of the single photon inter arrival times
     % X                             :  Molecular trajectories
     % AAA                           :  Pre-calculated values
     % PSFs                          :  PSF functions
     % BB                            :  Pre-calculated values
     % BB_size                       :  Precalculations to directly sample the loads
     % BB_loads                      :  Precalculations to directly sample the loads
     
          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % b                             :  Updated loads
   


% pre-calculations
AS_1=log((1/Q)-1);
AS_2=log(1-Q);


for n=1:Number_molecules
    G_1(:,:,n)=I.*PSFs( X(AAA(1,n),1:Trace_size)',...
                        X(AAA(2,n),1:Trace_size)',...
                        X(AAA(3,n),1:Trace_size)' )' ;
end
    

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
        
        GG_2 = I_back+(sum(permute(AB(ll,:),[1,3,2]).*G_1,3));
    
        logr(ll) = sum(log(GG_2(BB(1:end-1)))-Trace(1,1:end-1).*sum(GG_2(:,1:end-1),1))+...
                           ...
                           ...
                   log(GG_2(BB(end))/sum(GG_2(:,end)));
    end
   
    
% Sampling the configuration of loads from the catogerical distribution of all posteriors
    b(np)=BB_loads{np_size}( Discrete_sampler( softmax( logr-AS_1*sum(BB_loads{np_size},2)+np_size*AS_2)),:);

end

   
end