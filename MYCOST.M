function [z,sol]=MyCost(x,ecgn,no,N)
mu=.01;
alpha=.9;

    global NFE;
    if isempty(NFE)
        NFE=0;
    end

    NFE=NFE+1;
    
    Lx = length(ecgn); 
    
      for k = 1:Lx-N
       X = no(k+N-1:-1:k);
       y = x*X;
       e(k,1) = ecgn(k,1) - y;
       p = alpha + X'*X;
       x = x+ (((2*mu*e(k,1))/p)*X)';
      end
     
     z=mse(e);
     
     
    sol.pos=x;
    sol.ans=e;
    
     
    
end