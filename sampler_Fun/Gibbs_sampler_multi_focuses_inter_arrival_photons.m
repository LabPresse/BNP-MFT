function [ Data ] = Gibbs_sampler_multi_focuses_inter_arrival_photons(...
...
...
Data          ,  Max_iter    , ...
handles       ,  GUI       )

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
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Data                          :  Updated data

     
% Shuffle the random generator
    rng('shuffle');
   
% Calculate the number of confocals
    Number_confocals = size(Data.Wxyz,2)                                  ;

% Calculate the number of traces
    Number_Traces = length(Data.Trace_partial)                            ;
    
% Calculate the size of the previous sample
    OLD_Iteration_size=length(Data.D)                                     ;

% Set the initial iteration number
    i=OLD_Iteration_size                                                  ;
    
% Check the Automatic command
    if  Data.Automatic==1
        save_size=0                                                       ;
        Max_iter=2                                                        ;
    end
    
% Precalculation of normalized distances lengths
    len_concen_radius = length(Data.concen_radious)                       ;
    
    
% Set the end loop command to zero
    endloop=0                                                             ;

% Calculate the length of each trace
for k=1:Number_Traces
    Trace_size(k)   = length(Data.Trace_partial{k}(1,:))                  ;
    BB{k}           = round(Data.Trace_partial{k}(2,:)+...
                       cumsum([0 repmat(Number_confocals,1,Trace_size(k)-1)]));
end


if  GUI==1
    if  Data.Automatic==0
        % Initialize the time bar
        cla(handles.axes23)
        set(handles.axes23,'Units','pixels','XLim',[0 1],'YLim',[0 1],...
            'XTick',[],'YTick',[],'Color','w','XColor','w','YColor','w')      ;
    
        patch(handles.axes23,[0 0 0 0],[0 1 1 0],'b')                         ;
        handles.text80.String ='Initializing ...'                             ; 
        time_loop             = 0                                             ;
        save_bar              = 1                                             ;
        drawnow
        tic
    end
end


% Pre calculations
AAA(1,:) = 1:3:3*Data.Num_mol                                    ;
AAA(2,:) = 2:3:3*Data.Num_mol                                    ;
AAA(3,:) = 3:3:3*Data.Num_mol                                    ;

% Initiate the MCMC chain based on the previous sampled values
for k=1:Number_Traces
    x{k} = Data.x{k}(:,:,end);
end


% Start the Gibbs sampling iteration loop
while endloop==0
    
     i                   = i+1                                            ;

    % Initiate square dicplacements of the molecules to zero
    kk_diffusion=0                                                        ;
    
    % Start the FOR loop on the number of traces
    for k=1:Number_Traces
        
        % Due to big size of the trajectories, we are thining the data
        if floor(i/10)-i/10==0
           Data.x{k} = cat(3 , Data.x{k} , x{k});
        end
        
        num_tr = (k-1)*Data.Num_mol+1:k*Data.Num_mol;
        
        % Keep the previous trajectories
        x_pp{k}=x{k};
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sampling ACTIVE trajectories for particle num_par in  imported signal k %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [x{k},Data.x_accept_rate ]  = Sample_trajectories_multi_focuses( ...
                        ...
         Data.Trace_partial{k}' , Data.mu(i-1,:)  , Data.mu_back(i-1,:) , Data.D(i-1)         , ...
         x_pp{k}'               , BB{k}           , Data.mu_prior_xyz   , Data.var_prior_xyz  , ...
         Data.b(i-1,num_tr)     , Trace_size(k)   , AAA                 , Data.x_accept_rate  , ...
         Data.HMC_step_size     , Data.demo       , Number_confocals    , Data.gg             , ...
         Data.gg_grad_x         , Data.gg_grad_y  , Data.gg_grad_z     );
          

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Sampling INACTIVE trajectories for imported signal k  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         x{k} = Sample_inactive_trajectories_multi_focuses( ...
              ...
         x{k}                              , Trace_size(k)       , Data.D(i-1)        , ...
         Data.Trace_partial{k}(1,1:end-1)  , Data.b(i-1,num_tr)  , Data.mu_prior_xyz  , ...
         Data.var_prior_xyz               );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compute concetration of the molecules in imported signal k in the ROI %
