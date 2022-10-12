function[]=Plot_Generated_data(Data)

for nn=1:Data.Num_mol_real
    plot3(Data.X(nn,:),Data.Y(nn,:),Data.Z(nn,:))
    hold on
end
hold off

xlim([-0.3 , 0.3])
ylim([-0.3 , 0.3])
zlim([-1.5 , 1.5])
%
if  Data.Model_type==2
    
    timing = Data.bin*(1:Data.Length_signal);
    subplot(4,1,1)
    plot(timing,Data.X)
    % ylim([-0.15 , 0.15])

    subplot(4,1,2)
    plot(timing,Data.Y)
    % ylim([-0.15 , 0.15])

    subplot(4,1,3)
    plot(timing,Data.Z)
    % ylim(2*[-0.3 , 0.3])

    subplot(4,1,4)
    p1=plot( timing,Data.Trace,'LineWidth',.5);

else
    timing=cumsum(Data.Trace(1,:));

    subplot(4,1,1)
    plot(timing,Data.X)
    % ylim([-0.15 , 0.15])

    subplot(4,1,2)
    plot(timing,Data.Y)
    % ylim([-0.15 , 0.15])

    subplot(4,1,3)
    plot(timing,Data.Z)
    % ylim(2*[-0.3 , 0.3])

    subplot(4,1,4)
    p1=plot( repelem(timing,1,3),repmat([0 1 0],1,length(timing)),'color','b','LineWidth',.5);
    p1.Color(4) = 0.05;
end