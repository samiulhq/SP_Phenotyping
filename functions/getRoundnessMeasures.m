function Model = getMaxDiameter(Model)
center=[];
mean_radius_of_cross_section=[];
radius={};
std_radius=[];
for i=1:length(Model.CrossSections)
    
    cross_section=Model.CrossSections{i};
    if isempty(cross_section)
        mean_radius_of_cross_section=[mean_radius_of_cross_section 0];
        continue;
    end
    cross_section=cross_section.vertices;
    tmp_center=mean(cross_section);
    center=[center; tmp_center];
    tmp=repmat(tmp_center,length(cross_section),1);
    tmp_radius=pdist2(cross_section,tmp);
    tmp_radius=tmp_radius(:,1);
    mean_radius=mean(tmp_radius);    
    radius{i}=tmp_radius;
    std_radius=[std_radius std(tmp_radius)];
    mean_radius_of_cross_section=[mean_radius_of_cross_section mean_radius];
    
end

Model.center=center;
Model.mean_radius_of_cross_section=mean_radius_of_cross_section;
Model.std_radius=std_radius;
Model.sliceradius=radius;
Model.CalibFactor=0.0164;%set a calibration factor
end