function[Active_molecules]=Plot_loads(b,percent_burn_in,length_Trace,Number_molecules)

burn_in=floor(size(b,1)*percent_burn_in/100);


for k=1:length_Trace
    
    
    subplot(length_Trace,3,3*k-1)
    plot(sum(b(:,(k-1)*Number_molecules+1:k*Number_molecules),2),'b')
    hold on
    plot(sum(b(1:burn_in,(k-1)*Number_molecules+1:k*Number_molecules),2),'r')
    hold off
    xlabel('Iteration')
    ylabel('Number of active molecules')
    ylim([0 Number_molecules+0.9])
    
    subplot(length_Trace,3,3*k)
    histogram(sum(b(burn_in:end,(k-1)*Number_molecules+1:k*Number_molecules),2),'Normalization','pdf','Orientation','Horizontal')
    xlabel('Post. prob. distr.')
    ylabel('Number of active molecules')
    ylim([0 Number_molecules+0.9])


    subplot(length_Trace,3,3*k-2)
    HJ=histcounts(sum(b(burn_in:end,(k-1)*Number_molecules+1:k*Number_molecules),2),1:1:Number_molecules+1);
    max_num_active(k)=min(find(HJ==max(HJ)));
    for hh=1:Number_molecules
        plot(hh.*b(:,(k-1)*Number_molecules+hh)','.','MarkerSize',1,'Color','b')
        hold on
        plot(hh.*b(1:burn_in,(k-1)*Number_molecules+hh)','.','MarkerSize',1,'Color','r')
        ylim([0.1 Number_molecules+1])
        molecules(k,hh)=sum(b(burn_in:end,(k-1)*Number_molecules+hh));
    end
    
    
    [~,AB]=sort(molecules(k,:),'descend');
    Active_molecules=AB(1:max_num_active(k));
    
    xlabel('Iteration')
    ylabel('Loads')
    
    xlim([1 size(b,1)])
    ylim([0.1 Number_molecules+0.9])

end






end