%% PIV data visualization tool
%% Load PIV data

clear all, close all

%target case
method='ERGEG' %sensor selection method to be visualized the result
p=20            %number of sensors
CV='1-100'     %data section
r1=30
%
plist = [ 5 10 20 50]  %refer L21 of test_ERGG_NACA.m

pind=find(plist==p);

[~,mlx_name,~] = fileparts(matlab.desktop.editor.getActiveFilename);
snap.cs = {'18deg'}; snap.case_num = char(snap.cs);snap.num_data = 1*10^4;
snap.usedind = mat2cell([1:1000],1);
pathdata = ['ufield_allt.mat'];
[u, loc] = F_PIV_load(cell2mat(snap.usedind), pathdata, snap.case_num);
load (['out_NACA/sens_CV', CV, 'r1', num2str(r1),'.mat'])

%% scalar image

load (['out_NACA/xrec_CV', CV, 'r1', num2str(r1),'.mat'])
fig_u = F_fig_sensor(xrec.(method)(:,pind)+xrec.('xmean')(:),zeros(121,121),-10,20,loc.normal,sens.(method)');
[wingx,wingy]=F_wingread('NACA0015.txt');
F_wingdraw(snap.case_num,wingx,wingy);

%%