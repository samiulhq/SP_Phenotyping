function Model = getMaxDiameter(Model)
valid_slice_nums=[];
diameters_of_cross_section=[];

for i=1:length(Model.CrossSections)
    
    cross_section=Model.CrossSections{i};
    if isempty(cross_section)
        diameters_of_cross_section=[diameters_of_cross_section 0];
        continue;
    end
    cross_section=cross_section.vertices;
    chords=pdist2(cross_section,cross_section);
    diameter=max(max(chords));
    valid_slice_nums=[valid_slice_nums i];
    diameters_of_cross_section=[diameters_of_cross_section diameter];
    
end

Model.valid_slice_nums=valid_slice_nums;
Model.diameters_of_cross_section=diameters_of_cross_section;
[Model.Width ind]=max(diameters_of_cross_section);

%%%rate of change in diameter %taper test
middle=Model.centerpoints(ind,:);

for i=1:length(Model.centerpoints)
    dist(i)=sqrt(sum((Model.centerpoints(i,:)-middle).^2))*Model.CalibFactor*(sign(i-ind));
end
Model.dist=dist;
Model.TaperRad=Model.diameters_of_cross_section(Model.StartInd:Model.EndInd)*Model.CalibFactor;
Model.TaperDist=Model.dist(Model.StartInd:Model.EndInd);

%%calculate tail length
diamInch=diameters_of_cross_section*Model.CalibFactor;
tail1=0;
maxpos=length(Model.centerpoints);
currentpos=2;
tailDiam=0.5;
while(diamInch(currentpos)<tailDiam && currentpos<=maxpos)
    tmp=sqrt(sum((Model.centerpoints(currentpos,:)- Model.centerpoints(currentpos-1,:)).^2));
    tail1=tail1+ tmp*Model.CalibFactor;
    currentpos=currentpos+1;
end
p1=Model.centerpoints(currentpos,:);
currentpos=maxpos-1;
tail2=0;
while(diamInch(currentpos)<tailDiam && currentpos>1)
    tmp=sqrt(sum((Model.centerpoints(currentpos+1,:)-Model.centerpoints(currentpos,:)).^2));
    tail2=tail2+ tmp*Model.CalibFactor;
    currentpos=currentpos-1;
end
p2=Model.centerpoints(currentpos,:);

Ls=sqrt(sum((p1-p2).^2))*Model.CalibFactor;
Lc=Model.axialLength*Model.CalibFactor-tail1-tail2;

Model.LsEffective=Ls;


Model.Tail1=tail1;
Model.Tail2=tail2;
Model.BodyLength=Model.axialLength*Model.CalibFactor-tail1-tail2;

Model.TailPct=(tail1+tail2)/(Model.axialLength*Model.CalibFactor);
Model.TailBodyRatio=(tail1+tail2)/(Model.BodyLength);
Model.curvatureCorrected=Lc/Ls;
