function[]=plot_4_focuse_confocal(xc,yc,zc,wx,wy,wz,x,Signal,x_learned)

figure('Units','inch','Position',[0 0 12 8])

set(gcf,'color','w')
clf
movegui(gcf,'center')




 
for n=1:1
subplot(4,8,(2*n-1)*4+[1,2,3,4])
stairs(Signal(n,:),'b')
ylim([0 max(max(Signal))+1])
xlim([0 length(Signal(1,:))])
if n==4
xlabel('Time steps (100\mus)')
end
ylabel('Intensity')
box off
text( -0.1 ,1.3  , ['b',num2str(n)] ,'Units','normalized','fontsize',13,'fontweight','bold','horizontalalignment','center')
end



hh=subplot(4,8,[1 ,2 ,3 ,4 ,...
                9 ,10,11,12,...
                17,18,19,20,...
                25,26,27,28]);
hh.Position=hh.Position.*[1.1 1 .75 1];
Axis_size=3;


xr  = [wx(1)  ];
yr  = [wy(1) ];
zr  = [wz(1)  ];

[x1, y1, z1] = ellipsoid(xc(1),yc(1),zc(1),xr(1),yr(1),zr(1),400);


h1=surf(x1, y1, z1);
hold on


set(h1,'Edgecolor','none','Facelighting','flat' ,'Facecolor','m','AmbientStrength',0.5)
light('Position',[-2 0 -.1],'Style','local')





[x11, y11, z11] = ellipsoid(xc(1),yc(1),zc(1),xr(1),yr(1),zr(1),40);
% Plot the projection of everything in xy plane
surf(x11,y11,-Axis_size*ones(size(x11)),'Edgecolor','none' ,'Facecolor','m'...
      ,'FaceAlpha',0.5)
plot3(x(1,:),x(2,:),-Axis_size*ones(size(x(1,:))),'Markersize',1,'color','b')
hold on
plot3(x_learned(1,:),x_learned(2,:),-Axis_size*ones(size(x_learned(1,:))),'Markersize',1,'color','r')
  



% Plot the projection of everything in xz plane
surf(x11,Axis_size*ones(size(x11)),z11,'Edgecolor','none' ,'Facecolor','m'...
      ,'FaceAlpha',0.5)
plot3(x(1,:),Axis_size*ones(size(x(1,:))),x(3,:),'Markersize',1,'color','b')
hold on
plot3(x_learned(1,:),Axis_size*ones(size(x_learned(1,:))),x_learned(3,:),'Markersize',1,'color','r')

% Plot the projection of everything in yz plane
surf(Axis_size*ones(size(x11)),y11,z11,'Edgecolor','none' ,'Facecolor','m'...
      ,'FaceAlpha',0.5)
  
plot3(Axis_size*ones(size(x(1,:))),x(2,:),x(3,:),'Markersize',1,'color','b')
hold on
plot3(Axis_size*ones(size(x_learned(1,:))),x_learned(2,:),x_learned(3,:),'Markersize',1,'color','r')

% plot3(x(1,:),x(2,:),x(3,:),'Markersize',1,'color','b')


xlabel('X (\mum)')
ylabel('Y (\mum)')
zlabel('Z (\mum)')
box off
text( -0.33 ,0.9  , 'a' ,'Units','normalized','fontsize',15,'fontweight','bold','horizontalalignment','center')
axis(Axis_size*[-1 1 -1 1 -1 1])