function roundness = getroundness(X,Y,Z)
Zrange=Z(:,1);
mn=min(Zrange(2:end-1));mx=max(Zrange(2:end-1));
for i=2:length(Zrange)-1
    ix=X(Z==Zrange(i));
    iy=Y(Z==Zrange(i));
    iz=ones(size(ix))*i;
    %scatter3(ix,iy,iz,'filled');hold on;
    meanx = mean(ix);
    meany = mean(iy);
    %scatter3(meanx,meany,i,'filled','x','MarkerFaceColor','red');hold on;
    dist=sqrt((ix-meanx).^2 + (iy-meany).^2);
    rhat(i-1)=std(dist)/mean(dist);
end
roundness=rhat([2 8 15 22 28]);
end