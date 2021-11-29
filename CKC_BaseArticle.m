function CKC_BaseArticle(eY,Y,exFactor)
Rx=calcCorrMat(Y,exFactor,0,1000);
iRx = pinv(Rx);
Gamma=CalcGamma(eY,iRx);
%% Estimate noise of singal
Sig=eY'; 
Sig=detrend(Sig,0);
for i=1:size(Sig,2)
   Noise_var(i)= evar(Sig(:,i)');
end
sigma2_n=median(Noise_var);
clear Noise_var Sig
%% create Threshold
d=sigma2_n*norm(iRx,1);
%% 
Gamma(Gamma<d)=0;
%% Main Loop
eps=1e-20;
while sum(Gamma(:))-eps>0
  
        
    distance_from_median=abs(Gamma-median(Gamma));
    [~,n0]=find(min(distance_from_median)==distance_from_median);
    vn0=eY(:,n0)'*pinv(eY(:,n0)*eY(:,n0)')*eY(:,n0);
    [~,ind]=find(vn0>d);
    n1=ind(round(numel(ind)*rand));
    vn1=eY(:,n1)'*pinv(eY(:,n1)*eY(:,n1)')*eY(:,n1);
    
    
    
end