function [Tend,SelectedInd,dataPeakIndex,M,MyPNR]=CKC_Gradient(eY,epochsize,iter,Numcluster,initailPos,InitailUser,fsamp)


%% Normalization
for i=1:size(eY,1)
   eY(i,:)=detrend( (eY(i,:)-min(eY(i,:)))./(max(eY(i,:))-min(eY(i,:))));
end

f=@(x)  log10(1+x.^2);  %% differentiate of f
epochData=eY(:,1:end-10);

 [v,m] = findpeaks(epochData(1,:),'MinPeakHeight',abs(max(epochData(1,:)))*.55,'MINPEAKDISTANCE',5); 
    if numel(m)<iter
       [v,m]= findpeaks(epochData(1,:),'MinPeakHeight',abs(max(epochData(1,:)))*.3,'MINPEAKDISTANCE',5);     
    end
[~,ind]=sort(v,'descend');
m=m(ind);


eta=@(t) 100*exp(-t);
pin=pinv(epochData*epochData')*epochData;

% invpin=pinv(pin);
Tend=[];
if InitailUser==1
   iter=numel(initailPos);    
end

SelectedInd=[];
 MyPNR=[];
for it=1:iter 
    K=1;
    pintemp=pin;
    if InitailUser==0
        mm=randi(numel(m)-2);
        SelectedInd=[SelectedInd mm];
        Ctx=eY(:,m(mm) ); %
          m(mm)=[];
    else
         Ctx=eY(:,initailPos(it) ); %
    end
    
       
         tj=0;
         Sk=0;
         Sk1=1;
         CoV=0;
         EpochEnd=50;
         thresh=.008;
       T=((Ctx)'*pin)';
        T=(T-min(T))/(max(T)-min(T));
        Ctx=mean(T*Ctx')';
        T=((Ctx)'*pin)';
         T=(T-min(T))/(max(T)-min(T));
          Ctx=mean(T*Ctx')';
			pnr=0;
     while abs(Sk-Sk1)>thresh && K<EpochEnd 
        
         
      
             K=K+1;

      
        
           
            tjold=tj;
             if K<5
            tjold=-1;
            end
            tj=Ctx'*pintemp;
            
           
%              tj=(tj-min(tj))/(max(tj)-min(tj));
            Sk1=Sk;
            Sk=norm(tjold-tj,2);
%             tj=tj/max(tj(:));
            
            Dk=sum(repmat(f(tj),size(epochData,1),1).*epochData,2); 
            Ctx=Ctx-((1/min(Dk)))*100*Dk;
     
%             Rss=repmat(Ctx',size(Cxx,1),1);
%             Rww=Cxx-Rss;
%             W=Rss*pinv(Rss+Rww);
            
            T=(Ctx)'*pintemp;
            T=(T-min(T))/(max(T)-min(T));
            
           
            
            [IndexPeak,tresh]=PeakDetection(T,fsamp);
             Ind=CheckPeak(tresh,T,IndexPeak,eY);
             IndexPeak=[IndexPeak Ind'];
             IndexPeak=unique(IndexPeak);
            T0=setdiff(1:numel(T),IndexPeak);
             try
            pnr=10*log10(mean(T(IndexPeak).^2)/mean(T(T0).^2));
            catch
               pnr=0; 
            end
            
            %              [ind,pea] = findpeaks(T,'MinPeakHeight',.6,'MINPEAKDISTANCE',5); 
%              if numel(pea)>5
%                 [Sp_Flag,xm,sd,pd,nI]=Main_Firing_Analysis_1(pea/fsamp);
%                 CoV=sd/xm;
%              else
%                  CoV=0;
%              end
            figure(1)         
            subplot(2,1,2)
            plot(T(round(numel(T)/2)-200:round(numel(T)/2)+200));
             xlabel(['Iteration:' num2str(it) ' Epoch:' num2str(K) ' s(k)-s(k-1):' num2str(abs(Sk-Sk1))] )   
             axis tight; 
             subplot(2,1,1)
              axis tight;
            plot(T)
             pause(.001)
            if numel(IndexPeak)==1
                 CoV=0;
            else
               [Sp_Flag,xm,sd,pd,nI]=Main_Firing_Analysis_1(IndexPeak/fsamp);
              if nI>50 || pd<0.50
                  T0=setdiff(1:numel(T),IndexPeak);
                 pintemp(:,T0)=pintemp(:,T0)*.96;
              end
               CoV=sd/xm; 
             hold on;plot(IndexPeak,T(IndexPeak),'o');hold off;
    pause(.1);
           
            end
%         ;
        
     end

     if CoV==0
        T=[]; 
     end
	 
if isempty(T) || 1/xm>30
    Tend(it,:)=zeros(1,size(pin,2));
else
	MyPNR=[MyPNR pnr];
     Tend(it,:)=T;
  
end    
end
%%
J=[];
for i=1:size(Tend,1)
    if numel(find(Tend(i,:)==0))==numel(Tend(i,:))
     J=[J i];   
    end
end
Tend(J,:)=[];
%% clustering
% T(1:20)=[];
% T(end-20:end)=[];
dataPeakIndex={};
M={};
for j=1:size(Tend,1)
   IndexPeak=PeakDetection(Tend(j,:),fsamp);
    M{j}= IndexPeak;
end

end