function xcor=fxcorr(Ind1,Ind2,Lim)
% does exactly the same thing as xcorr, but is specialized for sequences of binary pulses and, thus, much faster
xcor=zeros(2*Lim+1,1);
for k=-Lim:Lim
    xcor(k+Lim+1)=length(intersect(Ind1,Ind2+k));
end