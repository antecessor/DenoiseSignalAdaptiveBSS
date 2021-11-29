function [P,MUAP]=CKC_FCM(X,Y,exfactor,NumberOfCluster)
Rx=calcCorrMat(Y,exfactor,0,1000);
channel=1;
thr=max(X(channel,:))*0.5;
phiIZ=find(X(channel,:)>thr);
m=numel(phiIZ);
if m>100
    m=100;
end
randPermutation=randperm(numel(phiIZ));
phiJM=phiIZ(randPermutation(1:m));
phiNK=[];
for i=1:numel(phiJM)
    P{i}=X(:,phiJM(i))'*Rx*X;
   
    [peak,pos] = findpeaks(P{i});
    thresh=max(peak)*0.5;
    newPeak=peak(peak>=thresh);
    newPos=pos(peak>=thresh);
    phiNK=[phiNK newPos];
    
end
dat=[];
for i=1:numel(phiNK)
    dat=[dat; X(1,phiNK(i)-2:phiNK(i)+2)];
end
idx = kmeans(dat,NumberOfCluster);
XX=zeros(size(X,1),1);
for i=1:numel(unique(idx))
   Cxh=mean(X(:,phiNK(idx==i)),2);
   P{i}=Cxh'*Rx*X;
   [~,ind]=findpeaks(P{i},'THRESHOLD',abs((median(P{i}))),'MINPEAKDISTANCE',50);
   P{i}(:)=0;
   P{i}(ind)=1;
   MUAP{i}=ind;
end


end