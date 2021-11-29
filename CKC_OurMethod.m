function [Tend,M]=CKC_OurMethod(SigMono,fs,addnoiseflag,fcl,fch,flagUseOpticOrRandomPoint,width,COEF,kopt,flagWaveLetDenoise,flagWhitening)
% example :[Tend,M]=CKC_OurMethod(MONO1,2048,0,50,500,1,.2,.2,50,0,0)

% addnoiseflag=1 => add noise to signal
% fcl=low pass filter fc, fch=high pass filter fc;
% flagUseOpticOrRandomPoint=0 => use RandomPoint and 1 use Optics
 % kopt - number of objects in a neighborhood of the selected object
 % width,COEF in EMGLAB
% flagWaveLetDenoise=1 => use Packet Wavelet for denoise
% flagWhitening=1 => use Whitening


% Laplacian Filter and EMD will add
%% Load Data
data=LoadData(SigMono,fs);
length=size(data.SIG,2);
exFactor=10;
Y=data.SIG(:,1:end);
% [Y,exFactor]=CKC_PreProcessing(0,data.SIG,data.signal_length,data.fsamp,data.montage,1,20,500,10);
%  [Y,exFactor]=CKC_PreProcessing(0,data.SIG,length,data.fsamp,data.montage,1,20,500,10);
eY = extend(Y(:,1:length-1),exFactor);
Y=Y(:,1:length-1);

epochsize=data.fsamp/32;
%% add noise
if addnoiseflag==1
    PTP=max(eY')-min(eY');
    SNR=25;
    fc2=fch;
    fc1=fcl;
    sd=PTP.*(fc2-fc1)/(data.fsamp*10^(SNR/20));
    for i=1:size(eY,1)
        noise=2*sd(i).*rand(1,size(eY,2))-.5;
        eY(i,:)=eY(i,:)+noise;
    end
end
%% BandPass
eY = lpbutter (eY, fcl,fs);
eY = hpbutter(eY, fch,fs);
%% Use HRA for finding peaks (EMGLAB)
m=0;
if flagUseOpticOrRandomPoint==1
fs=data.fsamp;
clear m;
k=1;
for i=1:exFactor:size(eY,1)
   X=eY(i,:); 
   [m{k},up,spike_times]=EL_HRA_OP(X',fs,width,COEF,kopt)
    if numel(m{k})==0
        m{k}=[];
    end
   k=k+1;
end
m=cell2mat(m);
m=unique(m);
m(m==0)=[];
end
%% whitening
if flagWhitening==1
    Z=zeros(size(eY));
    for i=1:epochsize:numel(eY(1,:))-epochsize
    epochData=eY(:,i:epochsize+i-1);
    Rx=epochData*epochData';
    [u,d,v]=svd(Rx);
    W=u*d^(-.5)*u';
    Z(:,i:epochsize+i-1)=W*epochData;
    end
    eY=Z;
end
%% WaveLetDenoise
if flagWaveLetDenoise==1
    clear X
    for i=1:size(eY,1)
    [~,Z2] = dwt(eY(i,:),'sym2');
    X(i,:) = resample(Z2, 2, 1);
    end
    clear eY;
    eY=X;
end
%% CKC_Gradient
iter=100;
[Tend,~,~,M]=CKC_Gradient(eY,epochsize,iter,3,m,flagUseOpticOrRandomPoint,fs);

end