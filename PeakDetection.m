function [IndexPeak,tresh]=PeakDetection(T,fs)
NumberActivationPerSecond=10;
LengthSecond=round(numel(T)/fs); 
NumberMustFind=LengthSecond*NumberActivationPerSecond;
tresh=1;
found=0;
pnr=[];
Range=.8:-.01:.3;
for tresh=Range
    a=numel(find(T>tresh));
    if a>0
    [~,found] = findpeaks(T,'MinPeakHeight',tresh,'MINPEAKDISTANCE',5);
    T0=setdiff(1:numel(T),found);
    pnR=10*log10(mean(T(found).^2)/mean(T(T0).^2));
try
    [Sp_Flag,xm,sd,pd,nI]=Main_Firing_Analysis_1(found/fs);
    pnr=[pnr;30*pd+pnR];
catch
    pnr=[pnr;0];
end
    
    else
       pnr=[pnr;0] ;found=[];
    end
  
end
[~,ind]=max(pnr);
OptimumTresh=Range(ind);
tresh=OptimumTresh;
[~,found] = findpeaks(T,'MinPeakHeight',OptimumTresh,'MINPEAKDISTANCE',5);
if  numel(found)<NumberActivationPerSecond*2 %|| numel(found)>NumberMustFind+5 
    IndexPeak=0;
else
    IndexPeak=found;
    
end



end