function plot_surf_intersection(obj,X,Y,Z,intSurface)

v=obj.vertices;
DM=[v(:,1),v(:,2) ones(size(v(:,3)))];
B=DM\v(:,3);
[vx vy]=meshgrid(linspace(min(min(X-1)),max(max(X+1)),50),linspace(min(min(Y-1)),max(max(Y+1)),50));
vz=B(1)*vx+B(2)*vy+B(3)*ones(size(vx));
figure;
p=plot3(v(:,1),v(:,2),v(:,3),'.');hold on;
surf(X,Y,Z)
hold on;
c=meshc(vx,vy,vz)
colormap gray;
shading interp;
alpha(0.5)
ylim([min(min(Y)) max(max(Y))])
xlim([min(min(X)) max(max(X))])
zlim([min(min(Z)) max(max(Z))])

cx=mean(X,2);
cy=mean(Y,2);
h=Z(:,1);
plot3(cx,cy,h,'.','Color','r','LineWidth',2,'MarkerSize',15);
scatter3(intSurface.vertices(:,1),intSurface.vertices(:,2),intSurface.vertices(:,3),'filled','MarkerFaceColor','blue')
end