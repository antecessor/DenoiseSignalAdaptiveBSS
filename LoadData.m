function data=LoadData(Name)
% cd('D:\Personal\lesson UI MSc\Payan Name\CKCMthod_Me\BF04');
% data = sEMG_loader('32TuZhVA091021144704.sig');
% cd('D:\Personal\lesson UI MSc\Payan Name\CKCMthod_Me');
%%
load(Name);
%%
% load('RampSignals_BB_500_SynSEMG_Lib1_10MVC_N262_M90_run1.mat')
% load('RampSignals_BB_500_SynSEMG_Lib1_20MVC_N341_M90_run1.mat');
% load('sendit.mat')
% load Data
% emg=SigMono;
% SIG=data.SIG;
%  SIG=sig_out;
% load 32TuZhVA090909164621_offset0_length20_Runs30.mat
k=1;
j=1;
for i=1:size(Data,2)
    if j<7
        emg(k,:)=Data(:,i);
        k=k+1;
    end
    if j>8
        j=1;
    end
    j=j+1;
    
end
% for i=1:size(SIG,1)
%     for j=1:size(SIG,2)
%         if ~isempty(SIG{i,j}) %%&& discardChannelsVec(i,j)==0
%             emg(k,:)=SIG{i,j};
%             k=k+1;
%         end
%     end
% end
% load p9_flexion30.mat
% load Data;
% nC=12;nR=6;

% emg=SIG;%sig;%sb;

% D={};count=0;
% for j=1:nC
%     for i=1:nR
%         count=count+1;
%         if any(art_b==count)
%             D{i,j}=[];
%         else
%             D{i,j}=emg(:,count);
%         end;
%         
%     end;
% end;

%% Select Section

% Twanted=[8.4738 18.4468]*fs;
% emg=emg(:,Twanted(1):Twanted(2));

%%
% emg=diff(emg);
data.SIG = emg;
data.signal_length = size(emg,1);
data.montage = 'MONO';
data.IED = 8;
data.fsamp = 2048;
data.gain = 1;
data.AUXchannels = [];
% data.firing=firing;
end