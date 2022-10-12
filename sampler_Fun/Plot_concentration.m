function[]=Plot_concentration( Data )

ell    = char(hex2dec(strsplit('2113')));


for SS=1:length(Data.Trace_partial)
    Signal_size(SS)  = length(Data.Trace_partial{SS})     ;
end

% Pre-calculations
radi_size          = length(Data.concen_radious);

for k=1:length(Signal_size)

    concentration_real = zeros( radi_size,Data.maxx{k}-Data.minn{k}+1);



% calculate the real concentrations
for num_mol = 1:Data.Number_molecules_real
   
        for num_radi = 1:radi_size
            switch Data.PSF_func
                case 1
            concentration_real(num_radi,:) = ...
            concentration_real(num_radi,:)+...
            ( sqrt(((Data.X(num_mol,Data.minn{k}:Data.maxx{k})./Data.Wxyz(1)).^2)+...
                   ((Data.Y(num_mol,Data.minn{k}:Data.maxx{k})./Data.Wxyz(2)).^2)+...
                   ((Data.Z(num_mol,Data.minn{k}:Data.maxx{k})./Data.Wxyz(3)).^2) )<=Data.concen_radious(num_radi) );
                case 2
             concentration_real(num_radi,:) = ...
            concentration_real(num_radi,:)+...
            ( sqrt( 0.5*log(1+((Data.Z(num_mol,Data.minn{k}:Data.maxx{k})./Data.Wxyz(3) ).^2))+...
                              (((Data.X(num_mol,Data.minn{k}:Data.maxx{k})./Data.Wxyz(1)).^2)+...
                               ((Data.Y(num_mol,Data.minn{k}:Data.maxx{k})./Data.Wxyz(2)).^2))./...
                            (1+((Data.Z(num_mol,Data.minn{k}:Data.maxx{k})./Data.Wxyz(3) ).^2))...
                                 )<=Data.concen_radious(num_radi) );
                otherwise
                   concentration_real(num_radi,:) = ...
                   concentration_real(num_radi,:)+...
                  ( sqrt(((Data.X(num_mol,Data.minn{k}:Data.maxx{k})./Data.Wxyz(1)).^2)+...
                         ((Data.Y(num_mol,Data.minn{k}:Data.maxx{k})./Data.Wxyz(2)).^2) )<=Data.concen_radious(num_radi) );
            end
                             
        end
 
end

% Cacluate the learned concentrations
mean25=[];
mean50=[];
mean95=[];

for l = 1 : radi_size
    mean25(l,:)=quantile(reshape(Data.concentration{k}(:,:,l),size(Data.concentration{k},1),Signal_size(k)),0.025)      ;
    mean50(l,:)=quantile(reshape(Data.concentration{k}(:,:,l),size(Data.concentration{k},1),Signal_size(k)),0.5)        ;
    mean95(l,:)=quantile(reshape(Data.concentration{k}(:,:,l),size(Data.concentration{k},1),Signal_size(k)),0.975)      ;
end




mean25_stairs=[];
mean50_stairs=[];
mean95_stairs=[];
for i=1:Signal_size(k)
    mean25_stairs(:,2*i-1)=mean25(:,i);
    mean50_stairs(:,2*i-1)=mean50(:,i);
    mean95_stairs(:,2*i-1)=mean95(:,i);
    
    if  i<Signal_size(k)-1
        mean25_stairs(:,2*i)=mean25(:,i+1);
        mean50_stairs(:,2*i)=mean50(:,i+1);
        mean95_stairs(:,2*i)=mean95(:,i+1);
    else
        mean25_stairs(:,2*i)=mean25(:,i);
        mean50_stairs(:,2*i)=mean50(:,i);
        mean95_stairs(:,2*i)=mean95(:,i);
    end
end


