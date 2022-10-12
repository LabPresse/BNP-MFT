function [ Data  ] = Gibbs_sampler_binned_single_focus_confocal_volume(...
...
...
Data       , Max_iter  , ...
handles    , GUI         , Trace_size    )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Data                          :  data
     % save_size                     :  Portion of the MCMC chains to be saved
     % Max_iter                      :  Number if iterations
     % iter_b_mu                     :  Number of iner-loop iterations
     % handles                       :  Control values of the GUI
     % percentage_dif                :  Persnetage different of the posteriors in automatic convergance 
     % GUI                           :  Indicator on the GUI version
     % Trace_size                    :  Length of the traces
     
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Data                          :  Updated data


     
% Shuffle the random generator
    rng('shuffle');

   
% Calculate the number of traces
    Number_trace = length(Trace_size)                                          ;

    
% Calculate the size of the previous sample
    OLD_Iteration_size=length(Data.D)                                          ;

% Set the initial iteration number
    i=OLD_Iteration_size                                                  ;
    
    
% Check the Automatic command
    if  Data.Automatic==1
        save_size=0                                                       ;
        Max_iter=2                                                        ;
    end
    

% Set the end loop command to zero
    endloop=0                                                             ;

% Calculate the length of each trace
    for k=1:Number_trace
       if Trace_size(k)<30
           endloop=1;
       end
    end
    
% Precalculation of normalized distances lengths
    len_concen_radius = length(Data.concen_radious)                       ;


if GUI==1
   if  Data.Automatic==0
% Initialize the time bar
       cla(handles.axes23)
       set(handles.axes23,'Units','pixels','XLim',[0 1],'YLim',[0 1],...
           'XTick',[],'YTick',[],'Color','w','XColor','w','YColor','w')   ;
    
       patch(handles.axes23,[0 0 0 0],[0 1 1 0],'b')                      ;
       handles.text80.String ='Initializing ...'                          ; 
       time_loop             = 0                                          ;
       save_bar              = 1                                          ;
       drawnow
       tic
   end
end


% Normalize the initial positions prior
Mu_prior_xyz  = Data.mu_prior_xyz./Data.Wxyz'               ;
Var_prior_xyz = Data.var_prior_xyz./(Data.Wxyz'.^2);


% Pre calculation
AAA(1,:) = 1:3:3*Data.Number_molecules                            ;
AAA(2,:) = 2:3:3*Data.Number_molecules                            ;
AAA(3,:) = 3:3:3*Data.Number_molecules                            ;

% Number of HMC steps
HMC_step_Num = 30;


% Start the Gibbs sampling iteration loop
while endloop==0

     % iteration counter
     i = i+1                                                                   ;

     % Initiate square dicplacements of the molecules to zero
     kk_diffusion=0                                                            ;

     % Set the upper bound for number sampled trajectories
     upper_bound_save=i-(floor((i-1)/10000)*10000);
 
     
     % Pre-calculation of the variance of the kinetics at each time step and coordiante
     phi = ((Data.Wxyz.^2)./(2*Data.D(i-1)*Data.bin))  ;
     
    
% Start the FOR loop on the number of imported signals
for k=1:Number_trace
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sampling ACTIVE trajectories for particle num_par in  imported signal k %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Data.x{k} , Data.x_accept_rate ]  = Sample_trajectories_binnd_trace( ...
      ...
    Data.Trace_partial{k}                                                 , ...
    Data.mu(i-1)                                                          , ...
    Data.mu_back(i-1)                                                     , ...
    phi                                                                   , ...
    Data.x{k}                                                             , ...
    Data.Number_molecules                                                 , ...
    Mu_prior_xyz                                                          , ...
    Var_prior_xyz                                                         , ...
    Data.b(i-1,(k-1)*Data.Number_molecules+1:k*Data.Number_molecules)     , ...
    Trace_size(k)                                                         , ...
    Data.PSF_func                                                         , ...
    AAA                                                                   , ...
    Data.bin                                                              , ...
    Data.x_accept_rate                                                    , ...
    Data.HMC_step_size                                                    , ...
    HMC_step_Num                                                          , ...
    Data.demo                                                             );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Sampling INACTIVE trajectories for imported signal k  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Data.x{k}  = Sample_inactive_molecules_binned( ...
        ...
    Data.x{k}                                                             , ...
    Trace_size(k)                                                         , ...
    Data.bin                                                              , ...
    Data.b(i-1,(k-1)*Data.Number_molecules+1:k*Data.Number_molecules)     , ...
    Mu_prior_xyz                                                          , ...
    Var_prior_xyz                                                         , ...
    Data.Wxyz                                                             , ...
    Data.D(i-1)                                                           );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compute concetration of the molecules in imported signal k in the ROI %
