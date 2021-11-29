function Ry=calcCorrMat(Y,extFact,lag,T)
% Ry=calcCorrMat(Y,extFact,T);
%
% Calculates the correlation matrix for array Y (array of measurements)
% in which each row is a measurement and each column is a vector of 
% measurements at given time index (sample). Before calculating the
% correlation matrix, the array of measurements Y is extended by adding
% "extFact" of delayed repetitions of each measurement. To prevent the lack
% of memory the signals (rows) in Y are divided into subsequent epochs 
% Y(:,(k-1)*T+1:k*T) ; k=1,2,... of size of T samples. For each epoch 
% local correlation matrix is calculated. All the local matrices are finally
% summed together to form the global correlation matrix of extended 
% measurements in Y.
%
% Inputs: 
%   Y - the array of measurements (row-vise measurements)
%   extFact - the number of delayed repetitions of each measurement (row) in Y
%   T - the maximal allowed epoch length. 
% Outputs:
%   Ry - Global correlation matrix
% AUTHOR: Ales Holobar, FEECS, University of Maribor, Slovenia

if nargin<3
    T=10000; 
    lag=0;
elseif nargin<4
    T=10000; 
end

[r,c]=size(Y);
Ry=zeros(r*extFact);
h=waitbar(0,'Calculating correlation matrix of measurements...');
for k=1:floor(c/T)     
    eY=extend(Y(:,(k-1)*T+1:k*T),extFact);
    if lag>=0
        Ry=Ry+eY(:,1:end-lag)*eY(:,1+lag:end)';  % !!! symetry not used
    else
        Ry=Ry+eY(:,1-lag:end)*eY(:,1:end+lag)';
    end
    clear eY; 
    waitbar(k/floor(c/T),h);
end
if isempty(k)
    k=0;
end
eY=extend(Y(:,k*T+1:end),extFact);

if lag>=0    
    Ry=(Ry+eY(:,1:end-lag)*eY(:,1+lag:end)')/(c+extFact-1);
else    
    Ry=(Ry+eY(:,1-lag:end)*eY(:,1:end+lag)')/(c+extFact-1);
end
clear eY;

% tmpRy=Ry;
% for k=1:size(Ry,1)
%     for m=1:size(Ry,2)
%        Ry(k,m)=tmpRy(k,m)/sqrt(tmpRy(k,k)*tmpRy(m,m));
%    end
% end

close(h);
