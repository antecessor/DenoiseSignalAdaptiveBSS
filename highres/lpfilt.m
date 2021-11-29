function x = lpfilt (x, cutoff_frequency);% first-order low-pass butterworth filter% applied in forward and reverse directions (like filtfilt)% Copyright (c) 2006-2009. Kevin C. McGill and others.% Part of EMGlab version 1.0.% This work is licensed under the Aladdin free public license.% For copying permissions see license.txt.% email: emglab@emglab.net	if cutoff_frequency > 0;		[x, t0, dt, type] = sigsep (x);		if cutoff_frequency > 1/2/dt;			error ('Cutoff frequency must be less that half the sampling rate.');		end;		g = cos (2*pi*cutoff_frequency*dt);		b = roots([2*g, 2*(1-g), g-1]);		b = b(b>=0 & b<=1);		b = b(1);		a = [1, 2*b-1];		b = [b, b];        n = ceil(1/2/cutoff_frequency);        n = max(n, 2);        n = min(n, size(x,1));  %%% 11/02/07%       N = size(x,1);%       for i=1:size(x,2);%           s1 = polyval(polyfit([1:n]',x(1:n,i),1), [-4*n:0]');%           s2 = polyval(polyfit([N-n+1:N]'-N,x(N-n+1:N,i),1), [N+1:N+4*n]'-N);%           X(:,i) = [s1;x(:,i);s2];%       end;%       x = X;                xi = 0;        for i=1:size(x,2);            g = x(end-n+1:end,i);            s = polyval(polyfit([1:n]',g,min(size(g,1)-1,1)), [n-1;n]);            xx = 2*s(end,:) - s(end-1,:);             xi(:,i) = xx*(sum(b)/sum(a) - b(1)/a(1));        end;		x = filter (b, a, x(end:-1:1,:), xi);        for i=1:size(x,2);            g = x(end-n+1:end,i);            s = polyval(polyfit([1:n]',g,min(size(g,1)-1,1)), [n-1;n]);            xx = 2*s(end,:) - s(end-1,:);             xi(:,i) = xx*(sum(b)/sum(a) - b(1)/a(1));        end;        x = filter (b, a, x(end:-1:1,:), xi);%       x = x(4*n+2:4*n+1+N,:);        		x = mksig (x, t0, dt, type);	end;