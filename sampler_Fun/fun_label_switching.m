%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  Track the molecules  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Due to the exchangability of molecules, the label of molecules will
% change and to be able to track each molecule individualy we need to find
% their laber at any iteration. We did this by applying the Hungarian
% algorithm through the calculation of the cost matrix

% Written by Sina Jazani 
% 07-06-2019    Matlab R2019a

function[ x , S , B ]=fun_label_switching(...
    ...
 x_new   , S_new   , b_new     , AAA       , ...
 x_old   , S_old   , b_old     , PSF_Func  , ...
 Num_par )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % x_new                    :  Sampled location trajecotires of molecules at iteration i
     % S_new                    :  Sampled the photo-state trajectories at iteration i
     % b_new                    :  Sampled the loads at iteration i
     % AAA                      :  Precalculation to the likelihood
     % x_old                    :  Sampled location trajecotires of molecules at iteration i-1
     % S_old                    :  Sampled the photo-state trajectories at iteration i-1
     % b_old                    :  Sampled the loads at iteration i-1
     % PSF_func                 :  Point Spread Function type ( 'Gaussian' or 'Lorentzian Gaussian')
     % Num_par                  :  Number of defined molecules
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % x                        :  Updated location trajecotires of molecules at iteration i
     % S                        :  Updated photo-state trajectories at iteration i
     % B                        :  Updated loads at iteration i

% Consider the contribution of bright photo-state into the likelihood
unity=[1,0,0];

switch  PSF_Func
            case 1 % 3D Gaussian
                  Constant_new =b_new'.*(unity(S_new).*exp(-2*((x_new(AAA(1,:),:).^2)+...
                                                               (x_new(AAA(2,:),:).^2)+...
                                                               (x_new(AAA(3,:),:).^2))));
                  Constant_old =b_old'.*(unity(S_old).*exp(-2*((x_old(AAA(1,:),:).^2)+...
                                                               (x_old(AAA(2,:),:).^2)+...
                                                               (x_old(AAA(3,:),:).^2))));
            case 2 % 2D Gaussian-Lorentzian
                  Constant_new = b_new'.*(unity(S_new).*...
                                (exp(-2*((x_new(AAA(1,:),:).^2)+(x_new(AAA(2,:),:).^2))./...
                                                             (1+(x_new(AAA(3,:),:).^2)))./...
                                                             (1+(x_new(AAA(3,:),:).^2))));
                  Constant_old = b_old'.*(unity(S_old).*...
                                (exp(-2*((x_old(AAA(1,:),:).^2)+(x_old(AAA(2,:),:).^2))./...
                                                             (1+(x_old(AAA(3,:),:).^2)))./...
                                                             (1+(x_old(AAA(3,:),:).^2))));
       otherwise   % 2D Gaussian-Cylindrical
                  Constant_new = b_new'.*(unity(S_new).*exp(-2*((x_new(AAA(1,:),:).^2)+...
                                                                (x_new(AAA(2,:),:).^2))));
                  
                  Constant_old = b_old'.*(unity(S_old).*exp(-2*((x_old(AAA(1,:),:).^2)+...
                                                                (x_old(AAA(2,:),:).^2))));                              
end


% Creat the cost matrix
for n=1:Num_par
    for m=1:Num_par
        cost_matrix(n,m) = sum(abs(Constant_old(n,:)-Constant_new(m,:))) ;
    end
end
               
% Applying the Hungarian algorithm
[assignment,~] = munkres(cost_matrix);

% Reorder the loads and the trajectories
x(AAA(1,:),:)= x_new(AAA(1,assignment),:);
x(AAA(2,:),:)= x_new(AAA(2,assignment),:);
x(AAA(3,:),:)= x_new(AAA(3,assignment),:);
S = S_new(assignment,:);
B = b_new(assignment);
   
end