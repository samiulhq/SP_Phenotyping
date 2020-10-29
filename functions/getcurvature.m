function curvature = getcurvature(xC1R,xC2R,yC1R)

yC2R=yC1R;
%align Xc and Yc to y axes; find the angle
% find max and min point
% p = polyfit(xC1R([1,20]),yC1R([1,20]),1);
% theta=atan(p(1));
% R = [cos(pi/2-theta) -sin(pi/2-theta); sin(pi/2-theta) cos(pi/2-theta)];
% x_center=mean(xC1); y_center=mean(yC);
% center = repmat([x_center; y_center], 1, length(xC1));
% v=[xC1; yC];
% s = v - center; 
% so = R*s;   
% vo = so + center;
% xC1R=vo(1,:);
% yC1R=vo(2,:);
% 
% p = polyfit(xC2R([1,20]),yC2R([1,20]),1);
% theta=atan(p(1));
% R = [cos(pi/2-theta) -sin(pi/2-theta); sin(pi/2-theta) cos(pi/2-theta)];
% x_center=mean(xC2R); y_center=mean(yC2R);
% center = repmat([x_center; y_center], 1, length(xC2R));
% v=[xC2; yC];
% s = v - center; 
% so = R*s;   
% vo = so + center;
% xC2R=vo(1,:);
% yC2R=vo(2,:);
% 
% 
% 
p1=[xC1R(1:end-1)' yC1R(1:end-1)'];
p2=[xC1R(2:end)' yC1R(2:end)'];
distance=sqrt((p1(:,1)-p2(:,1)).^2+(p1(:,2)-p2(:,2)).^2);
distance=distance(~isnan(distance));
Lc1=sum(distance);
Ls1=sqrt((xC1R(end)-xC1R(1))^2 + (yC1R(end)-yC1R(1))^2);


p1=[xC2R(1:end-1)' yC2R(1:end-1)'];
p2=[xC2R(2:end)' yC2R(2:end)'];
distance=sqrt((p1(:,1)-p2(:,1)).^2+(p1(:,2)-p2(:,2)).^2);
distance=distance(~isnan(distance));
Lc2=sum(distance);
Ls2=sqrt((xC2R(end)-xC2R(1))^2 + (yC2R(end)-yC2R(1))^2);
curvature=[Lc1/Ls1 Lc2/Ls1];
end