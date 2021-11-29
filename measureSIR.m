function sir=measureSIR(Y,N);

[r,c]=size(Y);

for k=1:r
    sir(k) = round(100*(1-sqrt( mean((Y(k,:)-N(k,:)).^2)/mean(Y(k,:).^2) )));
end