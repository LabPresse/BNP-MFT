function [ Data ] = Generative_model_inter_arrival( Data , handles   , GUI    )
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Data                    :  All of parameters
     % handles                 :  GUI information
     % GUI                     :  A control for GUI 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Data                    :  All of parameters and generated data
     

% Initialize the vectors
Data.X      = zeros( Data.Num_mol_real , Data.Length_signal     ) ;
Data.Y      = zeros( Data.Num_mol_real , Data.Length_signal     ) ;
Data.Z      = zeros( Data.Num_mol_real , Data.Length_signal     ) ;
Data.Trace  = nan  ( 2                 , Data.Length_signal     ) ;
CC          = nan  ( Data.Num_mol_real , length(Data.PSF_func) ) ;

if GUI==1
% Initialize the time bar
   cla(handles.axes23)
   set(handles.axes23,'Units','pixels','XLim',[0 1],'YLim',[0 1],...
           'XTick',[],'YTick',[],'Color','w','XColor','w','YColor','w');
    
   patch(handles.axes23,[0 0 0 0],[0 1 1 0],'b');
   handles.text80.String='Initializing ...';
   drawnow
   time_loop =0 ;
   save_bar=1;
   tic
end
    
    

% Randomly sample the location of the molecules from the uniform probability
for jk1=1:Data.Num_mol_real
    Data.X(jk1,1) = Data.Lxyz(1)*(1-2*rand());
    Data.Y(jk1,1) = Data.Lxyz(2)*(1-2*rand());
    Data.Z(jk1,1) = Data.Lxyz(3)*(1-2*rand());
    CC(jk1,:)     = Data.gg(Data.X(jk1,1),Data.Y(jk1,1),Data.Z(jk1,1));
end

muu             = Data.mu_back_real+Data.mu_real.*sum(CC,1);

% Sample the photon arriving time
Data.Trace(1,1) = exprnd( 1/sum( muu ,2) );

% Sampling the detector
Data.Trace(2,1) = Discrete_sampler( muu );

for i=2:Data.Length_signal
    
    % Measure the kinetic step size
    k=sqrt(2*Data.D_real*Data.Trace(1,i-1));
    
    for j1  = 1:Data.Num_mol_real

        % Sample the locations based on brownian motion
        Data.X(j1,i) = Data.X(j1,i-1)+(k*randn());
        Data.Y(j1,i) = Data.Y(j1,i-1)+(k*randn());
        Data.Z(j1,i) = Data.Z(j1,i-1)+(k*randn());
       
        % Periodoc boundaries
        if  Data.X(j1,i) >= Data.Lxyz(1)
            Data.X(j1,i)  = Data.X(j1,i)-2*Data.Lxyz(1);
        end  
        if  Data.X(j1,i) <= -Data.Lxyz(1)
            Data.X(j1,i)  = Data.X(j1,i)+2*Data.Lxyz(1);
        end 
        if  Data.Y(j1,i) >= Data.Lxyz(2)
            Data.Y(j1,i)  = Data.Y(j1,i)-2*Data.Lxyz(2);
        end  
        if  Data.Y(j1,i) <= -Data.Lxyz(2)
            Data.Y(j1,i)  = Data.Y(j1,i)+2*Data.Lxyz(2);
        end
        if  Data.Z(j1,i) >= Data.Lxyz(3)
            Data.Z(j1,i)  = Data.Z(j1,i)-2*Data.Lxyz(3);
        end  
        if  Data.Z(j1,i) <= -Data.Lxyz(3)
            Data.Z(j1,i)  = Data.Z(j1,i)+2*Data.Lxyz(3);
        end
        CC(j1,:) = Data.gg(Data.X(j1,i),Data.Y(j1,i),Data.Z(j1,i));
        
    end

    muu             = Data.mu_back_real+Data.mu_real.*sum(CC,1);
    
    % Sample the photon arriving time
    Data.Trace(1,i) = exprnd(1/sum(muu,2));
    
    % Sampling the detector
    Data.Trace(2,i) = Discrete_sampler( muu );
    
    if GUI==1
       if find((floor((1:1:10).*(Data.Length_signal +1)./10))==i)>=1
          time_loop=time_loop+toc;
          remaining_time=floor((time_loop/(save_bar.*(Data.Length_signal +1)./10))*((10-save_bar).*...
                                                     (Data.Length_signal +1)./10)*10)/10;
          handles.text80.String=['Remaining time = ', num2str(remaining_time),' s'];
          patch(handles.axes23,[0  0  save_bar/10  save_bar/10],[0 1 1 0],'b');
          save_bar=save_bar+1;
          drawnow
          tic
       end
    end
    
                     
end % end of time loop

if  isfield(Data,'k')==1
    Data=rmfield(Data,'k');
end
    
   if  GUI==1
       handles.text80.String='Done!';
       patch(handles.axes23,[0  0  save_bar  save_bar],[0 1 1 0],'b');
       drawnow
   end

end