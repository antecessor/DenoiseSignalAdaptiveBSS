firings=unique(cell2mat(sFirings));
firings=firings(1:50);
%%
for c=1:10:100
    figure
    plot(firings,eY(c,firings),'or');
    hold on
    plot(eY(c,1:500))
end