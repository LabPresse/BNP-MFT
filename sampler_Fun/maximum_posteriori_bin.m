function[Data] = maximum_posteriori_bin( ...
    ...
Data  , Trace_size      , Num_part  , AAA    , i         )

B=0;
constant=0;
Traces_size=length(Trace_size);
kk_diffusion=0;
Initial_pos=0;

for k = 1:Traces_size
   
    B = B+sum(Data.b(end,(k-1)*Num_part+1:k*Num_part));

    kk_diffusion = kk_diffusion - ...
                   1.5*Num_part*sum(log(4*pi*Data.bin*Data.D(end)))- ...
                   sum( (ones(1,3*Num_part)*(diff(Data.x{k},1,2).^2))./...
                        (4*Data.D(end)*Data.bin)  );

    GG_1 = zeros(Trace_size(k),1);

    for n=1:Num_part
        GG_1 = GG_1 + Data.b(end,(k-1)*Num_part+n).* ...
                Data.gg( Data.x{k}(AAA(1,n),1:Trace_size(k))',...
                         Data.x{k}(AAA(2,n),1:Trace_size(k))',...
                         Data.x{k}(AAA(3,n),1:Trace_size(k))');
                     
        Initial_pos=Initial_pos-0.5*log(2*pi*Data.var_prior_xyz(1))-...
                                ((Data.x{k}(AAA(1,n),1)-...
                                  Data.mu_prior_xyz(1))^2)/...
                                  (2*Data.var_prior_xyz(1));
                              
        Initial_pos=Initial_pos-0.5*log(2*pi*Data.var_prior_xyz(2))-...
                                ((Data.x{k}(AAA(2,n),1)-...
                                  Data.mu_prior_xyz(2))^2)/...
                                  (2*Data.var_prior_xyz(2));
                              
        Initial_pos=Initial_pos-0.5*log(2*pi*Data.var_prior_xyz(3))-...
                                ((Data.x{k}(AAA(3,n),1)-...
                                  Data.mu_prior_xyz(3))^2)/...
                                  (2*Data.var_prior_xyz(3));
    end
    
    GG_1p=(Data.mu_back(end)+ (Data.mu(end).*GG_1));

     constant = constant+Data.Trace_partial{k}(1,:)*log(GG_1p) - ...
             sum(GG_1p +gammaln(Data.Trace_partial{k}(1,:)'+1));
end



BBB=B*log(Data.Q)+(Num_part*length(Trace_size)-B)*log(1-Data.Q+eps);

DD=(Data.D_alpha).*log(Data.D_beta)-gammaln(Data.D_alpha)-...
    (Data.D_alpha+1)*log(Data.D(end))- (Data.D_beta/Data.D(end));

log_mu=-Traces_size*(Data.mu_alpha*log(Data.mu_beta)+gammaln(Data.mu_alpha))+...
    sum((Data.mu_alpha-1).*log(Data.mu(end,:)) -  Data.mu(end,:)./Data.mu_beta);

log_mu_back=-Traces_size*(Data.mu_back_alpha*log(Data.mu_back_beta)+gammaln(Data.mu_back_alpha))+...
    sum((Data.mu_back_alpha-1).*log(Data.mu_back(end,:)) -  Data.mu_back(end,:)./Data.mu_back_beta);

Data.log_post(i) = constant+BBB+DD + kk_diffusion + log_mu + log_mu_back + Initial_pos;

if Data.log_post(i)>max(Data.log_post(1:i-1))
    for k=1:Traces_size
        Data.b_max(1,(k-1)*Num_part+1:k*Num_part)=Data.b(i,(k-1)*Num_part+1:k*Num_part);
    end
    Data.D_max=Data.D(i);
    Data.mu_max=Data.mu(i,:);
    Data.mu_back_max=Data.mu_back(i,:);
end

end