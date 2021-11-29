function eS=extend(S,extFact,bar);  
% eS=extend(S,extFact,bar);  
%
% Extends the signals (rows) in array of signals S by adding the delayed
% repetitions of each signal (row). 
%
% Inputs: 
%   S - the row-vise array of sampled signals
%   extFact - the number of delayed repetitions of each signal (row) in S
%   bar - displays the waitbar when present (nargin>2) . 
% Outputs:
%   eS - extended row-vise array of signals
%
% AUTHOR: Ales Holobar, FEECS, University of Maribor, Slovenia

[r,c]=size(S);
eS=zeros(r*extFact,c+extFact-1);

if nargin>2
	h=waitbar(0/(r*extFact),'Extending signals...');
	for k=1:r    
        for m=1:extFact           
            eS((k-1)*extFact+m,:)=[zeros(1,m-1) S(k,:) zeros(1,extFact-m)];       
        end
        waitbar((k*extFact)/(r*extFact));
	end
    close(h);
else
	for k=1:r    
        for m=1:extFact            
            eS((k-1)*extFact+m,:)=[zeros(1,m-1) S(k,:) zeros(1,extFact-m)];            
        end
	end
end