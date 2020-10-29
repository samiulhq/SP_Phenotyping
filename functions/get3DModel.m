function [Model] = get3DModel(im)
%GET3DMODEL Generates 3D model of SP from Exeter Image
%im - input image with two views of SP 90deg apart
%MODEL - ouput 3D model structure containing SP shape features and 3D Mesh
Model = getmask3Dshape(im);
[Model]=rotatedmask(Model);
[Model] = getRoundnessMeasures(Model);
[Model] = getSPLengths(Model);
[Model] = getMaxDiameter(Model);
[Model]= getVolume(Model);
end

