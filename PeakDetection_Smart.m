function m=PeakDetection_Smart(T,fs)

[v,m] = findpeaks(T,'MinPeakHeight',abs(max(T))*.55,'MINPEAKDISTANCE',5); 
 

end