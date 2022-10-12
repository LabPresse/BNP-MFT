%% HMC posterior sampler for sample 1D trajectory based the binned time traces (2D-Lorentzian-Z coordinate), and is modified for implicit diffusion
function [q_new,rec] = HMC_binned_time_trace_Lorent_z( ...
    ...
q_old    , N      , phi   , V0    , ...
Y        , w      , mu    , I_b   , ...
Z        , I_mol  , rec   , demo  , ...
h        , J      )



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%   Propose the trajectory based on HMC    %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Precalculations of the implicit solver
g0 = 2/h;
d2 = 0.5*h*[ phi(1,AA(nn,1))+V0  ; ...
             2*phi(1:end-2,1)    ; ...
             phi(end,1)         ];
F1 = g0 + d2;
F2 = g0 - d2;
psi= -0.5*phi(1,1)*h;




% pre-allocation
q_mid = nan(N,J);
p_mid = nan(N,J);


% Initialzing
j     = 1;


% Sample the momenta from a standard normal distribution
p_mid(:,j) = randn(N,1);  % [mass]*[q]/[time] , mass=1 otherwise sqrt(m).*randn(N,1)

% Set the initial trajecotry to the old sampled trajectory
q_mid(:,j) = q_old;


% Visualization of the HMC
if demo; Gim = HMC_plot([],J,N, q_mid, p_mid); end

% Calculate the HMC potential gradient (likelihood only)
Vq = get_V_BS_grad_Lorent_z( q_mid(:,j),Y,Z,w, I_b ,I_mol );

% Start the for loop of HMC
for j = 2:J
    
    % half-step (apply only Vq)
    p_mid(:,j) = p_mid(:,j-1) - 0.5*h*Vq;

    % whole-step (apply M and Lq)
    y = 2*p_mid(:,j) + F2.*q_mid(:,j-1) -[0 ;psi.*q_mid(1:N-1,j-1)] -[psi.*q_mid(2:N,j-1);0];
    y(1) = y(1)+(h*mu*V0);
    q_mid(:,j) = tri_solver_binned(N,F1,psi,y);
    p_mid(:,j) = g0.*(q_mid(:,j)-q_mid(:,j-1)) - p_mid(:,j);
    Vq = get_V_BS_grad_Lorent_z( q_mid(:,j),Y,Z,w, I_b ,I_mol );

    % half-step (apply only Vq)
    p_mid(:,j) = p_mid(:,j) - 0.5*h*Vq;

    % Visualization of the HMC
    if demo; HMC_plot(Gim,[],N, q_mid, p_mid); end
end
% End the for loop of HMC



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%     Metropolis-Hastings    %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the acceptance ratio
log_a = get_V_BS_Lorent_z(q_mid(:,1)   , Y , Z , w ,  I_b ,I_mol ) - ...
        get_V_BS_Lorent_z(q_mid(:,end) , Y , Z , w , I_b ,I_mol ) ...
      + 0.5*V0*( (q_mid(1,1)-mu)^2 - (q_mid(1,end)-mu)^2 ) ...
      + 0.5*sum( (diff(q_mid(:,1)).^2 - diff(q_mid(:,end)).^2).*phi(1) ) ...
      + 0.5*sum( (p_mid(:,1).^2-p_mid(:,end).^2) );


% Accept or reject 
if  log(rand) < log_a        % accept
    q_new   = q_mid(:,end)' ;
    rec     = rec + 1       ;
else                         % reject
    q_new   = q_old'        ;
    rec(2)  = rec(2) + 1    ;
end

end


%% HMC potential gradient (likelihood only) of the binned time traces (2D Gaussian-Lorentzian in Z coordinate)
function Vq = get_V_BS_grad_Lorent_z(q , Y , Z , w , I_b , I_mol)

         mm       = I_mol.*exp(-2*((Y.^2)+(Z.^2))./(1+((q').^2)))./(1+((q').^2))     ;
         mu       = I_b+mm                                                           ;
         mu_prim  = 2*q'.*mm.*((2*((Y.^2)+(Z.^2))./(1+((q').^2)))-1)./(1+((q').^2))  ;
         
         Vq(:,1)  = (mu_prim.*(1-(w./mu)))'                                          ;
        
end


%% HMC potential (likelihood only) of the binned time traces (2D Gaussian-Lorentzian in Z coordinate)
function V = get_V_BS_Lorent_z(q,Y,Z,w,I_b,I_mol)


         mu    = I_b+I_mol.*exp(-2*((Y.^2)+(Z.^2))./(1+((q').^2)))./(1+((q').^2)) ;
 
         V     = sum(mu-(w.*log(mu)))                                             ;

end