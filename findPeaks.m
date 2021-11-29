function [peaksLocation,peaksHight,hillStart,hillEnd]=findPeaks(y)
% finds all peaks in the array y

peaksLocation = [];
peaksHight = [];
hillStart = [];
hillEnd = [];

tmp_y = y;
eps = prctile(abs(y),2);
while max(abs(tmp_y)) > eps;

    [m,m_x] = max(tmp_y);
    [min_x,m_x,max_x]=findHillLim(tmp_y,m_x,length(y));
    
    peaksLocation(end+1) = m_x;
    peaksHight(end+1) = m - mean([y([min_x,max_x])]);
    hillStart(end+1) = min_x;
    hillEnd(end+1) = max_x;
    
%     figure; hold on; cla; 
%     plot(tmp_y); plot(m_x,tmp_y(m_x),'ro'); 
%     plot(min_x,tmp_y(min_x),'g+'); 
%     plot(max_x,tmp_y(max_x),'g+');
%     pause(2)
    
    tmp_y([min_x:max_x]) = 0;
      
end
    