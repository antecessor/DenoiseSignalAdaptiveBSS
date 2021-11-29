function [Y,exFactor]=CKC_PreProcessing(startDecompInt,SIG,LengthSIG,fsamp,origRecMode,useDifferential,LowFreq,HighFreq,signalQuality)
%CKC_PreProcessing(0,SIG,1024,1024,'Mono',1,20,500,10)

DecompIntLength=LengthSIG/fsamp;% second


tIntAll = round([startDecompInt*fsamp+1, startDecompInt*fsamp+DecompIntLength*fsamp-1]); 
FreqCrit = ones(size(SIG))*inf;
AmpCrit = ones(size(SIG))*inf;       
for r=1:size(SIG,1); 
    for c=1:size(SIG,2); 
        if ~isempty(SIG{r,c}) && sum(abs(SIG{r,c}))>0; 
            tmp = abs(fft(SIG{r,c}(tIntAll(1):tIntAll(2))));
            FreqCrit(r,c) = mean(tmp(1:10))/mean(tmp(1:round(HighFreq/fsamp*length(SIG{r,c}(tIntAll(1):tIntAll(2))))));                
            AmpCrit(r,c) = mean(abs(SIG{r,c}(tIntAll(1):tIntAll(2))));           
        end
    end
end
FreqCrit(isinf(FreqCrit)) = 0;
FreqCrit(FreqCrit > prctile(FreqCrit(:),100 - signalQuality)) = 0;
FreqCrit(AmpCrit  < prctile(AmpCrit(:),0 + signalQuality)) = 0;
Y=[];
if strcmp(origRecMode,'MONO') % for monopolar recordings
        for r=1:size(SIG,1); 
            for c=1:size(SIG,2)
                if FreqCrit(r,c)~=0 %&& FreqCrit(r,c+1)~=0
                    Y(end+1,:) = SIG{r,c}(tIntAll(1):tIntAll(2)); %#ok             
                end
            end
        end    
    else
        for r=1:size(SIG,1);  % for single differential recordings
            for c=1:size(SIG,2); 
                if FreqCrit(r,c)~=0
                    Y(end+1,:) = SIG{r,c}(tIntAll(1):tIntAll(2)); %#ok             
                end
            end
        end    
end
%%    
for ch=1:size(Y,1)    
    Y(ch,:)= lpbutter (Y(ch,:)',LowFreq,fsamp)'; %#ok 
    Y(ch,:)= hpbutter (Y(ch,:)',HighFreq,fsamp)'; %#ok 
    Y(ch,1:20) = 0; Y(ch,end-20:end) = 0; %#ok 
end  
Y=chooseChannels(Y,fsamp,1,0,50);    
if useDifferential == 1;
    Y=((diff(Y'))');          
end        
  
%%
nChannels = size(Y,1);
if nChannels > 300
   exFactor = 1;
elseif nChannels > 100
   exFactor = 5; 
elseif nChannels > 50
    exFactor = 10;
elseif nChannels > 30
   exFactor = 15;
else
   exFactor = 20;
end
    

end
%% main
% [ActIndWhole,ActIndResid,MUPulses,Cost,MUPulses2,Cost2,IPTs,IPTs2,ProcTime] = ...
%         GUICKCgrad5(Y,exFactor,fsamp,DecompRuns,0);
%%
% MUPulses = {MUPulses{:} MUPulses2{:}};
% Cost = {Cost{:} Cost2{:}};         
% IPTs = [IPTs; IPTs2];
% [MUPulses,newInd]=eliminateDuplicateIPT(MUPulses,exFactor.fsamp,1);
% Cost = {Cost{newInd}};   
% IPTs = IPTs(newInd,:);