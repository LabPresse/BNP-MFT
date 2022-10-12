%%%%%%%%%%%%%%% Multi-diffusive species analysis v4.1 %%%%%%%%%%%%%%%%%%%%%
%%%% In the case of problem, please contact 
%%%% Sina Jazani (sjazani@asu.ed) or Dr. Steve Presse (spresse@asu.edu).
%%%% The code is written by Sina Jazani (2020-05-01)


%%%%%%%%%%%%%%%%%%%%% Import experimental traces %%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%  In the case that the user want to import an experimental trace:
%%%%
%%%%    -  The imported trace should ba a vector of single photon arrival times.
%%%%    -  Start from step 3 user choose a segment of the imported trace.
%%%%    -  In step 4 choose the sections of the imported trace.
%%%%    -  In step 5 user provide parameters of the algorithm.
%%%%    -  In step 6 run the algorithm.
%%%%    -  In step 7 visulize the results.
%%%%    *  It is necessary for the user to define wxy, wz, and PSF_func type before runnig the step 5.
%%%%
%%%%       PSF_func = 1 -> 3D gaussian
%%%%       PSF_func = 2 -> 2D Gaussian-Lorentzian
%%%%       PSF_func = 3 -> 2D Gaussian-cylindrical


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Step 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clear the history %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;close all

% Since it is the source code, handles of the GUI need to be pre defined
handles=[];

% Add the function folder to the path
addpath('sampler_Fun')

% Add the raw data folder to the path
addpath('raw_data')


% Creat the MEX files related to the thomas algorithm and save them in the folder of 'sampler_Fun'
Current_folder = cd;
cd([Current_folder,'/sampler_Fun'])
mex tri_solver_binned.c
mex tri_solver_single_photons.c
cd(Current_folder)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 1
%%%%%%%%%%%%%%%% Define the parameters of the simulation  %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Model types = 1 -> Single molecule time trace 
% Model types = 2 -> Binned trace (The first values will be used for a single-focus confocal volume)
Data.Model_type            =     1     ;  

% Number of steps in binned trace or photons in inter-arrival time series case
Data.Length_signal         = 10000     ;

% Number of molecules
Data.Num_mol_real =     1     ;

% Deffusion coefficient
Data.D_real                =     1     ;

% For multi-focuses confocal volumes setup, please provide vectores for mu, mu_back, Wxyz and PSF

% Molecular brightness(s) (photons/s)
Data.mu_real               =  (10^5).*[1.0  1.1  1.2  1.3]  ;

% Background photon emission rate(s) (photons/s)
Data.mu_back_real          =    4*(10^3).*[1.0  1.1  1.2  1.3]  ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%     PSF     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  3D Gaussian             = 1 
%  2D Gaussian-Lorentzian  = 2 
%  2D Gaussian-Cylindrical = 3
Data.PSF_func              =  [  1      1      1     1   ]; 

% Semi-axis of confocal volume(s) in x, y and z axis (micro meter)
Data.Wxyz                  =  [  0.37   0.37   0.37  0.37 ;...
                                 0.37   0.37   0.37  0.37 ;...
                                 0.8    0.8    0.8   0.8 ];   

% Center of PSF(s) in respect to the point of origin %%%%%
Data.Cxyz                  =  [ -0.2    0.2    0.0   0.0 ;...
                                 0.0    0.0   -0.2   0.2 ;...
                                -0.4   -0.4    0.4   0.4 ];
             

% Periodic boundary in x, y and z axes (micro-meter)
Data.Lxyz                  =  [1.2 ,1.2 , 2.5];   


% since the available code for multi-focus confocal volumes is only valid
% for the single photon inter-arrival times, in the case of binned data, we
% only consier a single confocal volume at the center
if Data.Model_type==2
   Data.bin             = 10^-4                ;    % Binsize (second)
   Data.Wxyz            = Data.Wxyz(:,1)       ;
   Data.Cxyz            = [0;0;0]              ;
   Data.mu_real         = Data.mu_real(1)      ;
   Data.mu_back_real    = Data.mu_back_real(1) ;
   Data.PSF_func        = Data.PSF_func(1)     ;
   Data.single_confocal = true                 ;
else
   if   length(Data.Wxyz(1,:))>1
        Data.single_confocal = false;
   else
        Data.single_confocal = true;
   end
end
     

% Precalculation of the PSFs and their gradiant
[Data] = PSF_calculation(Data);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 2
%%%%%%%%%%%%%%%%%%%%%%%% Generate synthetic trace %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tt=0;
while tt==0
if  Data.Model_type==2
    [ Data ] = Generative_model_binned( Data  , [] , 0 );
else
    [ Data ] = Generative_model_inter_arrival( Data , [] , 0 );
end
if max(cumsum(Data.Trace(1,:)))<0.45
    tt=1;
end
end

Plot_Generated_data(Data)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 3
% Choose the time trace (Single photon arriving time or binned time trace)
% Single photon arriving time uses expoential distribution as the
% observation probability distribution, and the binned trace uses the
% poissonian as the observation probability distribution. So, the imported 
% data are different and consequently the mathematics will be different.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

