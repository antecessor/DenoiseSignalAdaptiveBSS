function Gamma=CalcGamma(eY,epochsize)

Gamma=zeros(1,size(eY,2));
for i=1:epochsize:numel(eY(1,:))-epochsize
epochData=eY(:,i:epochsize+i-1);
Rx=epochData*epochData';
Gamma(:,i:epochsize+i-1)=diag(epochData'*pinv(Rx)*epochData);
end

end