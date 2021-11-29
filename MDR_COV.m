function [MDR,CoVv]=MDR_COV(sFirings,M)
IPT=ConvertMUAP2IPT(sFirings,65536);
data.fsamp=4096;
%%
for i=1:numel(M)
    [Sp_Flag(i),xm(i),sd(i),pd(i)]=Main_Firing_Analysis_1(M{i}/data.fsamp);
end
% M=removeMUAPwithCond(M,data.fsamp);
[map, off, match,Index,Acc,Se]=cross_check(IPT,M,data.fsamp); 
%%
for i=1:numel(sFirings)
    xmGold(i)=1/mean(diff(sFirings{i}/data.fsamp));
end

a=find(map~=0);
for i=1:numel(a)
    MATCH(i)=(a(i));
end
MDR=xmGold(MATCH)';
%%
for i=1:numel(sFirings)
    sd1=sqrt(var(diff(sFirings{i}/data.fsamp)));
    COVGold(i)=sd1*xmGold(i);
end
% 
% for i=1:numel(M)
%     sd1=sqrt(var(diff(M{i}/data.fsamp)));
%     COV(i)=sd1/xm(i);
% end
for i=1:numel(M)
    CoV(i)=sd(i)/xm(i);
end

a=find(map~=0);
for i=1:numel(a)
    MATCH(i)=(a(i));
end
CoVv=COVGold(MATCH)';
end