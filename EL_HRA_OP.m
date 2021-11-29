function [m,up,spike_times]=EL_HRA_OP(Xsig,fs)
up=0;
%% Up sampling
if fs<2500
     up=5;
    X = resample(Xsig, up, 1);
   
   
else
     up=2;
    X = resample(Xsig, up, 1);
    
end
fs=fs*up;
%%
s.sig=X;s.dt=1./fs;s.t0=0;
sig=s;
cd('E:\Workspaces\EMGDecompositionCKC\highres');
spike_width = goodwidth (0.001, s.dt);
threshold = getthreshold (sig,.6);
spike_times = findpeaks1 (sig, threshold, spike_width);
[spikes, spikes_tp] = sigseg (sig, spike_times, spike_width, 'c');

[spikes_tp, offset] = hr_align (spikes_tp);
spikes = irtp (spikes_tp);
spike_times = spike_times - offset'*sig.dt;
spike_sample=round(spike_times*fs);
cd('E:\Workspaces\EMGDecompositionCKC\highres');
[RD,CD,order]=optics(spikes',30);
curveOptics=RD(order);
curveOptics=(curveOptics-min(curveOptics))./(max(curveOptics)-min(curveOptics));
[v,m] = findpeaks(curveOptics,'MinPeakHeight',.2); 
% plot(spikes')
% figure;plot(curveOptics);
% hold on
% plot(m,v,'o')
m=round(spike_sample(order(m+2:m+12))/up);
%   
%   index=order(sample)

end