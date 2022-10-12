%% ploter
function Gim = HMC_plot(Gim,J,N,q_mid,p_mid)

 
if isempty(Gim)
    figure(20)

    subplot(1,3,[1 2])
    Gim.ax_jq = plot(1:J,q_mid','.-');
    xlim([0 J+1])
    xlabel('Step j')
    ylabel('Position q')
    box off
    grid on
    title('HMC trajectory')

    
    subplot(1,3,3)
    Gim.ax_pq = plot(p_mid',q_mid','.-');
    xlabel('Momentum p')
    ylabel('Position q')
    set(gca,'YAxisLocation','Right')
    box off
    grid on
    title('HMC phase-space')

else
    for n=1:N
        Gim.ax_jq(n).YData = q_mid(n,:);
        Gim.ax_pq(n).XData = p_mid(n,:);
        Gim.ax_pq(n).YData = q_mid(n,:);
    end
end

 
drawnow

 
end