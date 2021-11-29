function Ind=findCandPositions(PulseSeq,No,Lim,fInd,fLim);
%  Ind=findCandPositions(PulseSeq,No,Lim,fInd,fLim);
%
% finds the "No" highest pulses in pulse sequence "PulseSeq" ignoring the
% pulses that are closert than "Lim" to aready identified pulses and closer
% than "fLim" to time positions stated in "fInd"
%
% Inputs: 
%   PulseSeq - tested pulse sequence
%   No - the number of highest pulses to select
%   Lim - the lower limit of interpulse distance
%   fInd - forbidden time positions
%   fLim - the minimal allowed distance form time positions in fInd
% Outputs:
%   Ind - vector of selected indices
%
% AUTHOR: Ales Holobar, FEECS, University of Maribor, Slovenia

Ind=zeros(1,No);

for k=1:length(fInd)    
    PulseSeq(max(fInd(k)-Lim,1):min(fInd+Lim,end))=-inf;
end

[m,i]=sort(PulseSeq);
tmp=i;

if ( Lim<1 & fLim<1)
    Ind=i(end-No:end,:).';
else
    k=length(i);  
    c=1;
    Ind(1)=i(k);
    while (c<No & k>0)                       
        tmp=abs(Ind-i(k));              
        if (tmp>Lim)                                    
            c=c+1;
            Ind(c)=i(k);
        end
        k=k-1;        
    end
end