%% 
% sekinge previous methods wor

clear all
outdir='./out_NACA/'
mkdir(outdir)
algslist = {'random','EG','GEG','RGEG','ERGEG'};
datadir='18deg/PIV_flowfield'
addpath(datadir)   %http://www.aero.mech.tohoku.ac.jp/rom/Nonomura2021-Airfoil-PIV-data-for-linear-ROM-18.zip
addpath('NACA_visualization')

%for 10-fold CV
%TTtests_list=[1   101 201 301 401 501 601 701 801 901 ] ;
%TTteste_list=[100 200 300 400 500 600 700 800 900 1000];

TTtests_list=[1   ];
TTteste_list=[100 ];

Lmax=50;  %group size
ns=1000;  %number of compressed sensor candidates
pov=100;  %number of elite sensor candidates
r1 = 30;  %number of latent variables (number of POD modes)

plist = [ 5 10 20 50];
%plist = [ 3 ]; %number of sensors to be selected

numcv=size(TTteste_list,2);
modelerr=zeros(size(TTteste_list,2));

for nitr=1:size(TTteste_list,2)
    TTtests=TTtests_list(nitr);
    TTteste=TTteste_list(nitr);
    algs=algslist;

    algs{2,1} = [];
    obj = struct(algs{:});
    ctime = struct(algs{:});
    numitr = struct(algs{:});
    zmax = struct(algs{:});
    err = struct(algs{:});
    xrec = struct(algs{:});
    algs = algs';

    %for itr = 1:numave
    for pitr=1:size(plist,2)
        p=plist(pitr);

        [~,mlx_name,~] = fileparts(matlab.desktop.editor.getActiveFilename);
        snap.cs = {'18deg'}; snap.case_num = char(snap.cs);snap.num_data = 1*10^4;
        snap.usedind = mat2cell([1:1000],1);
        pathdata = [datadir,'/ufield_allt.mat'];
        [u, loc] = F_PIV_load(cell2mat(snap.usedind), pathdata, snap.case_num);
        mask=~isnan(u.mean);
        Iord=1:1000;
        Itest=Iord(TTtests:TTteste);
        Itrain=Iord(~ismember(Iord,Itest));
        Xtest=u.fluc(mask==1,Itest);
        Xtrain=u.fluc(mask==1,Itrain);
        xmean=u.mean(mask==1);
        xrec.('xmean') = xmean;

        [Uorg,Sorg,Vorg] = svd(Xtrain,'econ');
        n=size(Uorg,1);
        Psi=Uorg(:,1:r1);
        xrec.('random') = zeros(n,size(plist,2));
        xrec.('EG') = zeros(n,size(plist,2));
        xrec.('GEG') = zeros(n,size(plist,2));
        xrec.('RGEG') = zeros(n,size(plist,2));
        xrec.('ERGEG') = zeros(n,size(plist,2));

        disp(['p: ', num2str(p), '  ',num2str(pitr),'/',num2str(size(plist,2))])

        alg = algs{1};%'random'
        disp([alg, ': ' num2str(nitr),'/',num2str(numcv)])
        rng(nitr,'twister');
        [sensors]=F_sensor_random( Psi, p, 1);
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        obj.(alg)(end+1) = min(eig(FIM));
        [error,xreconst] = F_calc_reconst_error(Xtest, sensors, Psi);
        err.(alg)(end+1) = error;
        xrec.(alg)(:,pitr) = xreconst;  %fist snapshot of reconstructed data
        disp(['obj: ', num2str(obj.(alg)(end)), ', err: ', num2str(err.(alg)(end))])
%%
        %%{
        alg = algs{2};%'EG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numcv)])
        [time, sensors] = F_sensor_EG(Psi,p);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        obj.(alg)(end+1) = min(eig(FIM));
        [error,xreconst] = F_calc_reconst_error(Xtest, sensors, Psi);
        err.(alg)(end+1) = error;
        xrec.(alg)(:,pitr) = xreconst;
        disp(['obj: ', num2str(obj.(alg)(end)), ', err: ', num2str(err.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}
%%
        %%{
        alg = algs{3};%'GEG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numcv)])
        [time, sensors] = F_sensor_GEG(Psi,p,Lmax/10);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        obj.(alg)(end+1) = min(eig(FIM));
        [error,xreconst] = F_calc_reconst_error(Xtest, sensors, Psi);
        err.(alg)(end+1) = error;
        xrec.(alg)(:,pitr) = xreconst;
        disp(['obj: ', num2str(obj.(alg)(end)), ', err: ', num2str(err.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}
%%
        %%{
        alg = algs{4};%'RGEG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numcv)])
        [time, sensors] = F_sensor_RGEG(Psi,p,Lmax,ns);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        obj.(alg)(end+1) = min(eig(FIM));
        [error,xreconst] = F_calc_reconst_error(Xtest, sensors, Psi);
        err.(alg)(end+1) = error;
        xrec.(alg)(:,pitr) = xreconst;
        disp(['obj: ', num2str(obj.(alg)(end)), ', err: ', num2str(err.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}

        %%{
        alg = algs{5};%'ERGEG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numcv)])
        [time, sensors] = F_sensor_ERGEG(Psi,p,Lmax,ns,pov);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        obj.(alg)(end+1) = min(eig(FIM));
        [error,xreconst] = F_calc_reconst_error(Xtest, sensors, Psi);
        err.(alg)(end+1) = error;
        xrec.(alg)(:,pitr) = xreconst;
        disp(['obj: ', num2str(obj.(alg)(end)), ', err: ', num2str(err.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}

    end
    
    [Utest,Stest,Vtest]=svd(Xtest,'econ');
    Xtestr=Utest(:,1:r1)*Stest(1:r1,1:r1)*Vtest(:,1:r1)';
    modelerr(nitr)=norm((Xtestr-Xtest),'fro')/norm(Xtest,'fro');
    save([outdir,'ctime','_CV',num2str(TTtests),'-',num2str(TTteste),'r1',num2str(r1),'.mat'],'ctime')
    save([outdir,'sens','_CV',num2str(TTtests),'-',num2str(TTteste),'r1',num2str(r1),'.mat'],'sens')
    save([outdir,'obj','_CV',num2str(TTtests),'-',num2str(TTteste),'r1',num2str(r1),'.mat'],'obj')
    save([outdir,'err','_CV',num2str(TTtests),'-',num2str(TTteste),'r1',num2str(r1),'.mat'],'err')
    save([outdir,'xrec','_CV',num2str(TTtests),'-',num2str(TTteste),'r1',num2str(r1),'.mat'],'xrec')

    disp(['CV = ', num2str(TTtests), ':', num2str(TTteste)])
end
save([outdir,'modelerr.mat'],'modelerr')
gongmat=load('gong.mat');
sound(gongmat.y);
pause(3);
clear sound