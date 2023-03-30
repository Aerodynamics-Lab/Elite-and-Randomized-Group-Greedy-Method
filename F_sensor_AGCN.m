function [isensors, Rinv, time]=F_sensor_AGCN(Xorg,r1,r2,p)

    [n,m]=size(Xorg);
    [Uorg,Sorg,Vorg]=svd(Xorg,'econ');
    [~,rr]=size(Sorg);
    Psi=Uorg(:,1:r1);
    Ur=Uorg(:,r1+1:r2);
    Sr=Sorg(r1+1:r2,r1+1:r2);
    Vr=Vorg(:,r1+1:r2);
    Xorglr=Uorg(:,1:r1)*Sorg(1:r1,1:r1)*Vorg(:,1:r1)';
    Rlrdiag=diag(Ur*Sr*Sr*Ur');
    dSdiag=zeros(n,1);
    for i=1:n
        tmp=0;
        for j=1:rr
         tmp=tmp+(Xorg(i,j)-Xorglr(i,j))^2;
        end
        dSdiag(i)=tmp-Rlrdiag(i);
    end
    
    tic;
    [isensors,Rinv]=F_AGCN(Psi,Ur,Sr,p,dSdiag);
    time=toc;
end