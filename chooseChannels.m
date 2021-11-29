function Y=chooseChannelsCell(y,Fsamp,cut,draw,Finterf)
%
% reformats the signals from data structure, supported by the LISiN load_sig method, to the signal matrix,
% supported by the CKC method. With parameter cut > 0 it also filters out the interfrences at frequency Finterf 
% and all its heigher harmonics.
% INPUTS:
%   y - input signal (data structure supported by load_sig method);
%   Fsamp - sampling frequency [Hz]
%   cut - set cut>0  to filter out the interferences at frequency Finterf
%   draw - set draw>0 to display the frequency content of original and filtered data
%   Finterf - basic artefact frequency [Hz] (e.g. for line interference Finterf=50 Hz)
% OUTPUT
%   Y - (filtered) signal matrix, with each signal in separate row

Frad=round(Fsamp/200);

h=waitbar(0,'Extracting and filtering the channels...');
count = 0;
sigLength = 0;

if draw > 0
    draw = figure;
end


% Calculate number and the maximal length of channels
if (iscell(y))   
    for k=1:size(y,1)        
        for m=1:size(y,2)                
            if (~isempty(y{k,m}))
                count = count + 1;
                sigLength=max(sigLength,length(y{k,m}));
            end
        end
    end
else
    for m=1:size(y,1)                
        if (~isempty(y(m,:)))
            count = count +1;
            sigLength=max(sigLength,length(y(m,:)));
        end
    end
end

if nargin<5
    Finterf = 50;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Filter the channels
fInt=round(0:Finterf*sigLength/Fsamp:(sigLength/2));
Y=zeros(count,sigLength);
count = 0;
if (iscell(y))    
    if cut>0        
        for k=1:size(y,1)
            for m=1:size(y,2)                              
                if (~isempty(y{k,m}))                   
                    ynew=real(subtractFreq2(y{k,m},fInt,Frad,draw));                                       
                    Y{k,m} = ynew;                       
                end
                waitbar(((k-1)*size(y,2)+m)/(size(y,1)*size(y,2)),h);
            end
        end
    else
        for k=1:size(y,1)
            for m=1:size(y,2) 
                if (~isempty(y{k,m}))
                    Y{k,m} = y{k,m};        
                end            
                waitbar(((k-1)*size(y,2)+m)/(size(y,1)*size(y,2)),h);
            end
        end
    end
else
    if cut>0
        for k=1:size(y,1)                                    
            ynew=real(subtractFreq2(y(k,:),fInt,Frad,draw));            
            count = count +1;
            Y(count,:) = ynew;      
            waitbar(k/size(y,1),h);
        end
    else
        for k=1:size(y,1)      
            count = count +1;
            Y(count,:) = y(k,:);      
            waitbar(k/size(y,1),h);
        end
    end
end
close(h);