%%%%%%%%%%%%%% Also, compute the Constant to be used later %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   [Constant{k}   , Data.concentration{k} ]=fun_concentration_bin(...
        ...
    Data.x{k}                                                             , ...
    AAA                                                                   , ...
    upper_bound_save                                                      , ...
    Trace_size(k)                                                         , ...
    Data.concen_radious                                                   , ...
    Data.PSF_func                                                         , ...
    Data.b(i-1,(k-1)*Data.Number_molecules+1:k*Data.Number_molecules)     , ...
    Data.concentration{k}                                                 , ...
    len_concen_radius                                                     );


% Calculate square diplacements of the molecules for each imported signal
% We will use it to sample the diffusion coefficient. 
        kk_diffusion=kk_diffusion+sum((repmat(Data.Wxyz'.^2,1,Data.Number_molecules)*...
                           (diff(Data.x{k},1,2).^2))./Data.bin);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Sample the diffusion coefficient %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Data.D(i)   =    1/gamrnd(Data.D_alpha+((sum(Trace_size-1))*1.5*Data.Number_molecules) , ...
                     1/( Data.D_beta+(0.25*kk_diffusion))); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  Sample the loads, hyper prior on the loads,   %%%%%%%%%%%%%%%%
%%%%%%%%%%%  molecule and background photon emission rates %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Set the new samples equal to the old ones
       Data.b(i,:)         = Data.b(i-1,:)       ;
       Data.mu(i,1)        = Data.mu(i-1,1)      ;
       Data.mu_back(i,1)   = Data.mu_back(i-1,1) ;
       
       for j=1:Data.iter_b_mu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Update the emission rates %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           [ Data.mu(i,1)  , Data.mu_back(i,1) , Data.mu_accept_rate ] = Sample_emission_rates_bin( ...
           ...
           ...
           Data.mu_proposal          , Data.mu_alpha              , ...
           Data.mu_beta              , Data.mu(i,1)               , ...
           Data.mu_back_proposal     , Data.mu_back_alpha         , ...
           Data.mu_back_beta         , Data.mu_back(i,1)          , ...
           Data.mu_accept_rate       , Data.Trace_partial         , ...
           Data.bin                  , Constant                   , ...
           Data.b(i,:)               , Trace_size                 , ...
           Data.Number_molecules    );
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Update the loads %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           for k=1:Number_trace
               [Data.b(i,(k-1)*Data.Number_molecules+1:k*Data.Number_molecules) ] =  ...
                   ...
                Sample_Loads_bin( ...
                 ...
                Data.b(i,(k-1)*Data.Number_molecules+1:k*Data.Number_molecules) , ...
                Data.mu(i)                                                      , ...
                Data.mu_back(i)                                                 , ...
                Constant{k}                                                     , ...
                Data.Trace_partial{k}                                           , ...
                Data.bin                                                        , ...
                Data.Number_molecules                                           , ...
                Data.Q                                                          , ...
                Data.BB_size                                                    , ...
                Data.BB_loads                                                  );
           end
       end
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAP estimate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      [Data] = maximum_posteriori_bin( Data , Trace_size , Data.Number_molecules , AAA , i);

       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%% Save and plot the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

       if find((OLD_Iteration_size+floor((1:1:Data.save_size).*Max_iter./Data.save_size))==i)>=1
           if i<10000 && i>100
              if  Data.x_accept_rate(1)/Data.x_accept_rate(2) >0.65
                  Data.HMC_step_size=Data.HMC_step_size*1.1;
              else
                  Data.HMC_step_size=Data.HMC_step_size*0.9;
              end
              Data.x_accept_rate=[0 ;0];
           end

             if  GUI==1
                 % Plot the remaining time
                 if  Data.Automatic==0
                     time_loop=time_loop+toc;
                     remaining_time=floor((time_loop/(save_bar.*Max_iter./Data.save_size))*((Data.save_size-save_bar).*Max_iter./Data.save_size)*10)/10;
                 
                     handles.text80.String=['Remaining time = ', num2str(remaining_time),' s'];
                     patch(handles.axes23,[0 0 save_bar/Data.save_size save_bar/Data.save_size],[0 1 1 0],'b');
                     save_bar=save_bar+1;
                     tic
                 end
             end

                 % Save the results based on the save size
                 if Data.Save_on_off 
                    save('results' , 'Data' )
                 end
            if GUI==1              
                 % Plot the sampler results at each save size interval
                 if  handles.pushbutton8.Value==1   ||  handles.pushbutton20.Value==1     
                 plot(handles.axes8,1:1:i,Data.D(1:i))
                 xlabel(handles.axes8,'Iteration')
                 ylabel(handles.axes8,'Diff. coef. (\mum^2/s)')
                 xlim(handles.axes8,[0 i])
                 ylim(handles.axes8,[0 max(Data.D(1:i))])
                 set(handles.axes8,'yscale','log') 
                  
                 for k=1:Number_trace
                     plot(handles.axes15,1:1:i,sum(Data.b(:,(k-1)*Data.Number_molecules+1:k*Data.Number_molecules),2),'color',[0, 0.4470, 0.7410])
                     hold (handles.axes15,'on')
                     histogram(handles.axes18,sum(Data.b(:,(k-1)*Data.Number_molecules+1:k*Data.Number_molecules),2),...
                                       'Normalization','Probability','Orientation','horizontal','facecolor',[0, 0.4470, 0.7410])
                     hold (handles.axes18,'on')
                 end
                 hold (handles.axes15,'off')
                 xlabel(handles.axes15,'Iteration')
                 ylabel(handles.axes15,{'Number of';'active molecules'})
                 ylim(handles.axes15,[0 Data.Number_molecules])
                 xlim(handles.axes15,[0 i])
                 
                 hold (handles.axes18,'off')
                 handles.axes18.YTick = [];
                 handles.axes18.XTick = [];
                 handles.axes18.XAxisLocation = 'top';
                 ylim(handles.axes18,[0 Data.Number_molecules])
                 
    
               
                 plot(handles.axes16, 1:1:i , Data.mu(1:i) ,'color',[0, 0.4470, 0.7410])
                 histogram(handles.axes20,Data.mu(1:i),'Normalization','Probability','Orientation','horizontal','facecolor',[0, 0.4470, 0.7410])
                 xlabel(handles.axes16,'Iteration')
                 ylabel(handles.axes16,{'Molecular brightness';'(photons/s)'})
                 xlim(handles.axes16,[0 i])
    
                 handles.axes20.YTick = [];
                 handles.axes20.XTick = [];
                 handles.axes20.XAxisLocation = 'top';
                 ylim(handles.axes20,[0 max(Data.mu(1:i))])
                 
                 
                 plot(handles.axes26, 1:1:i , Data.mu_back(1:i) ,'color',[0, 0.4470, 0.7410])
                 histogram(handles.axes27,Data.mu_back(1:i),'Normalization','Probability','Orientation','horizontal','facecolor',[0, 0.4470, 0.7410])
                 xlabel(handles.axes26,'Iteration')
                 ylabel(handles.axes26,{'Background photon';'emission rate';'(photons/s)'})
                 xlim(handles.axes26,[0 i])
                 
                 handles.axes27.YTick = [];
                 handles.axes27.XTick = [];
                 handles.axes27.XAxisLocation = 'top';
                 ylim(handles.axes27,[0 max(Data.mu_back(1:i))])
                 
                 
                 bnd = logspace(log10(min(Data.D(1:i)))-1,log10(max(Data.D(1:i)))+1,100);

                 histogram(handles.axes19,Data.D(1:i),bnd,'Normalization','pdf','Orientation','horizontal')
                 handles.axes19.XAxisLocation = 'top';
                 ylim(handles.axes19,[0 max(Data.D)])
                 handles.axes19.YTick = [];
                 handles.axes19.XTick = [];
                 handles.axes19.YAxisLocation = 'right';
                 set(handles.axes19,'yscale','log') 
                 
                 
                 drawnow
                 end
            end
       end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Convergance %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% In order to stop the MCMC chain automatically, we applied a convergance 
% method based on the mean values of the last two quarters of the sampled 
% diffusion coefficient and comparing these values with the convergence threshold

% For an adequate sample size, we consider 10000 iterations to be the minimum sample size

if  Data.Automatic==0
    if i==Max_iter+OLD_Iteration_size
       endloop=1;
    end
else
    if GUI==1
       if  Data.save_size<floor(i/10000)    
           Data.save_size=floor(i/10000);
           handles.edit41.String=Data.save_size;
           Max_iter=i;
           handles.edit39.String=Max_iter;
       end
    end
    if floor(i/10000)==i/10000
       siz=floor(i/4);
       m75=mean(Data.D(2*siz:3*siz)) ;
       m100=mean(Data.D(3*siz:i));
      
       if (abs(m75-m100)/m75)*100<Data.percentage_dif
           endloop=1;
       end  
    end
end
 

end

% End of the iteration loop and show "Done!" as a note.
if GUI==1
   if  Data.Automatic==0
       handles.text80.String='Done!';
   end


   for k=1:Number_trace 
       if Trace_size(k)<30
          handles.text80.String='Length of the trace is too small to be meaningfull!!';
       end
   end
end
end