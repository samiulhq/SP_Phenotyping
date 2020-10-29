% script for segmentation of the sweet potato pictures, and 3D reconstruction.
% Author: Samiul Haque, Edgar Lobaton
clear all;
close all;
badimages=[];
addpath('functions\')
set(0,'defaultAxesFontSize',18);
set(0,'defaulttextInterpreter','latex');

%define variable names for output data Table
Varnames={'Title','AxialLength','TipLength','Curvature','MaxDiameter',...
    'LWRatio','TailLength','TailPct','Shape','BodyLength','TailBodyRatio','Volume','AverageCrossSectionRadius'}

dataTable=array2table(zeros(0,length(Varnames)), 'VariableNames',Varnames);

%location to training image folder
trainingpath='Training_Dataset'
dirinfo = dir(trainingpath);
dirinfo(strcmp(extractfield(dirinfo,'name'),'.')) = [];  %remove non-directories
dirinfo(strcmp(extractfield(dirinfo,'name'),'..')) = [];  %remove non-directories

%define shape types should match subfolders in the data
shapes={'Curved','U.S. No. 1','Other','Tapered','Tailed','Round'};

for j=1:length(dirinfo)
    shapetype = dirinfo(j).name;
    if sum(contains(shapes,shapetype))==0
        continue;
    end
    thisdir=fullfile(trainingpath,shapetype,'*.tif');
    imagelists=dir(thisdir);
    imlocation=[fullfile(trainingpath,shapetype)];
    
    for i=1:length(imagelists)
        Model=[];
        disp(i)
        im=imread(fullfile(imlocation,imagelists(i).name));
        try
            ttl=cellstr(imagelists(i).name);%title or id of sweetpotato
            
            %creating 3D Model
            Model=get3DModel(im);            
            
            %constructing data Table
            T2=table(ttl,Model.axialLength*Model.CalibFactor,Model.tipLength*Model.CalibFactor,...
                Model.curvatureCorrected,Model.Width*Model.CalibFactor,Model.LsEffective/(Model.Width*Model.CalibFactor),...
                Model.Tail1+Model.Tail2,Model.TailPct,cellstr(shapetype),Model.BodyLength,Model.TailBodyRatio,Model.Volume,mean(Model.std_radius));
            
            
            %diameters across cross-sections
            diam=array2table(Model.diameters_of_cross_section*Model.CalibFactor);
            diam.Title=cellstr(ttl);
            
            %roundness across cross-sections
            stdRad=array2table(Model.std_radius);
            stdRad.Title=cellstr(ttl);
            
            
            %figures_ppt(Model,im)  %comment out if you want to visualize
            %3D shape
            
            %Assign to dataTable with variable names
            T2.Properties.VariableNames=Varnames;
            dataTable=[dataTable;T2];
            % disp('Added to table');
                        
            
            %for first iteration initialize tables
            if j==1 && i==1
                diamTable=diam;
                stdRadiiTable=stdRad;
            else
                diamTable=[diamTable;diam];
                % disp('Added diameters');
                stdRadiiTable=[stdRadiiTable;stdRad];
                %   disp('Added Radii variance');
            end
        catch
            str=['Problem processing image',ttl];
            disp(str);
            badimages=[badimages ttl]; %this array stores image titles that we couldnot process
        end
        
    end
    
    
end

%%%add diameters and roundness across crossection to dataTable
for i=1:length(Model.diameters_of_cross_section)
    diamTable.Properties.VariableNames{i}=['diameter',num2str(i)];
end
for i=1:length(Model.std_radius)
    stdRadiiTable.Properties.VariableNames{i}=['sdRad',num2str(i)];
end
tmp=dataTable;
dataTable=innerjoin(tmp,diamTable,'Keys','Title');
dataTable=innerjoin(dataTable,stdRadiiTable,'Keys','Title');

%%comment out next 2 lines if you want multi-class labels
mask=strcmp(dataTable.Shape,'U.S. No. 1');
tmp=dataTable;tmp.Shape(~mask)={'Cull'};

writetable(tmp,'sp_feature_table.csv');

