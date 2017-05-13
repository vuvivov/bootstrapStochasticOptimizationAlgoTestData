rng('default');
col=[1 0 0 ;0 0 1;];
nf=5;
nv=[5 10 50];
load('pop');
addpath('/Users/shangweixie/Documents/MATLAB/package/tightfig');
nPathTrue=10^5;

nPathB=[10^(-2) 10^(-1) 10^(0)]*nPathTrue;
nSampleStd=100;
nSample=2.^(-1:2)*nSampleStd;
nSampleVary=1000;
nT=1000;
dataFolder='data/';
dataFolder2='dataPlot/';
figFolder='fig/';
p1=0:0.01:1;%p of quantile to show
ciP1=[2.5 97.5]+1;%ci of quantile
ciP2=[10 90 50]+1;%ci of gamma
pCdf=[2 100];%min and max percentile used for error compute
figMax=[540 740*.9];
figDef=[560 420];
figOverSize=27/23;