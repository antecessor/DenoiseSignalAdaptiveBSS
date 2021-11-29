function PowerLineFilter(X,Fs)
x=X(1,:);
Y = fft(x);
L=size(x,2);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
f = Fs*(0:(L/2))/L;
plot(f,P1)
end