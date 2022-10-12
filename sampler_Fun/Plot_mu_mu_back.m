function[]=Plot_mu_mu_back(Data , percent_burn_in,lower_bound,upper_bound)

burn_in=floor(length(Data.mu)*percent_burn_in/100);

Numbner_confocals= length(Data.mu(1,:));

subplot(2,2,1)
for k=1:Numbner_confocals
    plot(Data.mu_back(:,k),'b')
    hold on
    plot(Data.mu_back(1:burn_in,k),'r')
    if  Data.Data_type==1
        line([0 ,length(Data.mu(:,k))],[Data.mu_back_real(k), Data.mu_back_real(k)],...
                'LineStyle','--','Color','g','LineWidth',2)
    end
end
xlabel('Iteration')
ylabel('Bakcground photon emision rates (photons/s)')
set(gca,'YScale','log')

subplot(2,2,2)
dbnd = logspace(lower_bound , upper_bound , 100);
for k=1:Numbner_confocals
    hh1=histogram(Data.mu_back(burn_in:end,k),dbnd,'Normalization','pdf','facecolor','r');
    if  Data.Data_type==1
        line([Data.mu_back_real(k), Data.mu_back_real(k)],...
             [0 ,1.1*max(hh1.Values)],'LineStyle','--','Color','g','LineWidth',2)
    end
    hold on
end
set(gca,'XScale','log')
xlabel('Bakcground photon emision rates (photons/s)')
ylabel('Post. prob. distr.')

subplot(2,2,3)
for k=1:Numbner_confocals
    plot(Data.mu(:,k),'b')
    hold on
    plot(Data.mu(1:burn_in,k),'r')
    if  Data.Data_type==1
        line([0 ,length(Data.mu(:,k))],[Data.mu_real(k), Data.mu_real(k)],'LineStyle','--','Color','g','LineWidth',2)
    end
end
hold off
xlabel('Iteration')
ylabel('Molecular brightness (photons/s)')
set(gca,'YScale','log')

subplot(2,2,4)
dbnd = logspace(lower_bound , upper_bound , 100);
for k=1:Numbner_confocals
    hh2=histogram(Data.mu(burn_in:end,k),dbnd,'Normalization','pdf','facecolor','b');
    hold on
    if  Data.Data_type==1
        line([Data.mu_real(k), Data.mu_real(k)],...
               [0 ,1.1*max(hh2.Values)],'LineStyle','--','Color','g','LineWidth',2)
    end
end
set(gca,'XScale','log')
xlabel('Molecule photon emission rates (photons/s)')
ylabel('Post. prob. distr.')