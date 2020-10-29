function [Model] = getmask3Dshape(image,varargin)
%returns two binary masks and centroids from original sweetpotato image
%input sweetpotato image from the grader.
[rows, columns, numberOfColorChannels] = size(image);
if numberOfColorChannels==1
    imGray = double(image);
else
    imGray = double(rgb2gray(image));
end

%imGray = imgaussfilt(imGray,1);
%% SEGMENTING IMAGE  %infuture update with advanced ML method
if nargin==1
    thIm = 100; %threshold for image segmentation should be checked with new imaging setup
else
    thIm=varargin{1};
end
uint8Image = uint8(255 * mat2gray(imGray));
%T = adaptthresh(uint8Image);
%imMask0 = imbinarize(uint8Image,T);
%figure(1);imshow(imMask0)
imMask0 = (uint8Image>thIm);
%figure(1);imshow(imMask0)
[L,N] = bwlabel(imMask0);
thSz = 0.1*nnz(imMask0);
for i = 1:N
    if(nnz(L==i)<thSz)
        L(L==i) = 0;
    end
end
imMask1 = imfill(L>0,'holes'); %fills the holes in segmented imge

%% ALIGNING RIGHT REGION TO LEFT

% Getting pixel coordinates
[xx,yy] = meshgrid(1:size(imMask0,2),1:size(imMask0,1));

% Extracting right and left masks  %if thre are more than one sweet potatoes
% n will be greater than two


[L n] = bwlabel(imMask1);
M1 = (L==1);
M2 = (L==2);
x1 = sum(sum(xx.*M1))/nnz(M1);
x2 = sum(sum(xx.*M2))/nnz(M2);
if(x1>x2)
    tmp = M1; M1 = M2; M2 = tmp;
    tmp = x1; x1 = x2; x2 = tmp;
end

% Extracting vertical range for both masks
tmp = max(M1,[],2);
tmp = yy(tmp,1);
yRan1 = [min(tmp) max(tmp)];
tmp = max(M2,[],2);
tmp = yy(tmp,1);
yRan2 = [min(tmp) max(tmp)];

% Scaling the image coordinates
f = diff(yRan1)/diff(yRan2);
xxp = f*(xx-x2)+x2;
yyp = f*(yy-yRan2(1))+yRan1(1);

% Creating a new interpolated image
M2 = double(M2);
tmp = interp2(xxp,yyp,M2,xx,yy,'nearest');
tmp = tmp(:);
tmp(isnan(tmp)) = 0;
M2p = reshape(boolean(tmp),size(M2));

%% EXTRACTING CENTERLINE AND RADII

%adjust by one pixel if segmentation resulted no mask at given height (yval).
y1=0;y2=0;
v = yy(M2p(yRan1(1),:),1);
if sum(v)==0
    y1=1;
    while(sum(v)==0)
        v = yy(M2p(yRan1(1)+y1,:),1);
        y1=y1+1;
    end
end

v = yy(M2p(yRan1(2),:),1);
if sum(v)==0
    y2=1;
    while(sum(v)==0)
        v = yy(M2p(yRan1(2)-y2,:),1);
        y2=y2+1;
    end
end

if y1 || y2
    disp('adjust')
end
yC = round(linspace(yRan1(1)+y1, yRan1(2)-y2, 20));
xC1 = zeros(size(yC));
xC2 =  xC1; rC1 = xC1; rC2 = xC1;

for i = 1:length(yC)
    v = yy(M1(yC(i),:),1);
    rC1(i) = length(v)/2;
    xC1(i) = mean(v);
    v = yy(M2p(yC(i),:),1);
    rC2(i) = length(v)/2;
    xC2(i) = mean(v);
end

%% MODIFYING ELLIPSOID
[X,Y,Z] = ellipsoid(0,0,mean(yRan1),100,100,diff(yRan1)/2,30);
R1 = interp1(yC,rC1,Z); %getting values of R1 for specified Z points
R2 = interp1(yC,rC2,Z);%getting values of R2 for specified Z points
C1 = interp1(yC,xC1,Z);%getting values of XC1 for specified Z points
C2 = interp1(yC,xC2,Z);%getting values of XC2 for specified Z points

for i = 1:numel(Z)
    v = [X(i) Y(i)]; %creating the vector
    v = v/norm(v);    %unite vector
    X(i) = v(1).*R1(i)+C1(i); %A vector of R1 in direction of x
    Y(i) = v(2).*R2(i)+C2(i);% A vector of R2 in direction of y
    
end

X=fillmissing(X,'nearest');
Y=fillmissing(Y,'nearest');
Z=fillmissing(Z,'nearest');
h=Z(:,1);
cx=mean(X,2);
cy=mean(Y,2);

%surf(X,Y,Z); hold on;
%plot3(cx,cy,h,'.-','Color','red','MarkerSize',25);
%colormap gray;
%alpha 0.5;
ran1 = 2;
ran2 =size(Z,1);

for i = ran1:ran2
    p1=[cx(i-1) cy(i-1) h(i-1)];
    p2=[cx(i) cy(i) h(i)];
    v=p2-p1;
    u=v/norm(v);%direction
    px=X(Z==Z(i));
    py=Y(Z==Z(i));
    pz=Z(Z==Z(i));
    %plot3(px,py,pz);
    sppoints=[px py pz]-repmat([p2],length(px),1) ;
    sppoints=[sppoints(:,1)*2 sppoints(:,2)*2 sppoints(:,3)];
    rz = u;
    rx = [1 0 0] - ([1 0 0]*(rz'))*rz;
    rx = rx/norm(rx);
    ry = cross(rz,rx);
    R2 = [10*rx; 10*ry; rz];
    sppoints=sppoints*R2 +repmat([p2+p1]/2,length(px),1);
    DT = delaunayTriangulation(sppoints(:,1),sppoints(:,2),sppoints(:,3));
    if(isempty(DT.ConnectivityList))
        Rotated_Planes{i}=[];
        continue;
        
    end
    [faces vertices]=freeBoundary(DT);
    obj.faces=faces;
    obj.vertices=vertices;
    sweetpotato=surf2patch(X,Y,Z);
    [inMatrix,intSurface]=SurfaceIntersection(sweetpotato,obj);
    %    if i==16
    %   plot_surf_intersection(obj,X,Y,Z,intSurface);
    %    end
    Rotated_Planes{i}=intSurface;
    patchplane.vertices=intSurface.vertices;
    patchplane.faces=intSurface.faces;
    %   if i==16
    % plot_surf_intersection(obj,X,Y,Z,intSurface.vertices);
    %    end
    %    scatter3(intSurface.vertices(:,1),intSurface.vertices(:,2),intSurface.vertices(:,3),'filled')
    for k=1:length(sppoints)
        points=[X(:) Y(:) Z(:)];
        dis=[X(:) Y(:) Z(:)]-repmat(sppoints(k,:),numel(X),1);
        dis=dis.^2;
        dis=sum(dis,2);
        [~,pind]=min(dis);
        surfpoints(k,:)=points(pind,:);
        points(pind,:)=[inf inf inf];
    end
    
    %   scatter3(surfpoints(:,1),surfpoints(:,2),surfpoints(:,3),'filled');hold on;
    
end

Model=[];
Model.X=X;
Model.Y=Y;
Model.Z=Z;
Model.CrossSections=Rotated_Planes;
Model.Mask1=M1;
Model.Mask2=M2p;
Model.xC1=xC1;
Model.xC2=xC2;
Model.yC=yC;
Model.centerpoints=[cx cy h];
end
