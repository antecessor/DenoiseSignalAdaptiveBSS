function x = hpbutter (x, cutoff_frequency,fsamp)
% first-order low-pass butterworth filter
% applied in forward and reverse directions (like filtfilt)

% Copyright (c) 2006. Kevin C. McGill and others.
% Part of EMGlab version 0.9.
% This work is licensed under the Aladdin free public license.
% For copying permissions see license.txt.
% email: emglab@emglab.stanford.edu

dt = 1/fsamp;

if cutoff_frequency > 0;    
    if cutoff_frequency > 1/2/dt;
        error ('Cutoff frequency must be less that half the sampling rate.');
    end;
    g = cos (2*pi*cutoff_frequency*dt);
    b = roots([2*g, 2*(1-g), g-1]);
    b = b(b>=0 & b<=1);
    a = [1, 2*b-1];
    b = [1-b, b-1];
    x = filter (b, a, x(end:-1:1,:), x(end,:)*b(2));
    x = filter (b, a, x(end:-1:1,:), 0);    
end;