minn          =     178500; %- 100000        ;             % minimum time step or photon
maxx          =     179500; % + 100000    ;              % Maximuum time step or photon

% maxx=size(Data.Trace,2);

if  minn<length(Data.Trace(1,:)) && maxx<=length(Data.Trace(1,:)) &&...
         minn>0 && maxx>0 && maxx>minn   
    if   Data.Model_type==1
         if  length(Data.Wxyz(1,:))>1
             timing =max(cumsum(Data.Trace(1,1:minn)))+cumsum(Data.Trace(1,minn:maxx));
             subplot(6,1,1)
             h1=plot(repelem(timing,1,3),repmat([0 1 0],1,length(Data.Trace(1,minn:maxx))),'LineWidth',0.01);
              h1.Color(4)=0.1;
             ylabel('Detected photon')
             ylim([0 1.1])
             xlim([max(cumsum(Data.Trace(1,1:minn))) , max(cumsum(Data.Trace(1,1:maxx)))])
             
             subplot(6,1,2)
             plot(max(cumsum(Data.Trace(1,1:minn)))+cumsum(Data.Trace(1,minn:maxx)),...
                 Data.Trace(2,minn:maxx),'.','MarkerSize',0.1)
             ylabel('Detector')
             xlabel('Time (s)')
             ylim([0.8 length(Data.Wxyz(1,:))+0.2])
             xlim([max(cumsum(Data.Trace(1,1:minn))) , max(cumsum(Data.Trace(1,1:maxx)))])
             
             edge = linspace(min(timing),max(timing),100);
             for ii=1:4
             subplot(6,1,2+ii)
             ss = histcounts(timing(Data.Trace(2,minn:maxx)==ii),edge);
             plot(edge(1:end-1),ss )
             xlim([max(cumsum(Data.Trace(1,1:minn))) , max(cumsum(Data.Trace(1,1:maxx)))])
             end
             
         else
             plot(repelem(cumsum(Data.Trace(1,minn:maxx)),1,3),repmat([0 1 0],1,length(Data.Trace(1,minn:maxx))))
             ylim([0 1.1])
             ylabel('Detected photon')
             xlabel('Time (s)')
             xlim([max(cumsum(Data.Trace(1,1:minn))) , max(cumsum(Data.Trace(1,1:maxx)))])
         end    
    else
         plot(minn:maxx,Data.Trace(1,minn:maxx))
         ylabel('Detected photons')
         xlabel(['Time step (', num2str(Data.bin),' s)'])
         xlim([minn , maxx])
    end
else
    fprintf(['Please choose more suitable values for minn and maxx! The maximum value can be = ',...
            num2str(length(Data.Trace(1,:)))])
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 4
%%%%%% Select the partition of the trace based on the previous step %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data = Partial_data(Data , minn , maxx);

% Data.Trace_partial{1} = Data.Trace;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 5
%%%%%%%%%%%%%%% Define parameters of the model %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run the Gibbs sampler function based on the number of the iteration.

Data.Num_mol               =    10   ;     % Maximum number of molecules which will be considered

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Priors  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Alpha parameter of inverse gamma distr. as prior of Diffusion coefficient
Data.D_alpha               =     1    ;
% Beta parameter of inverse gamma ditsr. as prior of Diffusion coefficient
Data.D_beta                =     10    ;


% Alpha parameter of gamma distr. as the prior of background photon emission rate
Data.mu_back_alpha         =     1    ;

% Beta parameter of gamma distr. as the prior of background photon emission rate
Data.mu_back_beta          =  10000    ;

% Parameter of background photon emission rate proposal
Data.mu_back_proposal      =  1000    ;

% Alpha parameter of gamma distr. as the prior of molecular brightness
Data.mu_alpha              =     1    ;

% Beta parameter of gamma distr. as the prior of molecular brightness
Data.mu_beta               = 100000    ;

% parameter of molecular brightness proposal
Data.mu_proposal           =  1000    ;

% Parameter of hyper prior on the loads
Data.gamma_b               =     1 ;

% Pre-calculation of parameter of load's distribution
Data.Q                     =    1/(1+((Data.Num_mol-1)/Data.gamma_b));

Data.mu_prior_xyz          = [0.01 ,0.01 ,0.01]   ;     % Mean value for X0 prior in x, y and z coordintes
Data.var_prior_xyz         = [3    ,3    ,5   ]   ;     % Variance for X0 prior in x, y and zcoordintes


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Initial vslues (sample from their prior) %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data.D                     = 1/gamrnd(Data.D_alpha ,1/Data.D_beta)   ;   % Initial Value(s) of Diffusion coefficient
if Data.D>100
    Data.D=100;
end
Data.mu                    = gamrnd(Data.mu_alpha ,Data.mu_beta,1,length(Data.Wxyz(1,:)))   ;   % Initial Values of molecular brightnesses
Data.mu_back               = gamrnd(Data.mu_back_alpha ,Data.mu_back_beta,1,length(Data.Wxyz(1,:))) ;  % Initial values of background rates
Data.b                     = rand(1,length(Data.Trace_partial)*Data.Num_mol)<Data.Q;
% Normalized distances where concentrations will be measured
Data.concen_radious        = [0.5 , 1 , 1.5 ] ;

