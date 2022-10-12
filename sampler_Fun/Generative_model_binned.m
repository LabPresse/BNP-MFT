function [ Data ] = Generative_model_binned( Data  , handles   , GUI    )
  
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
Data.X       = zeros( Data.Number_molecules_real , Data.Length_signal ) ;
Data.Y       = zeros( Data.Number_molecules_real , Data.Length_signal ) ;
Data.Z       = zeros( Data.Number_molecules_real , Data.Length_signal ) ;
CC           = zeros( 1                          , Data.Length_signal ) ;

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
    
% Precalculation of the kinetic
k=sqrt(2*Data.D_real*Data.bin);


% Randomly sample the initial locations of the molecules from the uniform probability
for jk1=1:Data.Number_molecules_real
    Data.X(jk1,1) = Data.Lxyz(1)*(1-2*rand());
    Data.Y(jk1,1) = Data.Lxyz(2)*(1-2*rand());
    Data.Z(jk1,1) = Data.Lxyz(3)*(1-2*rand());
    CC(1,1)       = CC(1,1)+Data.gg(Data.X(jk1,1),Data.Y(jk1,1),Data.Z(jk1,1));
end
  

for i=2:Data.Length_signal
   
    for j1  = 1:Data.Number_molecules_real

        % Sample the locations based on simple brownian motion
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
        
        CC(1,i) = CC(1,i)+Data.gg(Data.X(j1,i),Data.Y(j1,i),Data.Z(j1,i));
    end
    
    
    
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

% Sampling the numbers of photons from the poisson distribution
Data.Trace = poissrnd(Data.bin.*(Data.mu_back_real + Data.mu_real*CC));

   if  GUI==1
       handles.text80.String='Done!';
       patch(handles.axes23,[0  0  save_bar  save_bar],[0 1 1 0],'b');
       drawnow
   end

end