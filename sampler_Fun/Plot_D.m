function[]=Plot_D(Data , percent_burn_in ,min_log , max_log)

burn_in=floor(length(Data.D)*percent_burn_in/100);

subplot(2,1,1)
plot(Data.D,'b')
hold on
plot(Data.D(1:burn_in),'r')
if  Data.Data_type==1
    line([0 length(Data.D)],[Data.D_real Data.D_real], 'LineStyle','--','Color','g','LineWidth',2)
end
ylim(10.^[min_log , max_log])
set(gca,'YScale','log')
xlabel('Iteration')
ylabel('Diffusion Coef.')


subplot(2,1,2)
dbnd = logspace(min_log , max_log , 200);
hh=histogram(Data.D(burn_in:end),dbnd,'Normalization','pdf');
if  Data.Data_type==1
    line([Data.D_real Data.D_real],[0 max(hh.Values)*1.1], 'LineStyle','--','Color','g','LineWidth',2)
end
set(gca,'XScale','log')
xlabel('Diffusion coefficient (μm^2/s)')
ylabel('Post. prob. distr.')
hold on
plot(dbnd,exp( -gammaln(Data.D_alpha)+Data.D_alpha*log(Data.D_beta)-(Data.D_alpha+1)*log(dbnd)-(Data.D_beta./dbnd) ) )

end