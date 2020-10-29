function [Model]=getVolume(Model)
n=length(Model.X);
dA=zeros(n,1);
dz=Model.Z(:,1);
for i=1:n
    dA(i)=polyarea(Model.X(i,:)*Model.CalibFactor,Model.Y(i,:)*Model.CalibFactor);
end

Volume=trapz(dz*Model.CalibFactor,dA);
Model.Volume=Volume;
end