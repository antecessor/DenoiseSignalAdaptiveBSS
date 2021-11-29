TT=zeros(1,numel(T));
m=median(T);
for i=1:numel(sFirings)
    for j=1:numel(sFirings{i})
        TT(sFirings{i}(j))=1;
    end
end
 plot(T>.5*m);hold on;plot(TT,'r')