function FixedPointCKC(Z,epochsize)

g=@(x) x.^2;
w1=rand(size(Z,1),1);
w2=rand(size(Z,1),1);

Tolx=.005;
while abs(w1'*w2-1)<.005
    w1=w2;
    P=g(w2'*Z)';
    A=P'*P;
    w2=(Z*P')-A*w2;
    
end


end