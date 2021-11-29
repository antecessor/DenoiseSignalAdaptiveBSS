function [map, off, match,Index,Acc,Se]=cross_check(firing,MUPulses,fs)



Fs=2048;

% firing (gold)
% MUPulses (CKC)

s1=[];

for i=1:size(firing,1) % number of MUs in the gold standard
    
    f=firing(i,:);
    index=find(f==1);
    s=[index'./Fs i*ones(length(index),1)];
    s1=[s1;s];
    %disp('ok');
    %1./mean(diff(index./Fs))
end;

[B,I] = sort(s1(:,1));
s1=s1(I,:);


s2=[];

for i=1:length(MUPulses) % number of MUs in the test
    
    f=MUPulses{1,i};
    
    s=[f'./Fs i*ones(length(f),1)];
    %disp('ok');
    %1./mean(diff(index./Fs))
    s2=[s2;s];
end;

[B,I] = sort(s2(:,1));
s2=s2(I,:);

[map, off, match,Index] = fp_compare (s1, s2);
Acc=[];
Se=[];
for i=1:length(map)
    if map(i)~=0
        disp([' MU gold standard no. ' num2str(i) ' matched to MU CKC no. ' num2str(map(i)) ' details :']);
        %Index(i,map(i))
       
    [Sp_Flag,xm,sd,pd,nI]=Main_Firing_Analysis_1(MUPulses{map(i)}/fs);

        TP=length(Index(i,map(i)).ok);
        %FP1=length(Index(i,map(i)).err);
        FN=length(find(s1(:,2)==i))-TP;
        FP=length(find(s2(:,2)==map(i)))-TP;
        Acc=[Acc TP/(TP+FN+FP)];
        Se=[Se TP/(TP+FN)];
        disp(['TP: ' num2str(TP) ' ; FN: ' num2str(FN) ' ; FP: ' num2str(FP)]);
        disp(['; Sp_Flag: ' num2str(Sp_Flag) ' ;nI: ' num2str(nI) ' ;pd: ' num2str(pd) ' ;sd: ' num2str(sd) ' ;CoV: ' num2str(sd/xm) '; MDR: ' num2str(1/xm)]); 
    end;
    
end;