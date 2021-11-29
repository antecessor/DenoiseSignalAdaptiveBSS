function Ind=calcActivityIndex(eY,iRy,T)
% Ind=calcActivityIndex(eY,iRy);
%
% Calculates the MU activity index (see [1] for details).  
%
% Inputs: 
%   eY - the row-vise vector of extended measurements 
%   iRy - inverse correlation matrix of eY
%   T - number of samples of eY per single calculation (for computational reasons)
% Outputs:
%   Ind - MU activity index 
%
% AUTHOR: Ales Holobar, FEECS, University of Maribor, Slovenia
%
% [1]  A. Holobar, D. Zazula: Correlation-based decomposition of surface EMG signals at low contraction forces, 
%      sumbited to Medical & Biological Engineering & Computing  

Ind=[];
if nargin<3
    lag=0;
end
[r,c]=size(eY);

Ind=zeros(1,c);
for k=1:floor(c/T)         
    Tmp = iRy*eY(:,(k-1)*T+1:k*T);
    Ind((k-1)*T+1:k*T) = sum(eY(:,(k-1)*T+1:k*T).*Tmp);   
end

if isempty(k)
    k=0;
end

Tmp = iRy*eY(:,k*T+1:end);
Ind(k*T+1:end) = sum(eY(:,k*T+1:end).*Tmp);

for i=1:r
    tmp(i)=length(find(eY(i,1:200)==0)); 
end
ExtFacktor=max(tmp);
Ind([1:ExtFacktor,end-ExtFacktor:end])=mean(Ind(200:300));

