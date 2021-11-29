function Ind=CheckPeak(tresh,T,IndexPeak,eY)
samples_window=20;
k=1;
MU=[];
for i=1:numel(IndexPeak)
    try
    MU(k,:)=(mean(eY(:,IndexPeak(i)-samples_window:IndexPeak(i)+samples_window)));
    k=k+1;
    catch
    end
    
end
if isempty(MU)
    Ind=[];
    return
end
MU=mean(MU);
t1=tresh-.1*tresh;
t2=tresh+.1*tresh;

ind=(T>t1 & T<t2);
ind=find(ind==1);

Ind=[];
for i=1:numel(ind)
    try
   MUtemp=mean(eY(:,ind(i)-samples_window:ind(i)+samples_window)); 
    R=corrcoef(MUtemp,MU);
   R=abs(R(1,2));
   if R>.75
        Ind=[Ind;ind(i)];
   end
    catch
        
    end
  
end







end