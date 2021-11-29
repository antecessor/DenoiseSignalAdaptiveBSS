function SD=FilterSD(X)
%% SD
SD={};
for j=1:size(X,2)
    for i=1:size(X,1)-1
        if ~isempty(X{i,j})
        SD{i,j} =X{i,j}-X{i+1,j};
        end
    end
end
%%

end