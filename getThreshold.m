function threshold = getThreshold (sig)

% Choose noise SD based on baseline noise amplitude.


COEF = 10e5;
   
    l = length(sig);
    s = sort(abs(sig(1:l)));
    sd = sqrt(cumsum(s.^2)./(1:l));
    i = find(COEF*sd>s, 1, 'last' );
    if isempty (i);
        threshold = s(round(.9*length(s)));  % non-physiological baseline
    else
        threshold = s(i);
    end;

threshold=threshold/COEF;
end