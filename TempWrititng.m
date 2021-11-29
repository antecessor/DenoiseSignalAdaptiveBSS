channel=1;
MM=M{channel}(T(channel,M{channel})>.6);
M{channel}=MM;
plot(T(channel,:));hold on;plot(M{channel},T(channel,M{channel}),'o')
save('s5.mat','M')

%%
for i=1:size(T,1)
    figure
   plot(T(i,:)); 
end
%%
for i=1:numel(ok)
    MM{i}=M{ok(i)};
end
M={};
M=MM;
%%
for i=1:size(IPTs,1)
   T=IPTs(i,:);
   T=(T-min(T))/(max(T)-min(T));
    IndexPeak=PeakDetection(T,fsamp);
    T0=setdiff(1:numel(T),IndexPeak);
    pnr(i)=10*log10(mean(T(IndexPeak).^2)/mean(T(T0).^2));          
end
abs(pnr)
%%  EMGLAB_EXPectFiring
for i=1:numel(M)
 [e M{i}]= expectfiring (M{i},2048);
end