function Model = getlwratio(Model)
M1=Model.M1R;
M2=Model.M2R;
[ycoord, ~]=find(M1==1);
mny=min(ycoord);
mxy=max(ycoord);
Ls1=mxy-mny;
%imshow(M1);hold on;
%imshow(M2);hold on;

for i=mny:mxy
    strip=M1(i,:);
    a=find(strip==1);
    if (~isempty(a))
        width1(i-mny+1)=max(a)-min(a);
    end
end

[ycoord, ~]=find(M2==1);
mny=min(ycoord);
mxy=max(ycoord);
Ls2=mxy-mny;
for i=mny:mxy
    strip=M2(i,:);
    a=find(strip==1);
    if (~isempty(a))
        width2(i-mny+1)=max(a)-min(a);
    end
end

w1=max(width1);w2=max(width2);


Model.lwratio=[Ls1/w1 Ls2/w2];




end