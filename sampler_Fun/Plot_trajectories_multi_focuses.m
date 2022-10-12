function[]=Plot_trajectories_multi_focuses(Data,k,Active_molecules,limm)





figure('Units','inch','Position',[0 0 5 5])


set(gcf,'color','w')
clf
movegui(gcf,'center')



begin_of=max([1,floor(0.5*size(Data.x{k},3))]);

Max_active=find(Data.b_max(1,(k-1)*Data.Num_mol+1:k*Data.Num_mol)==1);



ell    = char(hex2dec(strsplit('2113')));
learned=[];
learned_25=[];
learned_75=[];

% numpa=1:length(Data.b(1,:));

numpa=Active_molecules;

for numpar=numpa
learned(3*numpar-2,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
    size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);
learned(3*numpar-1,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
    size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);
learned(3*numpar  ,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
    size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.5);

learned_25(3*numpar-2,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
    size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);
learned_25(3*numpar-1,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
    size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);
learned_25(3*numpar  ,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
    size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.025);

learned_75(3*numpar-2,:)=quantile(reshape(Data.x{k}(3*numpar-2,:,begin_of:end),...
    size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
learned_75(3*numpar-1,:)=quantile(reshape(Data.x{k}(3*numpar-1,:,begin_of:end),...
    size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
learned_75(3*numpar  ,:)=quantile(reshape(Data.x{k}(3*numpar  ,:,begin_of:end),...
    size(Data.x{k}(1,:,begin_of:end),2),size(Data.x{k}(1,:,begin_of:end),3))',0.975);
end


timing=cumsum(Data.Trace_partial{k}(1,:));

x2 = [timing, fliplr(timing)];
subplot(4,1,1)

if isfield(Data,'mu_real')==1
for m=1:length(Data.X_partial{k}(:,1))
    plot(timing,Data.X_partial{k}(m,:),'g')
    hold on
end
end

hj1=patch([0  max(timing) max(timing) 0 0],[-0.3 -0.3 0.3 0.3 -0.3],'red');
hold on
hj1.FaceColor=[0.1 0.1 0.1];
hj1.FaceAlpha=0.1;
hj1.EdgeColor='none';

for numpar=numpa
    plot(timing,learned(3*numpar-2,:),'b','LineWidth',1)
    inBetween = [learned_25(3*numpar-2,:), fliplr(learned_75(3*numpar-2,:))];
    fill(x2, inBetween, 'c','facealpha', 0.2,'edgecolor', 'none')
end
% for numpp=1:length(Max_active)
%     plot(timing,Data.x_max{k}(3*numpp-2,:),'m')
% end

xlim([0 max(timing)])
ylabel('X (μm)')
% ylim([2*min(Data.Cxyz(1,:)), 2*max(Data.Cxyz(1,:))])
ylim([-limm limm])

box on
set(gca,'XTick',[])

subplot(4,1,2)
if isfield(Data,'mu_real')==1
for m=1:length(Data.Y_partial{k}(:,1))
    plot(timing,Data.Y_partial{k}(m,:),'g')
    hold on
end
end

hj1=patch([0  max(timing) max(timing) 0 0],[-0.3 -0.3 0.3 0.3 -0.3],'red');
hold on
hj1.FaceColor=[0.1 0.1 0.1];
hj1.FaceAlpha=0.1;
hj1.EdgeColor='none';

for numpar=numpa
    plot(timing,learned(3*numpar-1,:),'b','LineWidth',1)
    inBetween = [learned_25(3*numpar-1,:), fliplr(learned_75(3*numpar-1,:))];
fill(x2, inBetween, 'c','facealpha', 0.2,'edgecolor', 'none')
end 

% for numpp=1:length(Max_active)
%     plot(timing,Data.x_max{k}(3*numpp-1,:),'m')
% end
xlim([0 max(timing)])
ylabel('Y (μm)')
% ylim([2*min(Data.Cxyz(2,:)), 2*max(Data.Cxyz(2,:))])
ylim([-limm limm])

box on
set(gca,'XTick',[])

subplot(4,1,3)
if isfield(Data,'mu_real')==1
for m=1:length(Data.Z_partial{k}(:,1))
    plot(timing,Data.Z_partial{k}(m,:),'g')
    hold on
end
end

hj1=patch([0  max(timing) max(timing) 0 0],[-1.1 -1.1 1.1 1.1 -1.1],'red');
hold on
hj1.FaceColor=[0.1 0.1 0.1];
hj1.FaceAlpha=0.1;
hj1.EdgeColor='none';

for numpar=numpa
plot(timing,learned(3*numpar,:),'b','LineWidth',1)
    inBetween = [learned_25(3*numpar,:), fliplr(learned_75(3*numpar,:))];
fill(x2, inBetween, 'c','facealpha', 0.2,'edgecolor', 'none')
end
% for numpp=1:length(Max_active)
%     plot(timing,Data.x_max{k}(3*numpp,:),'m')
% end
xlim([0 max(timing)])
ylabel('Z (μm)')
ylim([-2*limm 2*limm])
% ylim([2*min(Data.Cxyz(3,:)), 2*max(Data.Cxyz(3,:))])
box on
set(gca,'XTick',[])

subplot(4,1,4)
p1=plot( repelem(timing,1,3),repmat([0 1 0],1,length(timing)),'color','b','LineWidth',.5);
p1.Color(4) = 0.05;

xlim([0 max(timing)])
ylabel({'Detected','photons'})
xlabel('Time (s)')
