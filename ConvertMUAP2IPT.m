function IPT=ConvertMUAP2IPT(MUAP,len)
IPT=zeros(numel(MUAP),len);
for i=1:numel(MUAP)
    for j=1:numel(MUAP{i})
    IPT(i,MUAP{i}(j))=1;
    end
end

end