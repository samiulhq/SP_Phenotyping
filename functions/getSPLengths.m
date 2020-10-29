function [Model] = getSPLengths(Model)
centroid_x=mean(Model.X,2);centroid_y=mean(Model.Y,2);
%surf(X,Y,Z);hold on;
%scatter3(centroid_x,centroid_y,Z(:,1));hold on;

starti=1;endi=length(Model.mean_radius_of_cross_section);

mr=Model.mean_radius_of_cross_section*Model.CalibFactor;
starti=1;
while(mr(starti)<0)
    starti=starti+1;
end
while(mr(endi)<0)
    endi=endi-1;
end
Model.StartInd=starti;
Model.EndInd=endi;

p1=[centroid_x centroid_y  Model.Z(:,1)];
p1=p1(starti:endi,:);
p2=p1(2:end,:);
p1=p1(1:end-1,:);
Ls=sqrt((p1(1,1)-p2(end,1)).^2 + (p1(1,2)-p2(end,2)).^2+(p1(1,3)-p2(end,3)).^2);
Lc= sum(sqrt((p1(:,1)-p2(:,1)).^2 + (p1(:,2)-p2(:,2)).^2+(p1(:,3)-p2(:,3)).^2));

Model.axialLength=Lc;
Model.tipLength=Ls;

end