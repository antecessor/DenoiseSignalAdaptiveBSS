function NewMUAP=PostProcessing(eY,M,fs,length)
NewMUAP={};
cd('D:\Personal\lesson UI MSc\Payan Name\CKCMthod_Me\GA')
for i=1:numel(M)
MM=M{i};

NewMUAP{i}=OptimizePd(MM,fs,length);


end
cd('D:\Personal\lesson UI MSc\Payan Name\CKCMthod_Me')
end