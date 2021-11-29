function MM=removeMUAPwithCond(M,fs)
MM={};
for i=1:numel(M)
    [Sp_Flag,xm,sd,pd,nI]=Main_Firing_Analysis_1(M{i}/fs);
       if nI<100
           MM{i}=M{i};
       end
%          if 1/xm <200
%              MM{i}=M{i};
%          end
end

end