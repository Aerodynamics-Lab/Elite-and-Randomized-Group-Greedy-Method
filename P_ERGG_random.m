%% 
% sekinge previous methods wor

clear all
outdir='./out_random/'
mkdir(outdir)
algslist = {'random','EG','GEG','RGEG','ERGEG', 'DG','GDG','RGDG','ERGDG'};

n=10000   %number of potential sensor location
Lmax=10;  %group size
ns=1000;  %number of compressed sensor candidates
pov=100;  %number of elite sensor candidates
r1 = 10;  %number of latent variables

%plist = [3 5 8 10 12 15 20 30 50];  %number of sensors to be selected
plist = [3 ];
numave=10;  %

for pitr=1:size(plist,2)
    p=plist(pitr);
    algs=algslist;
    algs{2,1} = [];
    objeig = struct(algs{:});
    objdet = struct(algs{:});
    ctime = struct(algs{:});
    numitr = struct(algs{:});
    zmax = struct(algs{:});
    err = struct(algs{:});
    algs = algs';
    disp(['p: ', num2str(p), '  ',num2str(pitr),'/',num2str(size(plist,2))])

    for nitr=1:numave
        rng(nitr,'twister');
        Psi = randn(n,r1);
%%
        alg = algs{1};%'random'
        disp([alg, ': ' num2str(nitr),'/',num2str(numave)])
        rng(nitr,'twister');
        [sensors]=F_sensor_random( Psi, p, 1);

        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        objeig.(alg)(end+1) = min(eig(FIM));
        objdet.(alg)(end+1) = log(det(FIM));
        disp(['objeig: ', num2str(objeig.(alg)(end))])
        disp(['objdet: ', num2str(objdet.(alg)(end))])
%%
        %%{
        alg = algs{2};%'EG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numave)])
        [time, sensors] = F_sensor_EG(Psi,p);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        objeig.(alg)(end+1) = min(eig(FIM));
        objdet.(alg)(end+1) = log(det(FIM));
        disp(['objeig: ', num2str(objeig.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}
%%
        %%{
        alg = algs{3};%'GEG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numave)])
        [time, sensors] = F_sensor_GEG(Psi,p,Lmax);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        objeig.(alg)(end+1) = min(eig(FIM));
        objdet.(alg)(end+1) = log(det(FIM));
        disp(['objeig: ', num2str(objeig.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}
%%
        % %{
        alg = algs{4};%'RGEG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numave)])
        [time, sensors] = F_sensor_RGEG(Psi,p,Lmax,ns);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        objeig.(alg)(end+1) = min(eig(FIM));
        objdet.(alg)(end+1) = log(det(FIM));
        disp(['objeig: ', num2str(objeig.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}

        %%{
        alg = algs{5};%'ERGEG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numave)])
        [time, sensors] = F_sensor_ERGEG(Psi,p,Lmax,ns,pov);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        objeig.(alg)(end+1) = min(eig(FIM));
        objdet.(alg)(end+1) = log(det(FIM));
        disp(['objeig: ', num2str(objeig.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}

        %%{
        alg = algs{6};%'DG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numave)])
        [time, sensors] = F_sensor_DG(Psi,p);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        objeig.(alg)(end+1) = min(eig(FIM));
        objdet.(alg)(end+1) = log(det(FIM));
        disp(['objdet: ', num2str(objdet.(alg)(end)), 'elapse: ', num2str(ctime.(alg)(end))])
        %%}
%%
        %%{
        alg = algs{7};%'GDG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numave)])
        [time, sensors] = F_sensor_GDG(Psi,p,Lmax);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        objeig.(alg)(end+1) = min(eig(FIM));
        objdet.(alg)(end+1) = log(det(FIM));
        disp(['objdet: ', num2str(objdet.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}
%%
        %%{
        alg = algs{8};%'RGDG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numave)])
        [time, sensors] = F_sensor_RGDG(Psi,p,Lmax,ns);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        objeig.(alg)(end+1) = min(eig(FIM));
        objdet.(alg)(end+1) = log(det(FIM));
        disp(['objdet: ', num2str(objdet.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}

        %%{
        alg = algs{9};%'ERGDG'
        disp([alg, ': ' num2str(nitr),'/',num2str(numave)])
        [time, sensors] = F_sensor_ERGDG(Psi,p,Lmax,ns,pov);
        ctime.(alg)(end+1) = time;
        sens.(alg) = sensors;
        [FIM] = F_calc_FIM(Psi,sensors,p,r1);
        objeig.(alg)(end+1) = min(eig(FIM));
        objdet.(alg)(end+1) = log(det(FIM));
        disp(['objdet: ', num2str(objdet.(alg)(end)), ', elapse: ', num2str(ctime.(alg)(end))])
        %%}
    end

%%
    save([outdir,'ctime','_p',num2str(p),'_r1',num2str(r1),'_numave',num2str(numave),'.mat'],'ctime')
    save([outdir,'sens','_p',num2str(p),'_r1',num2str(r1),'_numave',num2str(numave),'.mat'],'sens')
    save([outdir,'objeig','_p',num2str(p),'_r1',num2str(r1),'numave',num2str(numave),'.mat'],'objeig')
    save([outdir,'objdet','_p',num2str(p),'_r1',num2str(r1),'numave',num2str(numave),'.mat'],'objdet')

    disp(['p = ', num2str(p), ':', num2str(size(plist,2))])
end
gongmat=load('gong.mat');
sound(gongmat.y);
pause(3);
clear sound