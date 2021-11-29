function X=PowerLineRemove(X,fs,method)
if method==1   %% Comb
fo = 60;  q = 35; bw = (fo/(fs/2))/q;
[b,a] = iircomb(round(fs/fo),bw,'notch');
    for i=1:size(X,1)
        X(i,:)=filtfilt(b,a,X(i,:));
    end
  fo = 50;  q = 35; bw = (fo/(fs/2))/q;
[b,a] = iircomb(round(fs/fo),bw,'notch');
    for i=1:size(X,1)
        X(i,:)=filtfilt(b,a,X(i,:));
    end

elseif method==2   %%Interpolate
   for i=1:size(X,1)
        FT=fft(X(i,:));
        A=abs(FT);
        P=angle(FT);
        A=hampel(A);
        FT=A.*exp(1i*P);
        X(i,:)=real(ifft(FT));
    end
    
    
end

end