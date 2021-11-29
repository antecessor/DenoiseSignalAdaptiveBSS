function [minInd,newx,maxInd]=findHillLim(y,x,Lim)
% [minInd,newx,maxInd]=findHillLim(y,x,Lim)
% Finds the nearest optimum (hill) in signal y and returns its start (minInd) peak (newx) and end (maxInd) position. 
% x determines the center of the search area, whereas Lim is a radius of search area.

if nargin<3;
    Lim = 100;
end

tmp=diff(y);

if x>length(tmp) || abs(tmp(x))==0
    minInd=x;
    maxInd=x;
    newx=x;
    return;
end   

dx=tmp(x)/abs(tmp(x));
 
% find maximum of the hill;
newx=x;
 while newx > 1 & newx < length(y) & y(newx+dx) > y(newx) 
    newx = newx + dx;
 end

minInd=newx;
maxInd=newx;

while minInd>1 & y(minInd-1)<y(minInd) & newx-minInd < Lim
    minInd = minInd - 1;
end
while maxInd<length(y)-1 & y(maxInd+1)<y(maxInd) & maxInd-newx < Lim
    maxInd = maxInd + 1;
end

    
  