for l = 1 : length(Data.concen_radious)
    
    subplot(length(Data.concen_radious)+1,length(Signal_size),(k-1)*length(Data.concen_radious)+l)
    
    
    if  Data.Model_type    ==    2
        if  Data.Data_type==1
            h3=stairs(Data.minn{k}:Data.maxx{k},concentration_real(l,:),'g','LineWidth',1.4);
        end
        hold on
        h2=stairs(Data.minn{k}:Data.maxx{k},mean50(l,:),'--','color','b','LineWidth',1.4);
        x2 = [repelem(Data.minn{k}:Data.maxx{k},1,2), fliplr(repelem(Data.minn{k}:Data.maxx{k},1,2))];
        xlabel(['Time step (',num2str(Data.bin),'s)'])
        xlim([Data.minn{k}  Data.maxx{k}])
    else
        if  Data.Data_type==1
            h3=stairs(max(cumsum(Data.Trace(1,1:Data.minn{k})))+cumsum(Data.Trace_partial{k}(1,:)),concentration_real(l,:),'g','LineWidth',1.4);
        end
        hold on
        h2=stairs(max(cumsum(Data.Trace(1,1:Data.minn{k})))+cumsum(Data.Trace_partial{k}(1,:)),mean50(l,:),'--','color','b','LineWidth',1.4);
        x2 = [repelem(cumsum(Data.Trace_partial{k}(1,:)),1,2), fliplr(repelem(cumsum(Data.Trace_partial{k}(1,:)),1,2))];
        xlabel('Photons arrival times (s)')
        xlim([max(cumsum(Data.Trace(1,1:Data.minn{k})))  max(cumsum(Data.Trace(1,1:Data.minn{k})))+max(cumsum(Data.Trace_partial{k}(1,:)))])
    end


    inBetween = [mean25_stairs(l,:), fliplr(mean95_stairs(l,:))];
    h1=fill(x2, inBetween, 'c','facealpha', 0.2,'edgecolor', 'none');


    ylabel([{['Number of']} ;{['molecules N_k^{',ell,'}']};{[ell,'=',num2str(Data.concen_radious(l))]}],'Fontsize',11)
  
    if  Data.Data_type==1
        ylim([0 unique(max([mean95_stairs(l,:),concentration_real(l,:)]))+0.5])
    else
        ylim([0 unique(max(mean95_stairs(l,:)))+0.5])
    end
    
    box off
    if l==1
       ylim([0 unique(max([mean95_stairs(l,:),concentration_real(l,:)]))*1.7+0.0001])
       if   Data.Data_type==1
           [BL,BLicons]=legend([h3,h2,h1],'Exact concentration','Median of posterior','95% conf. interval','location','North','Orientation','Horizontal');
       else
           [BL,BLicons]=legend([h2,h1],'Median of posterior','95% conf. interval','location','North','Orientation','Horizontal');
       end
       PatchInLegend = findobj(BLicons(end), 'type', 'patch');
       set(PatchInLegend, 'facea', 0.2)
       set(BL,'box','off')
    end
end

if  Data.Model_type    ==    2
    subplot(length(Data.concen_radious)+1,length(Signal_size),length(Data.concen_radious)*length(Signal_size)+k)
    plot(Data.minn{k}:Data.maxx{k},Data.Trace_partial{k})

    xlabel(['Time step (',num2str(Data.bin),'\mus)'])
    xlim([Data.minn{k}  Data.maxx{k}])
    ylabel('Observed photons')
else
    subplot(length(Data.concen_radious)+1,length(Signal_size),length(Data.concen_radious)*length(Signal_size)+k)
    plot(repelem(max(cumsum(Data.Trace(1,1:Data.minn{k})))+cumsum(Data.Trace_partial{k}(1,:)),1,3),...
        repmat([0 1 0],1,length(Data.Trace_partial{k}(1,:))),'linewidth',1.3)
    ylim([0 1.1])
    xlabel('Photons arrival times (s)')
    ylabel('Detected photons')
    xlim([max(cumsum(Data.Trace(1,1:Data.minn{k})))  max(cumsum(Data.Trace(1,1:Data.minn{k})))+max(cumsum(Data.Trace_partial{k}(1,:)))])
end

end

end