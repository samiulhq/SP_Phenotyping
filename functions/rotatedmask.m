function [Model]= rotatedmask(Model)

M1=Model.Mask1;
M2=Model.Mask2;
xC1=Model.xC1;
xC2=Model.xC2;
yC=Model.yC;

p = polyfit([xC1(1) xC1(end)],[yC(1) yC(end)],1);
 
theta=atan(p(1));
R = [cos(pi/2-theta) -sin(pi/2-theta); sin(pi/2-theta) cos(pi/2-theta)];
x_center=mean(xC1); y_center=mean(yC);
center = repmat([x_center; y_center], 1, length(xC1));
v=[xC1; yC];
s = v - center; 
so = R*s;   
vo = so + center;
xC1R=vo(1,:);
yC1R=vo(2,:);
M1R=rotateAround(M1,y_center,x_center,270+(theta)*180/pi);
 
 
 
p = polyfit([xC2(1) xC2(end)],[yC(1) yC(end)],1);
theta=atan(p(1));
R = [cos(pi/2-theta) -sin(pi/2-theta); sin(pi/2-theta) cos(pi/2-theta)];
x_center=mean(xC2); y_center=mean(yC);
center = repmat([x_center; y_center], 1, length(xC2));
v=[xC2; yC];
s = v - center; 
so = R*s;   
vo = so + center;
xC2R=vo(1,:);
yC2R=vo(2,:);
M2R=rotateAround(M2,y_center,x_center,90+(theta)*180/pi);

Model.M1R=M1R;
Model.M2R=M2R;
Model.xC1R=xC1R;
Model.xC2R=xC2R;
Model.yC1R=yC1R;
Model.yC2R=yC2R;

end
