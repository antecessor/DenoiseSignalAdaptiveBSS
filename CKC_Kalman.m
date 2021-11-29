function CKC_Kalman(eY,iter,initailPos,InitailUser,fsamp)
%% Normalization
for i=1:size(eY,1)
   eY(i,:)=detrend( (eY(i,:)-min(eY(i,:)))./(max(eY(i,:))-min(eY(i,:))));
end
%% init
epochData=eY(:,1:end-10);
Cyy_i=pinv(epochData*epochData');
CyyY=Cyy_i*epochData;
if InitailUser==1
   iter=numel(initailPos); 
    m=initailPos;
else
    
    [v,m] = findpeaks(epochData(1,:),'MinPeakHeight',abs(max(epochData(1,:)))*.55,'MINPEAKDISTANCE',5); 
    if numel(m)<iter
       [v,m]= findpeaks(epochData(1,:),'MinPeakHeight',abs(max(epochData(1,:)))*.3,'MINPEAKDISTANCE',5);     
    end
    [~,ind]=sort(v,'descend');
    m=m(ind);
end
%% 

for it=1:iter  
    Cty=epochData(:,m(it));
    z=Cty;
  
    T=(Cty'*CyyY)';
    Cty=mean(T*z')';
    T=(Cty'*CyyY)';
    T=(T-min(T))/(max(T)-min(T));
    plot(T);
    H=z*pinv(T);
    A=mean(z')*CyyY;
    B=0;
    C=H;
    D=0;
    P=diag(zeros(size(T)));  
   [bhat_mtr cov_bound bhat] = autocov_calc(T,1);
    S=H*P*H'+Rest1;
    y=z-H*T;
    
    
end


end