%%%%%%%%%%%%%% Also, compute the Constant to be used later %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if Data.single_confocal
         [Data.concentration{k}(upper_bound_save_11,:,:)  ]=fun_concentration(...
               ...
         x{k}                , AAA                , Trace_size    , Data.concen_radious  , ...
         Data.b(i-1,num_tr)  , len_concen_radius  , Data.Num_mol  , Data.gg_r           );
      end
        
% Calculate square diplacements of the molecules for each imported signal
% We will use it to sample the diffusion coefficient.
        kk_diffusion=kk_diffusion+sum((ones(1,3*Data.Num_mol)*...
                           (diff(x{k},1,2).^2))./Data.Trace_partial{k}(1,1:end-1));
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Sample the diffusion coefficient %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Data.D(i)   =    1/gamrnd(Data.D_alpha+((sum(Trace_size-1))*1.5*Data.Num_mol) , ...
                     1/( Data.D_beta+(0.25*kk_diffusion)));
        
                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sample the loads, hyper prior on the loads, molecule and background photon emission rates %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the new samples equal to the old ones
Data.mu(i,:)               = Data.mu(i-1,:)      ;
Data.mu_back(i,:)          = Data.mu_back(i-1,:) ;
Data.b(i,:)                = Data.b(i-1,:)       ;

% Since we sample the loads, mu and mu_back through a metropolis-hastings, we sample
% them several times to have a better mixture.

       for j=1:Data.iter_b_mu
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%%%%%%%%%%%%%%%%% Update the emission rates %%%%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           [ Data.mu(i,:)  , Data.mu_back(i,:) , Data.mu_accept_rate ] = Sample_emission_rates_multi_focuses( ...
           ...
           ...
           Data.mu_proposal      , Data.mu_alpha       , Data.mu_beta        , Data.mu(i,:)        , ...
           Data.mu_back_proposal , Data.mu_back_alpha  , Data.mu_back_beta   , Data.mu_back(i,:)   , ...
           Data.mu_accept_rate   , Data.Num_mol        , Data.Trace_partial  , Number_confocals    , ...
           Data.b(i,:)           , Number_Traces       , Trace_size          , Data.gg             , ...
           x                     , AAA                 , BB                 );

           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%%%%%%%%%% Update the weight over loads (hyper priors) %%%%%%%%%%%%%%%
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           for k=1:Number_Traces
               num_tr = (k-1)*Data.Num_mol+1:k*Data.Num_mol;
               
               if length(num_tr)>1
               [ Data.b(i,num_tr) ] = Sample_Loads_b_multi_focuses(...
                   ...
                Data.b(i,num_tr)   , Data.mu(i,:)'         , Data.Trace_partial{k} , ...
                Data.Num_mol       , Data.mu_back(i,:)'    , Data.Q                , ...
                Trace_size(k)      , x{k}                  , AAA                   , ...
                Data.gg            , BB{k}                 , Data.BB_size          , ...
                Data.BB_loads       );
               else
                   Data.b(i,num_tr) =1;
               end
           end
       end

       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Correct the tajectories labeles by Hungarian algorithm %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Data.single_confocal==false
   for k=1:Number_Traces
       num_tr = (k-1)*Data.Num_mol+1:k*Data.Num_mol;
       
       [ x{k} , Data.b(i,num_tr) ]= Label_switching(...
               ...
       Data.b(i-1,num_tr)  , x_pp{k}       , Data.b(i,num_tr)  , x{k}   , ...
       Data.mu(i-1,:)      , Data.mu(i,:)  , Data.gg           , AAA    , ...
       Data.Num_mol         );
   end
end
       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAP estimate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Data] = maximum_posteriori( Data , Trace_size  , Data.Num_mol , AAA              , ...
                             BB   , x           , i            , Number_confocals );

                         
                         
                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%% Save and plot the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if  find((OLD_Iteration_size+floor((1:1:Data.save_size).*Max_iter./Data.save_size))==i)>=1
