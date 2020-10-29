function writeresultPlot(im,M1,M2p,xC1,xC2,yC,X,Y,Z,ttl)
fig=figure('Visible','off');
set(0,'defaultAxesFontSize',18)
colormap copper;
subplot(2,2,1);
%image(im(101:701,:,:)); axis equal; axis xy;
image(im); axis equal; axis xy;
subplot(2,2,3);
imagesc(M1+M2p); axis equal; axis xy; hold on;
plot(xC1,yC,'r.-',xC2,yC,'r.'); hold off;
subplot(1,2,2);
colormap gray;
surf(X,Y,Z); axis equal; view([60,20]); hold on;
alpha(0.5);
Zrange=Z(:,1);
for i=1:length(Zrange)
    ix=X(Z==Zrange(i));
    iy=Y(Z==Zrange(i));
    iz=ones(size(ix))*Zrange(i);
   % scatter3(ix,iy,iz,'filled','MarkerFaceColor','blue')   
    meanx = mean(ix);
    meany = mean(iy);
    scatter3(meanx,meany,Zrange(i),'filled','MarkerFaceColor','red');hold on;
 
end
ttl=ttl{:};
ttl=strcat('Data/Output/',ttl(1:end-4),'.png');
print(fig,ttl,'-dpng','-r300');
close fig;
end