for SS=1:length(Data.Trace_partial)

    Signal_size(SS)        = length(Data.Trace_partial{SS})     ;
    Data.x{SS}             = .05+.001*randn(3*Data.Num_mol,...
                                            Signal_size(SS),1)   ; % Initial locations of molecules
    Data.x_max{SS}         = Data.x{SS};
% Define the normalize distances to measure the concentrations (1 = effective volume of FCS)
    Data.concentration{SS} = cast(zeros(1,Signal_size(SS),...
                                  length(Data.concen_radious)),'uint8') ;  % Set the concentration to zero
end

% Number of inner loop of emission and loads, for better convergance
Data.iter_b_mu             = 10                     ;

% Automatics =1 , keep iterating untill it converges, 
% Automatics=0  , number of iterations will be defined by the user
Data.Automatic             = 0                      ;  

% Automatic convergance based on the percentage similarity of the posterior of the diffuison coefficient
Data.percentage_dif        = 0.1                    ;       

Data.x_accept_rate         = [0;0]                  ;     % Acceptance of the HMC
Data.mu_accept_rate        = [0;0]                  ;
Data.HMC_step_size         =  .01                   ;     % Initial HMC step size
Data.demo                  = false                  ;

Data.save_size             =   10                   ;     % Portion of the sample to be saved
Data.Save_on_off           =    0                   ;     % 0 = off ; 1==on

% Precalculation of the PSFs and their gradiant
[Data]                     = PSF_calculation(Data)  ;

% Pre-localize the values of MAP estimate
Data.log_post              = -10^5                  ;
Data.b_max                 = Data.b                 ;
Data.D_max                 = Data.D                 ;
Data.mu_max                = Data.mu                ;
Data.mu_back_max           = Data.mu_back           ;


% Precalculations to directly sample the loads
Data.BB_size=[];
Data.BB_loads=[];
for ll=1:min([4 , Data.Num_mol])
    Data.BB_loads{ll} = dec2bin(2^ll-1:-1:0)-'0';
    Data.BB_size(ll,:) = size(Data.BB_loads{ll});
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 6
%%%%%%%%%%%%%%%%%%%%%%%%% Run the algorithm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since this process is computationaly heavy, we strongly suggest to
% measure the running time with small nuumber of iterations first.
 
Max_iter          =      1000 ;    % Number of iteration 

tic
if  Data.Model_type==1
    [ Data ] = Gibbs_sampler_multi_focuses_inter_arrival_photons( Data , Max_iter , handles , 0 );
else
    [ Data ] = Gibbs_sampler_binned_single_focus_confocal_volume( Data , Max_iter , handles , 0 , Signal_size );
end
toc

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 7
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Show results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose a percnetage of the sampled values as the burn-in
percent_burn_in=70;

% Choose the data type ( Data_type=1 --> Simulation , Data_type=2 --> Experiment )
Data.Data_type=2;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Number of active molecules (loads) %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Active_molecules = Plot_loads( Data.b,percent_burn_in,length(Data.Trace_partial),Data.Num_mol );

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Diffusion coefficients %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Plot_D( Data , percent_burn_in , 0 , 2 )

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% molecule and background photon emission rates %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Plot_mu_mu_back( Data , percent_burn_in , 2 , 6 )

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Molecular trajectories in the case of multi-focus confocal  %%%%%%%
%%%%%%%%%  volumes or concentration of molecules in the case of  %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  single-focus confocal volume   %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if   Data.single_confocal
     Plot_concentration( Data )
else
     Plot_trajectories_multi_focuses(Data,1,Active_molecules,1)
end
%%
%%%%%%%%%%%%%%%%%%% Joint probablity distributions %%%%%%%%%%%%%%%%%%%%%%%%
Results=[];

Titles{1}='D';
Results(1,:)=Data.D(1,:);

for j=1:size(Data.Wxyz,2)
    Titles{1+j}=['\mu_{',num2str(j),',mol}'];
    Titles{size(Data.Wxyz,2)+1+j}=['\mu_{',num2str(j),',back}'];
end

Results(2:3+(size(Data.Wxyz,2)-1)*2,:)=[Data.mu';Data.mu_back'];
Results=Results';

numParams=size(Results,2);

for i=1:numParams
    for j=i:numParams
        subplot(numParams,numParams,numParams*(i-1)+i+(j-i));
        if i~=j
            scatter(Results(:,i),Results(:,j),'SizeData',1,'Marker','.');
            title([Titles{i},' , ',Titles{j}])
            ylabel(Titles{j})
            xlabel(Titles{i})
            zlabel('Join Posterior')
            hold on
        end
        if i==j
           histogram(Results(:,j),'Normalization','pdf')
           ylabel('Post. prob. distr.')
           xlabel(Titles{i})
           box off
           hold on 
        end
    end
end
