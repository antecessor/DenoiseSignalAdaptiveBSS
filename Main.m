%%
load('ecg.mat');
data.SIG=ecgn;
data.fsamp=128;
length=size(data.SIG,2);
% %% EMD Denoise
% for i=1:size(data.SIG,1)
%     data.SIG(i,:)= emd_dfadenoising(data.SIG(i,:)');
% end
%% Channel Selection
% data.SIG=Channel_Selection(data.SIG,data.fsamp);
%% Denoise PoweLine
data.SIG=PowerLineRemove(data.SIG,data.fsamp,2);
%% Extend
exFactor=10;
Y=data.SIG(:,2:end);
% [Y,exFactor]=CKC_PreProcessing(0,data.SIG,data.signal_length,data.fsamp,data.montage,1,20,500,10);
%  [Y,exFactor]=CKC_PreProcessing(0,data.SIG,length,data.fsamp,data.montage,1,20,500,10);
eY = extend(Y(:,1:length-1),exFactor);
Y=Y(:,1:length-1);
epochsize=data.fsamp/32;
%% Normalization
for i=1:size(eY,1)
   eY(i,:)=detrend( (eY(i,:)-min(eY(i,:)))./(max(eY(i,:))-min(eY(i,:))));
end
% %% add noise
% PTP=max(eY')-min(eY');
% SNR=15;
% fc2=500;
% fc1=100;
% sd=abs(PTP).*(fc2-fc1)/(data.fsamp*10^(SNR/20));
% for i=1:size(eY,1)
%     noise=2*sd(i).*rand(1,size(eY,2))-.5;
%     eY(i,:)=eY(i,:)+noise;
% end

%%
% [b,a] = butter(8,[fc1 fc2]/(data.fsamp/2));
 eY = lpbutter (eY, 50,data.fsamp);
 eY = hpbutter (eY, 5,data.fsamp);

%% Use HRA for finding peaks (EMGLAB)
m=0;
fs=data.fsamp;
clear m;
k=1;
for i=1:exFactor:size(eY,1)
   X=eY(i,:); 
   [m{k},up,spike_times]=EL_HRA_OP(X',fs);
    if numel(m{k})==0
        m{k}=[];
    end
   k=k+1;
end

for j=1:size(m,2)
if size(m{1,j},1)>1
    m{1,j}=m{1,j}(1);
end;
end;

m=cell2mat(m);
m=unique(m);
m(m==0)=[];
%% whitening
% Z=zeros(size(eY));
% for i=1:epochsize:numel(eY(1,:))-epochsize
% epochData=eY(:,i:epochsize+i-1);
% Rx=epochData*epochData';
% [u,d,v]=svd(Rx);
% W=u*d^(-.5)*u';
% Z(:,i:epochsize+i-1)=W*epochData;
% end
%% Demuse_CKC
% [ActIndWhole,ActIndResid,MUPulses,Cost,MUPulses2,Cost2,IPTs,IPTs2,ProcTime]=RunCKC_DEMUSE(eY,exFactor,data.fsamp,20,1);
%%
% [T,MUAP]=CKC_FCM(eY,Y,exFactor,50);
%% WaveLetDenoise
% clear X
% for i=1:size(eY,1)
% [Z1,~] = dwt(eY(i,:),'sym2');
% [Z1,~] = dwt(Z1,'sym2');
% X(i,:) = resample(Z1, 4, 1);
% end
%%
%%
% iter=50;
% CKC_Kalman(eY,iter,m,1,data.fsamp);
%%

%data.Alpha=769.244888673085; %sqrt(sum(sum(eY.^2))*3.5);

iter=100;


[estimatedNoise,SelectedInd,dataPeakIndex,M,MyPNR]=CKC_Gradient...
    (eY,epochsize,iter,3,m,1,data.fsamp);

load('ecg.mat');
no=estimatedNoise
PSO




