function Sig=Channel_Selection(X,fs)
Features=[];
for i=1:size(X,1)
  for j=i:size(X,1)
      K=1;
    for S=1:fs/4:fs
         Seg=X(i,S:S+fs/4);
         Corr{j,K}=abs(xcorr(X(j,:)',Seg'));
         K=K+1;
    end
   
  end
  CorrMat=cell2mat(Corr);
  Fa=median(CorrMat(:));
  
 [p,F] = pcov(X(i,1:fs),4,fs);
  [phat,O,xmedian,xsigma] = hampel(p);
  O(1)=0;O(end)=0;
  L=round(fs*12/500);
  pl=sum(p(1:L));
  pt=sum(phat);
  p0=sum(p(round(20*fs/180):round(40*fs/180)));
  Fb=pl/pt;
  Fc=p0/pt;
   SF=[Fb Fc];
  Features=[Features;SF Fa];
end


Dist=dist(Features');
k=size(Dist,1);
Dgp=sum(Dist(:))/(2*k*(k-1));
for i=1:size(Dist,1)
dgp(i)=(1/k)*sum(Dist(i,:));
D(i)=dgp(i)/Dgp;

end
plot(D,'o')
A=find(D<2);
Sig=X(A,:);
plot(D(A),'ro');

end