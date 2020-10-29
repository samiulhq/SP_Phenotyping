function figures_ppt(Model,im)
s1=surf(Model.X,Model.Y,Model.Z);
xlim([0 600])
ylim([0 800])
zlim([0 800])
xlabel('X');ylabel('Y');zlabel('Z');
axis equal
hold on;
colormap gray;
shading interp
alpha(0.5);
plot3(Model.centerpoints(:,1),Model.centerpoints(:,2),Model.centerpoints(:,3),'.-','Color','r','LineWidth',0.5);
splot=[];
s={};
for i=1:length(Model.CrossSections)
    
    if mod(i,5)>0
        continue;
    end
    cross_section=Model.CrossSections{i};
    if isempty(cross_section)
        continue;
    end
    sp=scatter3(cross_section.vertices(:,1),cross_section.vertices(:,2),cross_section.vertices(:,3),5,'filled');
    splot(i,:)=sp.CData;
    
    %     indpt=randi(length(cross_section.vertices),[ 1 3])
    %     l=[Model.centerpoints(i,:);cross_section.vertices(indpt(1),:)]
    %     plot3(l(:,1),l(:,2),l(:,3),'LineWidth',3,'Color','black');
    %     l=[Model.centerpoints(i,:);cross_section.vertices(indpt(2),:)]
    %     plot3(l(:,1),l(:,2),l(:,3),'LineWidth',3,'Color','black');
    %     l=[Model.centerpoints(i,:);cross_section.vertices(indpt(3),:)]
    %     plot3(l(:,1),l(:,2),l(:,3),'LineWidth',3,'Color','black');
    %  vert=cross_section.vertices;
    %  vertf=flip(cross_section.vertices);
    
    % xv = linspace(min(vert(:,1)), max(vert(:,1)), 20);
    % yv = linspace(min(vert(:,2)), max(vert(:,2)), 20);
    % [X,Y] = meshgrid(xv, yv);
    %Z = griddata(vert(:,1),vert(:,2),vert(:,3),X,Y);
    %s{i}=surf(X,Y,Z);
    %s{i}.FaceColor=sp.CData;
    %s{i}.LineStyle='none';
end


zN=15;
cross_section=Model.CrossSections{zN};
%figure;sp=scatter3(cross_section.vertices(:,1),cross_section.vertices(:,2),cross_section.vertices(:,3),'filled');
sp.CData=splot(zN,:);
end