%     if i<10000 && i>100
%        if  Data.x_accept_rate(1)/Data.x_accept_rate(2) >0.65
%                   Data.HMC_step_size=Data.HMC_step_size*1.1;
%        else
%                   Data.HMC_step_size=Data.HMC_step_size*0.9;
%        end
%        Data.x_accept_rate=[0 ;0];
%     end
    if  GUI==1
        % Plot the remaining time
        if  Data.Automatic==0
            time_loop=time_loop+toc;
            remaining_time=floor((time_loop/(save_bar.*Max_iter./Data.save_size))*...
                              ((Data.save_size-save_bar).*Max_iter./Data.save_size)*10)/10;
                 
            handles.text80.String=['Remaining time = ', num2str(remaining_time),' s'];
            patch(handles.axes23,[0 0 save_bar/Data.save_size save_bar/Data.save_size],[0 1 1 0],'b');
            save_bar=save_bar+1;
            tic
        end
    end
    % Save the results based on the save size
    if Data.Save_on_off ==1
       save('results' , 'Data' ,'-v7.3','-nocompression')
    end
    if  GUI==1
        % Plot the sampler results at each save size interval
        if  handles.pushbutton8.Value==1   ||  handles.pushbutton20.Value==1     
            plot(handles.axes8,1:1:i,Data.D(1:i))
            xlabel(handles.axes8,'Iteration')
            ylabel(handles.axes8,'Diff. coef. (\mum^2/s)')
            xlim(handles.axes8,[0 i])
            ylim(handles.axes8,[0 max(Data.D(1:i))])
            set(handles.axes8,'yscale','log') 
                  
            for k=1:Number_Traces
                plot(handles.axes15,1:1:i,sum(Data.b(:,(k-1)*Data.Num_mol+1:k*Data.Num_mol),2),'color',[0, 0.4470, 0.7410])
                hold (handles.axes15,'on')
                histogram(handles.axes18,sum(Data.b(:,(k-1)*Data.Num_mol+1:k*Data.Num_mol),2),...
                                       'Normalization','Probability','Orientation','horizontal','facecolor',[0, 0.4470, 0.7410])
                hold (handles.axes18,'on')
            end
            hold (handles.axes15,'off')
            xlabel(handles.axes15,'Iteration')
            ylabel(handles.axes15,{'Number of';'active molecules'})
            ylim(handles.axes15,[0 Data.Num_mol])
            xlim(handles.axes15,[0 i])
    
            hold (handles.axes18,'off')
            handles.axes18.YTick = [];
            handles.axes18.XTick = [];
            handles.axes18.XAxisLocation = 'top';
            ylim(handles.axes18,[0 Data.Num_mol])
                 
            
            
            for j=1:Number_confocals
                plot(handles.axes16, 1:1:i ,Data.mu(1:i,j) ,'color',[0, 0.4470, 0.7410] )
                hold (handles.axes16,'on')
                histogram(handles.axes20,Data.mu(1:i,j),'Normalization','Probability','Orientation','horizontal','facecolor',[0, 0.4470, 0.7410])
                hold (handles.axes20,'on')
                
                plot(handles.axes26, 1:1:i ,Data.mu_back(1:i,j) ,'color',[0, 0.4470, 0.7410] )
                hold (handles.axes26,'on')
                histogram(handles.axes27,Data.mu_back(1:i,j),'Normalization','Probability','Orientation','horizontal','facecolor',[0, 0.4470, 0.7410])
                hold (handles.axes27,'on')
            end
            hold (handles.axes16,'off')
            hold (handles.axes20,'off')
            hold (handles.axes26,'off')
            hold (handles.axes27,'off')
               
            xlabel(handles.axes16,'Iteration')
            ylabel(handles.axes16,{'Molecule brightness';'(photons/s)'})
            xlim(handles.axes16,[0 i])
            
            handles.axes20.YTick = [];
            handles.axes20.XTick = [];
            handles.axes20.XAxisLocation = 'top';
            ylim(handles.axes20,[0 max(max(Data.mu(1:i,:)))])
            
            xlabel(handles.axes26,'Iteration')
            ylabel(handles.axes26,{'Background photon';'emission rate';'(photons/s)'})
            xlim(handles.axes26,[0 i])
            
            handles.axes27.YTick = [];
            handles.axes27.XTick = [];
            handles.axes27.XAxisLocation = 'top';
            ylim(handles.axes27,[0 max(max(Data.mu_back(1:i,:)))])
    
            
            bnd = logspace(log10(min(Data.D(1:i)))-1,log10(max(Data.D(1:i)))+1,100);

            histogram(handles.axes19,Data.D(1:i),bnd,'Normalization','pdf','Orientation','horizontal')
            handles.axes19.XAxisLocation = 'top';
            ylim(handles.axes19,[0 max(Data.D)])
            handles.axes19.YTick = [];
            handles.axes19.XTick = [];
            handles.axes19.YAxisLocation = 'right';
            set(handles.axes19,'yscale','log') 
              
            
            % Plot the Maximum posteriory trajectory of the molecules
            if  Data.single_confocal==false
                for k=1:length(Data.Trace_partial)
                    timing=cumsum(Data.Trace_partial{k}(1,:));
                    
                    burn_in=floor(size(Data.b,1)*40/100);
                    HJ=histcounts(sum(Data.b(burn_in:end,(k-1)*Data.Num_mol+1:k*Data.Num_mol),2),1:1:Data.Num_mol+1);
                    max_num_active(k)=min(find(HJ==max(HJ)));
                    
                    for  hh=1:Data.Num_mol
                         molecules(k,hh)=sum(Data.b(:,(k-1)*Data.Num_mol+hh));
                    end
    
    
                    [~,AB]=sort(molecules(k,:),'descend');
                    Active_molecules=AB(1:max_num_active(k));
                    

                    begin_of=1;

                    ell    = char(hex2dec(strsplit('2113')));
                    learned=[];
                    learned_25=[];
                    learned_75=[];

                    numpa=Active_molecules;

                    for numpar=numpa
                        learned(1,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);
                        learned(2,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);
                        learned(3,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);

                        learned_25(1,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);
                        learned_25(2,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);
                        learned_25(3,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);

                        learned_75(1,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
                        learned_75(2,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
                        learned_75(3,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
                        size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
                    
                    
                        plot(handles.axes28,timing,learned(1,:),'b')
                        hold(handles.axes28,'on')
                        plot(handles.axes28,timing,learned_25(1,:),'m')
                        plot(handles.axes28,timing,learned_75(1,:),'m')
                        
                        plot(handles.axes31,timing,learned(2,:),'b')
                        hold(handles.axes31,'on')
                        plot(handles.axes31,timing,learned_25(2,:),'m')
                        plot(handles.axes31,timing,learned_75(2,:),'m')
                        
                        plot(handles.axes32,timing,learned(3,:),'b')
                        hold(handles.axes32,'on')
                        plot(handles.axes32,timing,learned_25(3,:),'m')
                        plot(handles.axes32,timing,learned_75(3,:),'m')
                    end
                    
                    if isfield(Data,'X')
                       for mm=1:size(Data.X,1)
                           plot(handles.axes28,timing,Data.X_partial{k}(mm,:),'g')
                           plot(handles.axes31,timing,Data.Y_partial{k}(mm,:),'g')
                           plot(handles.axes32,timing,Data.Z_partial{k}(mm,:),'g')      
                           
                           ylim(handles.axes28,[-Data.Lxyz(1) Data.Lxyz(1)])
                           ylim(handles.axes31,[-Data.Lxyz(2) Data.Lxyz(2)])
                           ylim(handles.axes32,[-Data.Lxyz(3) Data.Lxyz(3)])
                        end
                    end
                end
                hold(handles.axes28,'off')
                hold(handles.axes31,'off')
                hold(handles.axes32,'off')
                
                handles.axes28.XTick = [];
                handles.axes31.XTick = [];
             
                xlabel(handles.axes32,'Time (s)')
             
                ylabel(handles.axes28,'X (\mum)')
                ylabel(handles.axes31,'Y (\mum)')
                ylabel(handles.axes32,'Z (\mum)')
             
                xlim(handles.axes28,[min(timing) max(timing)])
                xlim(handles.axes31,[min(timing) max(timing)])
                xlim(handles.axes32,[min(timing) max(timing)])
             

            end
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
    if  Data.save_size<floor(i/10000)    
        Data.save_size=floor(i/10000);
        handles.edit41.String=Data.save_size;
        Max_iter=i;
        handles.edit39.String=Max_iter;
    end
    if  floor(i/10000)==i/10000
        siz=floor(i/4);
        m75=mean(Data.D(2*siz:3*siz)) ;
        m100=mean(Data.D(3*siz:i));
      
        if (abs(m75-m100)/m75)*100<Data.percentage_dif
            endloop=1;
        end  
    end
end
% End of the MCMC chain loop
end

% save the last sampled trajectories
for k=1:Number_Traces
    Data.x{k} = cat(3 , Data.x{k} , x{k});
end

% GUI visualizations
if  GUI==1
    % End of the iteration loop and show "Done!" as a note.
    if  Data.Automatic==0
        handles.text80.String='Done!';
    end
    for k=1:Number_Traces
        if Trace_size(k)<50
           handles.text80.String='Length of the trace is too small to be meaningfull!!';
        end
    end
end

% End of the function
end 