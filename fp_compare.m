%% comparing firing pattern function
function [map, off, match,Index] = fp_compare (s1, s2)
tol =10e-3;
if isempty(s1) | isempty(s2);
    map = [];
    off = [];
    return
end;
n1 = max(s1(:,2));
n2 = max(s2(:,2));
map = zeros(n1,1);
match = zeros(n1,n2);
rmatch = match;
qmatch = match;
moff = match;
p0 = max(min(s1(:,1)),min(s2(:,1)))-tol;
q0 = min(max(s1(:,1)),max(s2(:,1)))+tol;
for i1=1:n1
    t1 = s1(s1(:,2)==i1,1);
    m1 = sum(t1>p0 & t1<q0);
    if ~isempty(t1);
        for i2=1:n2;
            t2 = s2(s2(:,2)==i2,1);
            if ~isempty(t2);
                m2 = sum(t2>p0 & t2<q0);
                p = max(t1(1),t2(1))-tol;
                q = min(t1(end),t2(end))+tol;
                x1 = t1(t1>p & t1<q);
                x2 = t2(t2>p & t2<q);
                if ~isempty(x1) & ~isempty(x2);
                    d = x1 - nearest(x2,x1);
                    ix = find(abs(d)<.01);
                    off = median(d(ix));
                    if isnan(off)
                        off=0;
                    end
                    n = sum(abs(d-off)<tol);
                    Index(i1,i2).err=find(abs(d-off)>=tol);
                    Index(i1,i2).ok=find(abs(d-off)<tol);
                    match(i1,i2) = n;
                    rmatch(i1,i2) = n/min(length(x1),length(x2));
                    qmatch(i1,i2) = n/max(m1,m2);
                    moff(i1,i2) = off;
                end;
            end;
        end;
    end;
end;
x = find(qmatch < 0.7 & (rmatch<0.25 | match<6));
match(x) = 0;
for i2 = 1:n2;
    [b,i1] = max(match(:,i2));
    match(:,i2) = 0;
    match(i1,i2) = b;
end;
for i1 = 1:n1;
    [b,i2] = max(match(i1,:));
    if qmatch(i1,i2)>0.7 | (b>5 & rmatch(i1,i2)>0.25);
        map(i1) = i2;
        off(i1) = moff(i1,i2);
    end;
end;


function y1 = nearest (x, y)
% Find elements of x that are nearest to those in y.

% Copyright (c) 2006-2009. Kevin C. McGill and others.
% Part of EMGlab version 1.0.
% This work is licensed under the Aladdin free public license.
% For copying permissions see license.txt.
% email: emglab@emglab.net

	lx = length(x);
	ly = length(y);
	if lx==0 | ly==0; 
		y1 = [];
		return;
	elseif ly==1 & lx==1;
        y1 = x;
        return;
    elseif ly==1;
		if y<x(1);
			y1 = x(1);
		elseif y>x(lx);
			y1 = x(lx);
		else
			i = max(find(y>x));
			y1 = x(i + (x(i+1)-y < y-x(i)) );
		end;
		return;
	end;
	x = x(:);
	y = y(:);
	y1 = zeros(length(y),1);
	i1 = find(y<=x(1));
	i2 = find(y>x(1) & y<x(length(x)));
	i3 = find(y>=x(length(x)));
	[b,i] = sort([x;y(i2)]);
	ui(i) = 1:length(i);
	u = ui(length(x)+1:length(ui)) - (1:length(i2));
	if length(i1) > 0;
		y1(i1) = x(1)*ones(length(i1),1);
	end;
	if length(i2) > 0;
		y1(i2) = x(u + round((y(i2)-x(u))./(x(u+1)-x(u)))');
	end;
	if length(i3) > 0;
		y1(i3) = x(length(x))*ones(length(i3),1);
	end;
	
