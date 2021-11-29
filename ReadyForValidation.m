function [s1,s2]=ReadyForValidation(MUAP,s,fs,method)
for i=1:numel(MUAP)
    MUAP{i}(2,:)=i;
end
s2=cell2mat(MUAP);
[~,ind]=sort(s2(1,:));
s2=s2(:,ind);
%%
if method==1
    for i=1:numel(s)
        s{i}(2,:)=i;
    end
    s1=cell2mat(s);
    [~,ind]=sort(s1(1,:));
    s1=s1(:,ind);
else
%%
S1main=[];
S1mainMUAPind=[];
for i=1:size(s,1)
    Ss=find(s(i,:)==1);
    S1main=[S1main Ss];
    S1mainMUAPind=[S1mainMUAPind i*ones(1,numel(Ss))];
end
s1=[S1main;S1mainMUAPind];
end
%%
s1(1,:)=s1(1,:)*fs/1000;
s2(1,:)=s2(1,:)*fs/1000;
end